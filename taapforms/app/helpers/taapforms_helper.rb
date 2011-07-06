module TaapformsHelper

  # TODO: refactor! this is just a test method
  # obj is the result of a query returning one element, such as obj = User.first
  def render_schemaobject(obj, template = :view, role = :default)
    # don't do anything if obj.nil?
    return if obj.nil?
    if obj.class == Mongoid::Criteria
      throw "render_schemaobject: obj should be an object rather than a collection"
    end
    
    model_name = ActiveModel::Naming.singular(obj)

    template_directory = "#{Rails.root}/schemaobjects/#{template}/"
    unless Dir.exists? template_directory
      throw "render_schemaobject: #{template_directory} does not exist"
    end
    
    unless role == :default
      unless obj.class.defined_roles.include? role
        throw "render_schemaobject: role :#{role} isn't in model #{model_name}"
      end
    end
    
    Rails.logger.info "render_schemaobject called with template :#{template} and role :#{role}"
    Rails.logger.info "roles defined in #{model_name} model;\n" + obj.class.pp_defined_roles
    
    output_string = ""

    javascript_string = "(function () {\n"
    javascript_string << "var obj = " + JSON.pretty_generate(JSON.parse(obj.to_json)) + ";\n"
    javascript_string << "var schema = " + JSON.pretty_generate(object_to_schema(obj)) + ";\n"
    javascript_string << "})();"

    if template == :edit
      output_string = form_tag({}, {})      
      output_string << form_authenticity_token
    end
    # TODO: check for object template which overrides individual templates
    #
    
    # if object template not found, check for templates of each field
    
    obj.fields.each_pair do |f,v|
      # special names we don't want to include _type
      unless %w!_type!.include? f
        field_template_base = template_directory + v.type.to_s.downcase 
        field_template = field_template_base + ".html.erb"
        if File.exists? field_template
          #Rails.logger.info "found #{field_template}"
          this_field_value = obj[f]
          
          label = v.label || f # label of the field or field name
          options = v.options # options on the field

          output_string << render(:file => field_template_base, :locals => {:object => this_field_value, :name => label})
        else
          Rails.logger.info "render_schemaobject: Could not find #{field_template}"
        end
      end
    end
    
    output_string << content_tag(:pre, javascript_string)
    #debugger
    output_string.html_safe
  end

  # iterates an object, excluding useless fields like _type
  # TODO: include role?
  def iterate_object(obj, role)
    obj.fields.each_pair do |f,v|
      #special names we don't want to include _type
      unless %w!_type!.include? f
        yield f,v 
      end
    end
  end

  def object_to_schema(obj, role = :default)
    output_object = { :properties => {} }
    output_object[:name] = ActiveModel::Naming.singular(obj)
    iterate_object(obj, role) do |k, v|
      output_object[:properties][k] = field_to_schema(obj, k, role)
    end
    output_object
  end

  # obj should be a 
  def field_to_schema(obj, fieldname, role = :default)
    field = obj.fields[fieldname]
    
    validations = obj.class.validators_on(fieldname.to_sym)
    validation_object = {}
    hash = {}
    if field.respond_to? :type
      hash = class_to_hash(field)
      #Rails.logger.info hash
    end
    validation_object.merge!( hash )
    validation_object[:title] = obj.class.fields[fieldname].label if obj.class.fields[fieldname].label
    validations.each do |validation|
      case validation
      when ActiveModel::Validations::PresenceValidator
        validation_object[:required] = true
      when ActiveModel::Validations::LengthValidator
        if validation.options.has_key? :minimum
          validation_object[:minLength] = validation.options[:minimum]
        end
      else
      end
    end
    validation_object
  end

  # convert class to hash of type etc.
  def class_to_hash(field)
    # awful hack because String === String returns false.
    case field.type.to_s
    when 'String'
      {"type" => "string", "format" => "string"}
    when 'Boolean'
      {"type" => "boolean", "format" => "boolean"}
    when 'Time'
      {"type" => "string", "format" => "time"}
    when 'DateTime'
      {"type" => "string", "format" => "date"}
    when 'Date'
      {"type" => "string", "format" => "date-time"}
    when 'Integer'
      {"type" => "integer", "format" => "integer"}
    when 'Float'
      {"type" => "number", "format" => "integer"}
    else
      {}
    end
  end

  class JsonSchema

  end
end
