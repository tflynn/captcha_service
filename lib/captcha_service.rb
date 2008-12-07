module CaptchaService
end

base = File.join(File.dirname(__FILE__), "captcha_service")

Dir.glob(File.join(base, "**/*.rb")).each do |f|
  next unless f =~ /\.rb$/
  f.gsub!(/\.rb$/,'')
  require File.expand_path(f)
end

