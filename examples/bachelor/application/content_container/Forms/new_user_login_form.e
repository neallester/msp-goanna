indexing
	description: "A login form for new users"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/11"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	NEW_USER_LOGIN_FORM

inherit
	LOGIN_FORM
		redefine
			add_confirm_password_row,
			user_id_error_message,
			password_error_message,
			wrong_form_button_text,
			login_button_label,
			process_form,
			expected_new_user_status
		end

create
	make_login_form

feature -- Implement redefined features

	add_confirm_password_row (table : CONTENT_TABLE) is
		-- Add a row to confirm user password and get user name
		local
			row : TABLE_ROW
			container_cell : CONTAINER_BODY_CELL
			text_cell : TEXT_BODY_CELL
			user_name_element : STRING_FORM_ELEMENT
			confirm_password_element : PASSWORD_FORM_ELEMENT
			error_message : ERROR_MESSAGE_CONTAINER	
		do
			create row.make
			create text_cell.make
			text_cell.set_text (login_sequence.language.login_confirm_password)
			row.add_cell (text_cell)
			create confirm_password_element.make_form_element (current)
			confirm_password_element.set_database_version (login_sequence~confirm_password_access)
			confirm_password_element.set_database_set_procedure (login_sequence~set_confirm_password)
			confirm_password_element.set_error_message_function (~confirm_password_error_message)
			create container_cell.make
			container_cell.force (confirm_password_element)
			row.add_cell (container_cell)
			create error_message.make_error_message_container (confirm_password_element)
			create container_cell.make
			container_cell.force (error_message)
			row.add_cell (container_cell)
			table.add_row (row)
			create row.make
			create text_cell.make
			text_cell.set_text (login_sequence.language.login_new_user)
			row.add_cell (text_cell)
			create container_cell.make
			create user_name_element.make_form_element (current)
			user_name_element.set_database_version (login_sequence~new_user_name_access)
			user_name_element.set_database_set_procedure (login_sequence~set_new_user_name)
			container_cell.force (user_name_element)
			row.add_cell (container_cell)
			create container_cell.make
			create error_message.make_error_message_container (user_name_element)
			container_cell.force (error_message)
			row.add_cell (container_cell)
			table.add_row (row)
		end
			
	user_id_error_message : STRING is
		do
			if login_sequence.valid_user_id then
				result := ""
			else
				if login_sequence.user_id.is_empty then
					result := login_sequence.language.new_user_id_empty
				else
					result := login_sequence.language.new_user_id_exists
				end
			end
		end

	password_error_message : STRING is
		do
			result := ""
		end

	confirm_password_error_message : STRING is
		do
			if login_sequence.valid_confirm_password or (not login_sequence.display_error_messages) or (page.web_request = Void) then
				result := ""
			else
				result := login_sequence.language.confirm_password_error_message
			end
		end

	wrong_form_button_text : STRING is
		do
			result := login_sequence.language.new_user_wrong_form_button_text
		end

	login_button_label : STRING is
		do
			result := login_sequence.language.new_user_button_label
		end

	process_form is 
		do
			if wrong_form_button.new_input then
				login_sequence.set_returning_user
				process_returning_user
			else
				login_sequence.set_new_user
				process_new_user
			end
		end

	expected_new_user_status : BOOLEAN is
		do
			result := login_sequence.new_user
		end

end -- class NEW_USER_LOGIN_FORM
