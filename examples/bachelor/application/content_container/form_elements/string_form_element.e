note
	description: "Form Elements that are strings"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/11"
	revision: "$Revision: 513 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	STRING_FORM_ELEMENT

inherit
	
	FORM_ELEMENT
		redefine
			make_form_element
		end

create

	make_form_element

feature -- Implement deferred features

	ready_to_initialize : BOOLEAN
		do
			result := (database_function /= Void) and (set_procedure /= Void)
		end

	process_element
		do
			value.right_adjust
			value.left_adjust
			if input_valid then
				set_procedure.call ([value])
			end
		ensure then
			input_valid_implies_updated : input_valid implies equal (value, database_version)
		end

	initialize_element
		do
			value := database_version
		end

	new_input : BOOLEAN
		do
			if parent.page.web_request /= Void then
				if parent.page.web_request.has_parameter (name) then
					if (not equal(value, database_version)) then -- and (not value = Void) then
						result := true
					else
						result := false
					end
				else
					result := false
				end
			else
				result := false
			end
		end

	html_begin_element : STRING
		do
			result := "<INPUT "
		end

	html_element : STRING
		do
			result := "TYPE = %"" + type + "%" MAXLENGTH=%"" + maximum_length.out + "%" SIZE=%"" + size.out + "%" NAME=%"" + name + "%""
			if value /= void then
				result := result + " VALUE=%"" + value + "%""
			end
		end

	html_end_element : STRING
		do
			result := ">"
		end

	processed : BOOLEAN
		do
			result := equal (value, database_version)
		end

feature {FORM} -- Attribute Setting

	set_database_version (new_function : FUNCTION [PROCESSOR_HOST, TUPLE, STRING])
		-- Set the agent that returns the value of the string from database
		require
			valid_new_function : new_function /= Void
		do
			database_function := new_function
		ensure
			database_function_updated : database_function = new_function
		end

	set_database_set_procedure (new_set_procedure : PROCEDURE [PROCESSOR_HOST, TUPLE])
		-- Set the procedure (agent) used to set the string value in the database
		require
			valid_new_set_procedure : new_set_procedure /= Void
		do
			set_procedure := new_set_procedure
		ensure
			set_procedure_updated : set_procedure = new_set_procedure
		end

feature {NONE} -- implementation

	type : STRING
		-- The HTML input type
		do
			result := "TEXT"
		end

	database_version : STRING
		-- The value of the string currently stored in the database
		require
			valid_database_function : database_function /= Void
		do
			database_function.call ([])
			result := database_function.last_result
		end

	set_procedure : PROCEDURE [PROCESSOR_HOST, TUPLE]
		-- Agent used to set a new value in the database

	database_function : FUNCTION [PROCESSOR_HOST, TUPLE, STRING]
		-- Agent used to determine the value in the database

	maximum_length : INTEGER
		-- The maximum length of the string the user may input

	size : INTEGER
		-- The size of the text box

	set_maximum_length (new_maximum_length : INTEGER)
		-- Set maximum length
		require
			positive_new_maximum_length : new_maximum_length > 0
		do
			maximum_length := new_maximum_length
		end

	set_size (new_size : INTEGER)
		-- Set size
		require
			postiive_new_size : new_size > 0
		do
			size := new_size
		end

	make_form_element (proposed_parent : FORM)
		do
			set_maximum_length (40)
			set_size (40)
			precursor (proposed_parent)
		end

invariant
	maximum_length_set : maximum_length > 0
	size_set : size > 0

end -- class STRING_FORM_ELEMENT
