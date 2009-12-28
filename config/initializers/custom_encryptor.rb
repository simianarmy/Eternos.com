# $Id$

# Encryptor module with code lifted from Lucifer plugin for aes-128-cbc encryption with config 
# files for salt/keys
# Created for attr_encrypted gem

require 'ezcrypto'

module Eternos
  module Encryptor
    # The default options to use when calling the <tt>encrypt</tt> and <tt>decrypt</tt> methods
    #
    # Defaults to { :algorithm => 'aes-128-cbc' }
    #
    # Run 'openssl list-cipher-commands' in your terminal to view a list all cipher algorithms that are supported on your platform
    class << self; attr_accessor :default_options, :key, :key_file; end
    self.default_options = { :algorithm => 'aes-128-cbc' }
    self.key_file = 'key.yml'
    
    # Encrypts a <tt>:value</tt> with a specified <tt>:key</tt>
    #
    # Optionally accepts <tt>:iv</tt> and <tt>:algorithm</tt> options
    #
    # Example
    #
    #   encrypted_value = Huberry::Encryptor.encrypt(:value => 'some string to encrypt', :key => 'some secret key')
    def self.encrypt(options)
      key_encrypt options
    end
    
    # Decrypts a <tt>:value</tt> with a specified <tt>:key</tt>
    #
    # Optionally accepts <tt>:iv</tt> and <tt>:algorithm</tt> options
    #
    # Example
    #
    #   decrypted_value = Huberry::Encryptor.decrypt(:value => 'some encrypted string', :key => 'some secret key')
    def self.decrypt(options)
      key_decrypt options
    end
    
    protected

    def self.secret_key
      self.key ||= EzCrypto::Key.with_password secret[:key], secret[:salt]
    end

    def self.secret
      @secret ||= YAML.load_file(Rails.root.join("config", key_file))[Rails.env].symbolize_keys
    end

    def self.key_encrypt(options)
      options[:encode] ? secret_key.encrypt64(options[:value]) : secret_key.encrypt(options[:value])
    end

    def self.key_decrypt(options)
      options[:encode] ? secret_key.decrypt64(options[:value]) : secret_key.decrypt(options[:value])
    rescue OpenSSL::CipherError
      RAILS_DEFAULT_LOGGER.exception "Exception in key_decrypt: " + $!
      return nil
    end
  end
end