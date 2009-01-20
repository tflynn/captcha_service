module CaptchaService
end

base = File.join(File.dirname(__FILE__), "captcha_service")

Dir.glob(File.join(base, "**/*.rb")).each do |f|
  next unless f =~ /\.rb$/
  f.gsub!(/\.rb$/,'')
  require File.expand_path(f)
end

if CaptchaService::Configurator.is_Rails?
  ActionView::Base.send :include, CaptchaService::ViewHelpers
  ActionController::Base.send :include, CaptchaService::ControllerHelpers
elsif CaptchaService::Configurator.is_Mack?
  CaptchaService::ViewHelpers.include_safely_into Mack::Rendering::ViewTemplate
  CaptchaService::ControllerHelpers.include_safely_into Mack::Controller
end