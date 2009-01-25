require File.join(File.dirname(__FILE__),'framework_helpers')

if defined?(::RAILS_ROOT) # Can't use configurator methods here
  ActionView::Base.send :include, CaptchaService::ViewHelpers
  ActionController::Base.send :include, CaptchaService::ControllerHelpers
end
