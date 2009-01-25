require File.join(File.dirname(__FILE__),'framework_helpers')

if defined?(::Mack) # Can't use configurator methods here
  CaptchaService::ViewHelpers.include_safely_into Mack::Rendering::ViewTemplate
  CaptchaService::ControllerHelpers.include_safely_into Mack::Controller
end

