note
	description: "Objects on forms that accept input from the user"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/11"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class
	FORM_ELEMENT

inherit
	
	CONTENT_CONTAINER

feature {FORM} -- Access

	initialize
		-- Initialize values from database/model if necessary
		require
			ready_to_initialize : ready_to_initialize
		do
			if not initialized then
				initialize_element
				if not input_valid then
					database_corrupt := true
				end
			end
			initialized := true
		ensure
			not_input_valid_implies_database_corrupt : not input_valid implies database_corrupt
			report_initialized : initialized
		end

	initialized : BOOLEAN
		-- Has this form been initialized

	ready_to_initialize : BOOLEAN
		-- Is the element ready to initialize
		deferred
		end

	process
		-- Process information received from the user
		require
			valid_web_request : parent.page.web_request /= Void
		do
			if parent.page.web_request.has_parameter (name) then
				value := parent.page.web_request.get_parameter (name)
			end
			if new_input or force_update then
				process_element
			end
		end

	processed : BOOLEAN
		-- Was the information sucessfully processed
		deferred
		end

	set_validity_function (new_validity_function : FUNCTION [PROCESSOR_HOST, TUPLE, BOOLEAN])
		-- Set the agent used to verify validity of the input
		require
			valid_new_validity_function : new_validity_function /= Void
		do
			validity_function := new_validity_function
		ensure
			validity_function_updated : validity_function = new_validity_function
		end

	set_error_message_function (new_error_message_function : FUNCTION [PROCESSOR_HOST, TUPLE, STRING])
		-- Set the function that will generate text of the error message
		require
			valid_new_error_message_function : new_error_message_function /= Void
		do
			error_message_function := new_error_message_function
		ensure
			error_message_function_updated : error_message_function = new_error_message_function
		end

feature {FORM, FORM_ELEMENT} -- Implementation

	name : STRING
		-- The form element's name

	force_update : BOOLEAN
		-- Force update even if user has not changed values obtained from database

	process_element
		-- Process the element
		deferred
		end

	initialize_element
		-- Initialize values from database/model if necessary
		deferred
		end

	database_corrupt : BOOLEAN
		-- The data obtained from the database is corrupt

	new_input : BOOLEAN
		-- Has the user input something new
		deferred
		end

	input_valid : BOOLEAN
		-- Is the input received from the user valid?
		do
			if validity_function = Void then
				result := true
			else
				validity_function.call ([])
				result := validity_function.last_result
			end
		end

	parent : FORM
		-- The form that created this element

	unique_name_factory : UNIQUE_FORM_ELEMENT_NAME_FACTORY
		-- Where the unique form element names come from
		once
			create result.make
		end

	value : STRING
		-- The current value of this form element (as an HTML name/value pair)

feature {NONE} -- Creation

	make_form_element (proposed_parent : FORM)
		require
			valid_proposed_parent : proposed_parent /= Void
		do
			unique_name_factory.forth
			name := clone (unique_name_factory.unique_string)
			make
			parent := proposed_parent
			parent.register_element (current)
		ensure
			parent_updated : parent = proposed_parent
		end

feature {CONTENT_CONTAINER} -- Access

	error_message : STRING
		-- Text explaining any problems with the input
		do
			if error_message_function = Void then -- or parent.page.web_request = Void then
				Result := ""
			else
				error_message_function.call ([])
				result := error_message_function.last_result
			end
		ensure
			valid_result : result /= Void
		end

feature {NONE} -- implementation

	error_message_function : FUNCTION [PROCESSOR_HOST, TUPLE, STRING]
		-- Agent used to get the current error message

	validity_function : FUNCTION [PROCESSOR_HOST, TUPLE, BOOLEAN]
		-- Agent used to determine validity of current input

invariant

	valid_parent : parent /= Void
	registered_in_parent : parent.element_registered (current)

end -- class FORM_ELEMENT