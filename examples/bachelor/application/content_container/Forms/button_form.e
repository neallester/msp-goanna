indexing
	description: "Forms consisting of a single button"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/10"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	BUTTON_FORM

inherit
	FORM
		redefine
			form_handler
		end

creation

	make_button

feature {NONE} -- Implementation

	build_form is
		-- Build the form
		local
			submit_button : SUBMIT_BUTTON
		do
			create submit_button.make_form_element (current)
			submit_button.set_text (button_text)
			force (submit_button)
	end

	form_handler is
		-- The button has been pressed, activate processor
		do
			button_processor.call ([])
		end

	make_button (client_page : PAGE ; new_button_processor : PROCEDURE [PROCESSOR_HOST, TUPLE]; new_button_text : STRING) is
		-- Make the form button
		require
			valid_client_page : client_page /= Void
			valid_new_processor : new_button_processor /= Void
			valid_new_button_text : new_button_text /= Void
		do
			button_processor := new_button_processor
			button_text := new_button_text
			make (client_page)
		end	

	button_processor : PROCEDURE [PROCESSOR_HOST, TUPLE]
		-- The ISE Agent called if the button is selected

	button_text : STRING
		-- Clear text to display on the button

	process_form is 
		do
		end

invariant

	valid_button_processsor : button_processor /= Void
	valid_button_text : button_text /= Void

end -- class BUTTON_FORM