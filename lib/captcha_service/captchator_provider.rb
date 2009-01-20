require 'net/http'
require 'uri'

require File.join(File.dirname(__FILE__),'string_extensions')

module CaptchaService
  
  class CapchatorProvider
    
    def image_src
      key = "helium_captcha_#{String.randomize(20)}"
      return [key, "http://captchator.com/captcha/image/#{key}"]
    end

    def verify_answer(key,answer)
      begin
        verification_url = "http://captchator.com/captcha/check_answer/#{key}/#{answer}"
        #puts "verification_url #{verification_url}"
        uri = URI.parse(verification_url)
        answer = nil
        Net::HTTP.start(uri.host) do |http_request|
          response = http_request.get(uri.path)
          #puts "code: #{response.code}"
          #puts "message: #{response.message}"
          #puts "body >>#{response.body}<<"
          answer = response.body.strip.chomp
        end
        #puts "answer #{answer}"
        return answer == '1' ? true : false
      rescue Exception => ex
        CaptchaService::Configurator.captcha_service_logger(:error, 
          "CaptchaService::CapchatorProvider: error while verifying answer #{ex.to_s}",
          {:raise_if_no_logger => false})
        return false
      end
    end
  
  end
  
end
