require 'yaml'

require File.join(File.dirname(__FILE__),'string_extensions')
require File.join(File.dirname(__FILE__),'captchator_provider')

module CaptchaService
  
  class Configurator
    
    class << self

      def get_provider(provider_designator = nil)
        configuration = get_configuration
        provider = provider_designator ? provider_designator.to_sym : configuration[:default_provider]
        provider_configuration = configuration[:providers][provider]
        if provider == :captchator
          return CaptchaService::CapchatorProvider.new
        else
          return nil
        end
      end
      
      def is_Mack?
        return defined?(::Mack)
      end
      
      def is_Rails?
        return defined?(::RAILS_ROOT)
      end
      
      def clear_cache(which_cache = :process)
        if which_cache == :process
          if defined?(@@cached_configurations)
            pid = $$
            @@cached_configurations.delete(pid)
          end
        elsif which_cache == :all
          @@cached_configurations = {}
        end
      end
      
      def get_configuration
        begin
          pid = $$
          @@cached_configurations = {} if ENV['CAPTCHA_SERVICE_CACHE_RESET']
          @@cached_configurations = {} unless defined?(@@cached_configurations)
          configuration = @@cached_configurations[pid]
          return configuration if configuration
          # In order, check external (i.e. environment), configatron, application_configuration
          # Support Mack and RAILS
          default_configuration_filename = File.join(File.dirname(__FILE__),'captcha_service_config.yml')
          base_configuration_filename = default_configuration_filename
          if ENV['CAPTCHA_SERVICE_CONFIGURATION_FILE']
            base_configuration_filename = ENV['CAPTCHA_SERVICE_CONFIGURATION_FILE']
          elsif defined?(::Configatron)
            base_configuration_filename = configatron.captcha_service.configuration_filename
          elsif defined?(::Application::Configuration)
            base_configuration_filename = app_config.captcha_service[:configuration_filename]
          end
          unless base_configuration_filename and base_configuration_filename.kind_of?(String)
            captcha_service_logger(:error, 
              "CaptchaService::Configurator no base configuration file name specified. See documentation.", 
              {:raise_if_no_logger => true})
            return nil
          end
          app_env = nil
          # Check for Mack, then RAILS
          if is_Mack?
            app_env = Mack.env.to_s.downcase
          end
          if is_Rails?
            app_env = RAILS_ENV.to_s.downcase
          end
          unless app_env
            app_env = ENV['CAPTCHA_SERVICE_ENVIRONMENT']
          end
          env_configuration_filename = nil
          if app_env
            dirname = File.dirname(base_configuration_filename)
            basename = File.basename(base_configuration_filename,'.*')
            extension = File.extname(base_configuration_filename)
            env_configuration_filename = File.join(dirname,"#{basename}_#{app_env}#{extension}")
          end
          if File.exists?(base_configuration_filename)
            configuration =  YAML.load(File.open(base_configuration_filename))['captcha_service']
            if env_configuration_filename
              if File.exists?(env_configuration_filename)
                env_configuration = YAML.load(File.open(env_configuration_filename))['captcha_service']
                configuration = configuration.merge(env_configuration)
              else
                captcha_service_logger(:info, 
                "CaptchaService::Configurator: Unable to find environment-specific configuration file #{env_configuration_filename}",
                {:raise_if_no_logger => false})
              end
            end
            @@cached_configurations[pid] = configuration
          else
            captcha_service_logger(:error, 
              "CaptchaService::Configurator: Unable to find base configuration file #{base_configuration_filename}",
              {:raise_if_no_logger => true})
            return nil
          end
          return configuration
        rescue Exception => ex
          captcha_service_logger(:error, 
            "CaptchaService::Configurator error loading configuration #{ex.to_s} \n" + ex.backtrace.join("\n") , 
            {:raise_if_no_logger => true})
          return nil
        end
      end
      
      def captcha_service_logger(level, msg, options = {})
        if is_Mack?
          eval("Mack.logger.#{level.to_s}(msg)")
          return true
        end
        if is_Rails?
          eval("RAILS_DEFAULT_LOGGER.#{level.to_s}(msg)")
          return true
        end
        if options[:raise_if_no_logger]
          raise Exception.new(msg)
        end
        return false
      end
    end
    
  end
end
