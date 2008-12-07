require 'net/http'
require 'uri'

require 'rubygems'
gem 'mollom','0.1.4'
require 'mollom'

require File.join(File.dirname(__FILE__),'string_extensions')

module CaptchaService
  
  class MollomProvider
    
    def get_mollom_requester
      provider, captcha_configuration = CaptchaService::Configurator.get_provider_configuration(:mollom)
      mollom_requester = Mollom.new(:private_key => captcha_configuration[:private_key], :public_key => captcha_configuration[:public_key])
      return mollom_requester
    end
    
    def image_tag
      mollom_requester = get_mollom_requester
      key = "helium_captcha_#{String.randomize(20)}"
      url = mollom_requester.image_captcha(:session_id => key)["url"]
      return [key,"<img src=\"#{url}\" />"]
    end

    def verify_answer(key,answer)
      mollom_requester = get_mollom_requester
      answer = mollom_requester.valid_captcha?(:session_id => key, :solution => answer)
      return answer
    end
  
  end
  
end
