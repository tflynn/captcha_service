module CaptchaService
end

base = File.join(File.dirname(__FILE__), "captcha_service")

require File.join(base,'string_extensions')
require File.join(base,'configurator')
require File.join(base,'captchator_provider')
require File.join(base,'mollom_provider')
require File.join(base,'rails_support') if CaptchaService::Configurator.is_Rails?
require File.join(base,'mack_support') if CaptchaService::Configurator.is_Mack?


