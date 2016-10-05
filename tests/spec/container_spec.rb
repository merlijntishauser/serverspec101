require 'spec_helper'
require 'socket'
require 'timeout'


HTTP_PORT = 80
HTTPS_PORT = 443

describe "Container" do

  def is_port_open(ip, port)
    begin
      Timeout::timeout(1) do
        begin
          s = TCPSocket.new(ip, port)
          s.close
          return true
        rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
          return false
        end
      end
    rescue Timeout::Error
    end

    return false
  end

  before(:all) do
    @image = Docker::Image.build_from_dir('../')

    set :os, family: :debian
    set :backend, :docker
    set :docker_image, @image.id
  end

  describe 'when running' do
    before(:all) do
      @container = Docker::Container.create(
          'Image' => @image.id,
          'HostConfig' => {
            'PortBindings' => {
              "#{HTTP_PORT}/tcp" => [{ 'HostPort' => "#{HTTP_PORT}" }],
              "#{HTTPS_PORT}/tcp" => [{ 'HostPort' => "#{HTTPS_PORT}" }]
            }
          }
      )
      @container.start
    end

    it "should be the 16.04 version of Ubuntu" do
      os_version = command('lsb_release -a').stdout
      expect(os_version).to include('16.04')
      expect(os_version).to include('Ubuntu')
    end

    describe package('apache2') do
      it { should be_installed }
    end

    it "allow connections to port #{HTTP_PORT}" do
      expect(is_port_open('127.0.0.1', "#{HTTP_PORT}")).to be true
    end

    it "allow connections to port #{HTTPS_PORT}" do
      expect(is_port_open('127.0.0.1', "#{HTTPS_PORT}")).to be true
    end

    after(:all) do
      @container.kill
      @container.delete(:force => true)
    end

  end

end
