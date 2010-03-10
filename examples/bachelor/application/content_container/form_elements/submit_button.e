indexing
	description: "Submit button for a form"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/11"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	SUBMIT_BUTTON

inherit
	
	TEXT_CONTAINER
		rename
			make as text_make
		undefine
			html_begin_element, html_end_element
		end
	FORM_ELEMENT
		redefine
			make_form_element
		select
			make
		end

create
	make_form_element

feature -- Implement Deferred Features

	html_begin_element : STRING is
		do
			Result := "<INPUT TYPE=%"SUBMIT%" NAME=%"" + name + "%" VALUE=%"" 
		end

	html_end_element : STRING is
		do
			Result := "%">" + new_line
		end

	ready_to_initialize : BOOLEAN is True

	processed : BOOLEAN is True

	new_input : BOOLEAN is
		do
			if parent.page.web_request.has_parameter (name) then
				if equal (value, text) then
					result := true
				else
					result := false
				end
			else
				result := false
			end
		end	

	make_form_element (proposed_parent : FORM) is
		do
			text_make
			precursor (proposed_parent)
		end

	initialize_element is
		do
		end

	process_element is
		do
		end

end -- class SUBMIT_BUTTON