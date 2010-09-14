note
	description: "Containers for error messages from a form element"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/11"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	ERROR_MESSAGE_CONTAINER

inherit
	CONTENT_CONTAINER

create
	make_error_message_container

feature -- Implement deferred features

	html_begin_element : STRING
		-- To Do Create a class "COLORED", and implement this class as a descendent of
		-- COLORED_TEXT_CONTAINER with the color attribute set to red (user configurable)
		do
			result := "<FONT COLOR=RED>"
		end

	html_element : STRING
		do
			result := form_element.error_message
		end

	html_end_element : STRING
		do
			result := "</FONT>"
		end

feature {NONE}

	make_error_message_container (new_form_element : FORM_ELEMENT)
		require
			valid_new_form_element : new_form_element /= Void
		do
			form_element := new_form_element
		end

	form_element : FORM_ELEMENT
		-- The form element which will generate the error message displayed.

invariant

	valid_form_element : form_element /= Void

end -- class ERROR_MESSAGE_CONTAINER
