require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe 'CaptchatorProvider' do
  
  it "should generate a random image tag" do
    captchator_provider = CaptchaService::Configurator.select_service(:captchator)
    puts captchator_provider.image_tag
  end  
    
end
