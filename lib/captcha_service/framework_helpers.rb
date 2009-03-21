module CaptchaService
  
  module Helpers

    def captcha_div_contents(options = {})
      img_options = {:height => 50, :width => 160, :id => 'captcha'}.merge(options.delete(:img) || {})
      img_options = {:id => 'captcha'}.merge(options.delete(:img) || {})
      input_options = {:id => 'captcha', :value => ''}.merge(options.delete(:input) || {})
      options = {:label => "Type in the character verification code from the image"}.merge(options)
      provider, provider_configuration = CaptchaService::Configurator.get_provider
      captcha_key, img_options[:src] = provider.image_src
      captcha_div = %[
          <table >
            <tr>
              <td><img #{img_options.map{|key, value| %(#{key}="#{value}")}.join(' ')} /></td>
              <td>
                <table>
                  <tr>
                    <td><label id="captcha_label" for="captcha">#{options[:label]}</label></td>
                  </tr>
                  <tr>
                    <td>
                      <input type="text" name="captcha"/>
                      <input type="hidden" name="captcha_key", value="#{captcha_key}"/>
                    </td>
                  </tr>
                  <tr>
                    <td>#{refresh_captcha_link}</td>
                  </tr>
                </table>
              </td>
            </tr>
          </table>
        ]
      
      return captcha_div
    end

    def refresh_captcha_link
      refresh_captcha_link_text = ''
      captcha_service_configuration = CaptchaService::Configurator.get_configuration
      refresh_captcha_options = captcha_service_configuration[:refresh_captcha]
      return refresh_captcha_link_text unless refresh_captcha_options[:enable_refresh_captcha]
      controller_name = refresh_captcha_options[:refresh_captcha_controller]
      action_name = refresh_captcha_options[:refresh_captcha_action]
      if CaptchaService::Configurator.is_Rails? or CaptchaService::Configurator.is_Mack?
        refresh_captcha_link_text = %[
          <a href="#" onclick="var label_contents = $('captcha_label').innerHTML; new Ajax.Request('/#{controller_name}/#{action_name}',{asynchronous:true,evalScripts:true,parameters: 'label_contents=' + encodeURIComponent(label_contents)});return false;" 
          rel="nofollow">Get another image</a>
        ]
      else
        refresh_captcha_link_text = ''
      end
      return refresh_captcha_link_text
    end
    
  end
  
  module ViewHelpers
    
    include CaptchaService::Helpers
    
     
    def show_captcha(options = {})
      div_interior = captcha_div_contents(options)
      captcha_div = %[<div id='captcha_div'>
          #{div_interior}
         </div>]
      return captcha_div
    end
     
  end
end

module CaptchaService
  module ControllerHelpers

    include CaptchaService::Helpers

    protected
    
    def captcha_valid?(parms)
      provider = CaptchaService::Configurator.get_provider
      return provider.verify_answer(parms['captcha_key'],parms['captcha'])
    end
    
  end
end

