require File.join(File.dirname(__FILE__),'framework_helpers')

if CaptchaService::Configurator.is_Rails?
  ActionView::Base.send :include, CaptchaService::ViewHelpers
  ActionController::Base.send :include, CaptchaService::ControllerHelpers
end
