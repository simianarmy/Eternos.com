module ActiveRecord
  module Associations
    class AssociationProxy #:nodoc:
      # See http://dev.rubyonrails.org/ticket/8246
      def raise_on_type_mismatch(record)
        unless record.is_a?(eval(@reflection.class_name))
          raise ActiveRecord::AssociationTypeMismatch, "#{@reflection.klass} expected, got #{record.class}"
        end
      end
    end
    
    module ClassMethods
      # Added in Rails 2.1, this method is called from has_one
      # and adds a validation check on the association.  This 
      # makes sense 80% of the time, but not in our case, when
      # checking the validity of a subscription.
      def add_single_associated_save_callbacks(association_name)
        return if association_name.to_s == 'subscription'
        method_name = "validate_associated_records_for_#{association_name}".to_sym
        define_method(method_name) do
          association = instance_variable_get("@#{association_name}")
          if !association.nil?
            errors.add "#{association_name}" unless association.target.nil? || association.valid?
          end
        end
      
        validate method_name
      end
    end
  end
end