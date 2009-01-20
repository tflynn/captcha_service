module CaptchaService
  module ViewHelpers
    
    def show_captcha(options = {})
      img_options = {:height => 60, :width => 75, :id => 'captcha'}.merge(options.delete(:img) || {})
      input_options = {:id => 'captcha', :value => ''}.merge(options.delete(:input) || {})
      options = {:label => "Type in the character verification code from the image"}.merge(options)
      provider = CaptchaService::Configurator.get_provider
      input_options[:name], img_options[:src] = provider.image_src
      %[<div id='captcha_div'>
          <img #{img_options.map{|key, value| %(#{key}="#{value}")}.join(' ')} />
          <label for="captcha">#{options[:label]}</label>
          <input #{input_options.map{|key, value| %(#{key}="#{value}")}.join(' ')} />
        </div>]
    end
     
  end
end

module CaptchaService
  module ControllerHelpers
    
    protected
    
    def captcha_valid?
      key = ''
      params.each_key do |k| 
        if k =~ /^helium_captcha_/
          key = k
          break
        end
      end
      provider = CaptchaService::Configurator.get_provider
      provider.verify_answer(key,params[key])
    end
    
  end
end