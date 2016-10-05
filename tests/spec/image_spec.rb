require 'spec_helper'

describe "Image" do

  before(:all) do
    @image = Docker::Image.build_from_dir('../')

    set :os, family: :debian
    set :backend, :docker
    set :docker_image, @image.id
  end
  
    describe 'Dockerfile#config' do
      it 'should expose the http port' do
        expect(@image.json['ContainerConfig']['ExposedPorts']).to include("#{HTTP_PORT}/tcp")
      end
      
      it 'should expose the https port' do
        expect(@image.json['ContainerConfig']['ExposedPorts']).to include("#{HTTPS_PORT}/tcp")
      end
      
      it 'should have /etc/apache2 as volume' do
        expect(@image.json['ContainerConfig']['Volumes']).to include('/etc/apache2')
      end
    end

  after(:all) do
    # optional, remove the built image before every test
    # @image.remove(:force => true)
  end

end

