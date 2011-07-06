Trial Taapforms
===============

Hi, this is just a starting repository so I can experiment with a rails 3.1 plugin I want to create.

Setup
-----

* clone the repository.
* make sure you have mongod running on localhost
* make sure you have ruby 1.9.2
* cd todo
* bundle install
* rails server
* goto http://localhost:3000
* add a todoitem 
* go to index or show actions
* update your model todo/app/models/todoitem.rb
* refresh the page :) 

Concept
-------

The whole concept relies on mongodb/mongoid.  This database allows you to make changes to your model and see the view updated as soon as you refresh.  It's kinda like formtastic except the rendering of each form element is in a template.

The main idea is that your application has a schemaobjects directory.  This contains templates for viewing objects, viewing objects and can be extended to whatever you want.

each of these template directories has a bunch of templates, loosely echoing data types in mongodb

example file structure:

		schemaobjects/
		schemaobjects/view/
		schemaobjects/view/boolean.html.erb
		schemaobjects/view/string.html.erb
		schemaobjects/edit/
		schemaobjects/edit/boolean.html.erb
		schemaobjects/edit/string.html.erb

there is also a helper, 

		render_schemaobject(object, templateset = :view, role = :default) 
		
eg. 

		<%= render_schemaobject(@todoitem, :edit)  %>
		

This will render the object, in the order the fields are defined in the model.  The templates can access "name" and "object" variables.  If there is no template for a field, it will not be rendered.

Eventually I would like the project to do a few more things;

* allow form views that work properly
* instead of rendering the templates on the server, make them javascript templates and let the client render them.  Currently I am rendering a pre tag containing some json values and json schema for this purpose.

Schema views
------------

I've just added some code that allows you to define schema subsets in the model, so you can instruct the renderer to only render a subset of the fields

eg. 

	class Todoitem
		include Mongoid::Document
		include Taapforms::SchemaScope # include this line if you want a schema block

		field :entry, :type => String, :label => 'Entry'
		field :secret, :type => String, :label => 'Admin only secret info'
		field :made_at, :type => Time, :label => 'Made at'
		field :completed, :type => Boolean, :label => 'Task Completed'

		validates :entry, :presence => true

		schema :user do
			expose :entry
			expose :completed
		end
	end

with this model definition, you could do

		<%= render_schemaobject(@todoitem, :view, :user)

in which case you would only see the entry and completed fields.

NOTE: the terms "schema" and "role" are used interchangeably by my code.  It's basically a subset or view of the data in the model, and as such, sometimes suits either description.  I think I'll need to call it schema going forward, but the code isn't there yet.

