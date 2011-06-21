module RpmContrib
	module Instrumentation
		module Mongoid
			# Mongoid Instrumentation contributed by Leigh Estes

			if defined?(::Mongoid) and not NewRelic::Control.instance['disable_mongodb']
				puts "-----> adding persistence tracers!"
				::Mongoid::Persistence.class_eval do
					add_method_tracer :insert, 'Database/#{self.class.name}/insert'
					add_method_tracer :remove, 'Database/#{self.class.name}/remove'
					add_method_tracer :update, 'Database/#{self.class.name}/update'
					add_method_tracer :destroy, 'Database/#{self.class.name}/destroy'
				end
				NewRelic::Control.instance.log.debug "-----> added persistence tracers!"

				puts "-----> adding class persistence tracers!"
				::Mongoid::Persistence::ClassMethods.class_eval do
					add_method_tracer :create, 'Database/#{self.class.name}/create'
					add_method_tracer :create!, 'Database/#{self.class.name}/create'
				end
				NewRelic::Control.instance.log.debug "-----> added class persistence tracers!"

				puts "-----> adding finder tracers!"
				::Mongoid::Finders.class_eval do
					add_method_tracer :find, 'Database/#{self.class.name}/find'
				end
				NewRelic::Control.instance.log.debug "-----> added finder tracers!"
			end
		end
	end
end
