note
	description: "Check boxes in forms"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/11"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	CHECKBOX

inherit
	FORM_ELEMENT
		redefine
			make_form_element
		end

create

	make_form_element
	
feature {FORM} -- attribute setting

	set_checked_processor (new_checked_processor : PROCEDURE [PROCESSOR_HOST, TUPLE])
		-- Set the processor if the box is checked
		require
			valid_new_checked_processor : new_checked_processor /= Void
		do
			checked_processor := new_checked_processor
		ensure
			checked_processor_updated : checked_processor = new_checked_processor
		end

	set_unchecked_processor (new_unchecked_processor : PROCEDURE [PROCESSOR_HOST, TUPLE])
		-- Set the unchecked processor
		require
			valid_new_unchecked_processor : new_unchecked_processor /= Void
		do
			unchecked_processor := new_unchecked_processor
		ensure
			unchecked_processor_updated : unchecked_processor = new_unchecked_processor
		end

	set_checked
		-- set checked true
		do
			checked := true
		ensure
			checked : checked
		end

	set_database_version_function (new_database_version_function : FUNCTION [PROCESSOR_HOST, TUPLE, BOOLEAN])
		-- Set the agent used to determine the initial value of the checkbox
		require
			valid_new_database_version_function : new_database_version_function /= Void
		do
			database_version_function := new_database_version_function
		ensure
			database_version_function_updated : database_version_function = new_database_version_function
		end

	new_input : BOOLEAN
		do
			result := true
		end

	process_element
		do
			debug
				io.putstring ("Processing Checkbox: " + name + new_line)
			end
			if equal (value, "on") then
				checked := true
				debug
					io.putstring ("  Checked, processing checked_processor" + new_line)
				end
				if checked_processor /= Void then
					checked_processor.call ([])
				end
			else
				checked := false
				debug
					io.putstring ("  Unchecked, processing unchecked_processor" + new_line)
				end
				if unchecked_processor /= Void then
					unchecked_processor.call ([])
				end
			end
		end		

feature -- implement deferred features

	ready_to_initialize : BOOLEAN
		do
			result := true
		end

	processed : BOOLEAN
		do
			result := true
		end

	initialize_element
		do
			if database_version_function /= Void then
				database_version_function.call ([])
				checked := database_version_function.last_result
			else
				checked := false
			end
		end

	html_begin_element : STRING
		do
			result := "<INPUT TYPE=%"CHECKBOX%" NAME=%""
		end

	html_element : STRING
		do
			result := name + "%""
			if checked then
				result := result + " CHECKED"
			end
		end

	html_end_element : STRING
		do
			result := ">"
		end

feature {NONE} -- implementation

	database_version_function : FUNCTION [PROCESSOR_HOST, TUPLE, BOOLEAN]

	checked : BOOLEAN
		-- Is the box checked

	checked_processor : PROCEDURE [PROCESSOR_HOST, TUPLE]
		-- The agent to run if the box is checked

	unchecked_processor : PROCEDURE [PROCESSOR_HOST, TUPLE]
		-- The agent to run if the box is unchecked

feature {NONE} -- Creation

	make_form_element (new_form : FORM)
		do
			force_update := true
			precursor (new_form)
		end

invariant

	force_update : force_update
	
end -- class CHECKBOX
