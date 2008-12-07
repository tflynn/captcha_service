require 'net/http'
require 'uri'

require File.join(File.dirname(__FILE__),'string_extensions')

module CaptchaService
  
  class CapchatorProvider
    
    def image_tag
      key = "helium_captcha_#{String.randomize(20)}"
      return [key,"<img src=\"http://captchator.com/captcha/image/#{key}\" />"]
    end

    def verify_answer(key,answer)
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
    end
  
  end
  
end
