require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe 'Configurator' do
  
  before :each do
    CaptchaService::Configurator.clear_cache(:process)
  end
  
  it 'should supply a default configuration if none is available' do
    configuration = CaptchaService::Configurator.get_configuration
    configuration.should_not be_nil
  end

  it 'should cache configuration settings and allow them to be cleared' do
    configuration = CaptchaService::Configurator.get_configuration
    configuration[:default_provider].should == :captchator
    configuration = CaptchaService::Configurator.get_configuration
    configuration[:default_provider].should == :captchator
    CaptchaService::Configurator.clear_cache(:process)
    ENV['CAPTCHA_SERVICE_CONFIGURATION_FILE'] = File.join(File.dirname(__FILE__), 'configuration_test_file.yml')
    configuration = CaptchaService::Configurator.get_configuration
    configuration[:default_provider].should == :test_provider
  end
  
  it 'should allow a configuration file to be specified using an environment setting' do
    ENV['CAPTCHA_SERVICE_CONFIGURATION_FILE'] = File.join(File.dirname(__FILE__), 'configuration_test_file.yml')
    configuration = CaptchaService::Configurator.get_configuration
    configuration.should_not be_nil
    configuration[:default_provider].should == :test_provider
  end

  # Can't test configurator / application_configuration directly because there is no way to unload gems once loaded
  
  
end
