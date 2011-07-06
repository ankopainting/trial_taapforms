

module Taapforms
  module SchemaScope
    extend ActiveSupport::Concern
    
    included do
      Rails.logger.info "SchemaScope included"
      attr_accessor :schemas, :current_role
      @current_role = :default
      @schemas = {}
      # TODO: default role/schema should include all fields
    end
    
    module ClassMethods
      # This class lets you define methods inside schema(role) blocks in your model
      class SchemaDefinition
        attr_accessor :fields
        
        def initialize(&block)
          @fields = []
          instance_eval &block
        end
        
        # TODO: should we check if this field exists in the model?
        def use(field)
          Rails.logger.info "  use called on #{field}"
          @fields << field
        end        
      end
      
      # class method on model exporting defined roles
      def defined_roles
        @schemas.keys
      end
      # class method on model exporting defined roles and fields they include
      def pp_defined_roles
        output = ""
        @schemas.each_pair do |k, v|
          output << "  role :#{k}\n"
          output << "    fields: #{v.map {|x| ":#{x}"}.join(', ')}\n"
        end
        output
      end
      
      # the schema block in models
      def schema(role = :default, &block)
        Rails.logger.info "Scope called with role #{role.to_s}"
        if block_given?
          sd = SchemaDefinition.new(&block)
          @schemas[role] = sd.fields
        else
          throw "Taapforms::SchemaScope; schema needs a block!"
        end
        Rails.logger.info "end of scope #{@current_schema}"
      end

    end
    # not needed currently
    module InstanceMethods
    end
  end
end