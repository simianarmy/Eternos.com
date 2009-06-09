# $Id$
module CustomValidations
  def validates_phone(*attributes)
    error_message = 'Phone number must contain at least 5 digits, only the following characters are allowed: 0-9/-()+'
    validates_each attributes do |record, attr, value|
      record.errors.add(attr, error_message) unless valid_phone?(value)
    end
  end
  
  def valid_phone?(number)
    return true if number.nil?
    
    n_digits = number.scan(/[0-9]/).size
    valid_chars = (number =~ /^[+\/\-() 0-9]+$/)
    return n_digits > 5 && valid_chars
  end
  
  # Checks email validity with email-veracity plugin
  def validates_email(*args)
    options = args.last.kind_of?(Hash) ? args.pop : {}
    
    validates_each args do |record, attr, value|
      address = EmailVeracity::Address.new(value)
      # domain lookup errors should be ignored or logged
      unless address.valid?
        record.errors.add(attr, options[:message]||address.errors.to_s)  
      end
    end
  end
end

ActiveRecord::Base.extend(CustomValidations)
