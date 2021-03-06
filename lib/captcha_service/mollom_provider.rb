require 'net/http'
require 'uri'

require 'rubygems'
gem 'mollom','0.1.4.1'
require 'mollom'

require File.join(File.dirname(__FILE__),'string_extensions')

module CaptchaService
  
  class MollomProvider
    
    def get_mollom_requester
      provider, captcha_configuration = CaptchaService::Configurator.get_provider_configuration(:mollom)
      mollom_requester = Mollom.new(:private_key => captcha_configuration[:private_key], :public_key => captcha_configuration[:public_key])
      CaptchaService::Configurator.captcha_service_logger(:debug,"CaptchaService::MollomProvider: get_mollom_requester captcha_configuration[:private_key] #{captcha_configuration[:private_key]} captcha_configuration[:public_key] #{captcha_configuration[:public_key]}")
      return mollom_requester
    end

    def image_tag
      begin
        mollom_requester = get_mollom_requester
        image_captcha_info = mollom_requester.image_captcha
        url = image_captcha_info["url"]
        key = image_captcha_info["session_id"]
        return [key,"<img src=\"#{url}\" />"]
      rescue Exception => ex
        CaptchaService::Configurator.captcha_service_logger(:error, 
          "CaptchaService::MollomProvider: error while obtaining image tag #{ex.to_s}",
          {:raise_if_no_logger => false})
        #raise Exception.new("CaptchaService::MollomProvider: error while obtaining image tag #{ex.to_s}")
        return nil
      end
    end
    
    def image_src
      begin
        mollom_requester = get_mollom_requester
        image_captcha_info = mollom_requester.image_captcha
        url = image_captcha_info["url"]
        key = image_captcha_info["session_id"]
        CaptchaService::Configurator.captcha_service_logger(:debug,"CaptchaService::MollomProvider::image_src key #{key} url #{url}")
        return [key, url]
      rescue Exception => ex
        CaptchaService::Configurator.captcha_service_logger(:error, 
          "CaptchaService::MollomProvider: error while obtaining image tag #{ex.to_s}",
          {:raise_if_no_logger => false})
        #raise Exception.new("CaptchaService::MollomProvider: error while obtaining image tag #{ex.to_s}")
        return nil
      end
    end

    def verify_answer(key,answer)
      begin
        mollom_requester = get_mollom_requester
        answer = mollom_requester.valid_captcha?(:session_id => key, :solution => answer)
        CaptchaService::Configurator.captcha_service_logger(:debug,"CaptchaService::MollomProvider: verify_answer answer #{answer}")
        return answer
      rescue Exception => ex
        CaptchaService::Configurator.captcha_service_logger(:error, 
          "CaptchaService::MollomProvider: error while verifying answer #{ex.to_s} ",
          {:raise_if_no_logger => false})
        return false
      end
    end
  
  end
  
end
