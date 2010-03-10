indexing
	description: "A form to login users"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/11"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."


class
	LOGIN_FORM

inherit

	FORM

create
	make_login_form

feature {STRING_FORM_ELEMENT}

	login_sequence : LOGIN_SEQUENCE
		-- The page sequence that generated the page containing this form

feature {NONE} -- Implementation

	wrong_form_button : SUBMIT_BUTTON
		-- Button for user to click if they are at the wrong form

	build_form is
		-- Create the form
		local
			table : CONTENT_TABLE
			row : TABLE_ROW
			container_cell : CONTAINER_BODY_CELL
			text_cell : TEXT_BODY_CELL
			button : SUBMIT_BUTTON
			text_list : TEXT_LIST
			user_id_element : STRING_FORM_ELEMENT
			password_element : PASSWORD_FORM_ELEMENT
			error_message : ERROR_MESSAGE_CONTAINER	
			paragraph : CONTAINER_PARAGRAPH		
		do
			text_list := login_sequence.language
			create table.make
			create row.make
			create text_cell.make
			text_cell.set_text (text_list.login_user_id)
			text_cell.set_width_in_pixels (0)
			row.add_cell (text_cell)
			create container_cell.make
			container_cell.set_width_in_pixels (100)
			create user_id_element.make_form_element (current)
			user_id_element.set_database_version (login_sequence~user_id_access)
			user_id_element.set_database_set_procedure (login_sequence~set_user_id)
			user_id_element.set_error_message_function (~user_id_error_message)
			create error_message.make_error_message_container (user_id_element)
			container_cell.force (user_id_element)
			row.add_cell (container_cell)
			create container_cell.make
			container_cell.force (error_message)
			row.add_cell (container_cell)
			table.add_row (row)
			create row.make
			create text_cell.make
			text_cell.set_text (text_list.login_password)
			row.add_cell (text_cell)
			create container_cell.make
			create password_element.make_form_element (current)
			password_element.set_database_version (login_sequence~password_access)
			password_element.set_database_set_procedure (login_sequence~set_password)
			password_element.set_error_message_function (~password_error_message)
			create error_message.make_error_message_container (password_element)
			container_cell.force (password_element)
			row.add_cell (container_cell)
			create container_cell.make
			container_cell.force (error_message)
			row.add_cell (container_cell)
			table.add_row (row)
			add_confirm_password_row (table)
			create paragraph.make
			paragraph.force(table)
			paragraph.set_center
			force (paragraph)
			create button.make_form_element (current)
			button.set_text (login_button_label)
			create paragraph.make
			paragraph.force (button)
			paragraph.set_center
			force (paragraph)
			create wrong_form_button.make_form_element (current)
			wrong_form_button.set_text (wrong_form_button_text)
			create paragraph.make
			paragraph.force (wrong_form_button)
			paragraph.set_center
			force (paragraph)
		ensure then
			valid_wrong_form_button : wrong_form_button /= Void
		end

	add_confirm_password_row (table : CONTENT_TABLE) is
		-- Add a row to the table that confirms password (a hook that is implemented in descendents)
		do
		end

	user_id_error_message : STRING is
		-- Error message for user_id
		do
			if login_sequence.valid_user_id or (not login_sequence.display_error_messages) then
				result := ""
			else
				result := login_sequence.language.login_user_id_error_message
			end
		ensure
			valid_result : result /= Void
		end

	wrong_form_button_text : STRING is
		-- Text to display on the wrong form button
		do
			result := login_sequence.language.login_wrong_form_button_text
		end

	login_button_label : STRING is
		-- Label to display on the login_button
		do
			result := login_sequence.language.login_button_label
		end

	password_error_message : STRING is
		-- Error message for password
		do
			if (not login_sequence.valid_user_id) or login_sequence.valid_password or (not login_sequence.display_error_messages) then
				result := ""
			else
				result := login_sequence.language.login_password_error_message
			end
		end

	process_form is
		do
			if wrong_form_button.new_input then
				login_sequence.set_new_user
				process_new_user
			else
				login_sequence.set_returning_user
				process_returning_user
			end
		end

	process_returning_user is
		-- The user has indicated they are a returning user; set them up
		require
			returning_user : not login_sequence.new_user
		do
			if login_sequence.valid_user then
				login_sequence.login_existing_user
			end
		end

	process_new_user is
		-- The user has indicated they are a new user; log them in
		require
			new_user : login_sequence.new_user
		do
			if login_sequence.valid_user then
				login_sequence.login_new_user
			end
		end		

	expected_new_user_status : BOOLEAN is
		-- Is the new_user status as the form expects
		do
			result := not login_sequence.new_user
		end

feature {NONE} -- creation

	make_login_form (new_page : PAGE ; new_login_sequence : LOGIN_SEQUENCE) is
		require
			valid_new_page : new_page /= Void
			valid_new_login_sequence : new_login_sequence /= Void
		do
			login_sequence := new_login_sequence
			make (new_page)
		end

invariant

	valid_login_sequence : login_sequence /= Void

end -- class LOGIN_FORM
