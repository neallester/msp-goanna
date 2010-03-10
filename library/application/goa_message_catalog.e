indexing
	description: "System Messages displayed to the user"
	author: "Neal L Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2007-07-12 10:36:43 -0700 (Thu, 12 Jul 2007) $"
	revision: "$Revision: 588 $"
	copyright: "(c) Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

-- MESSAGE_CATALOG should inherit from this class
-- The design intent is that this should (eventually) be a fully deferred class
-- Which effective descendents for each language supported by the web site.

class
	GOA_MESSAGE_CATALOG

feature

	attribute_unchanged_message (new_label, old_value: STRING):STRING is
			-- Message indicating an attribute was not changed
		require
			valid_new_label: new_label /= Void and then not new_label.is_empty
			valid_old_value: old_value /= Void and then not old_value.is_empty
		do
			Result := new_label + " was not updated and remains %'" + old_value + "%'."
		end

	attribute_unchanged_message_no_value (new_label: STRING):STRING is
			-- Message indicating an attribute was not changed
		require
			valid_new_label: new_label /= Void and then not new_label.is_empty
		do
			Result := new_label + " was not updated."
		end


	is_required_message: STRING is "may not be empty."

	invalid_email_message: STRING is
		do
			Result := "The " + email_address_label + " is not a valid e-mail address.  Please enter the correct " + email_address_label
		end

	email_address_label: STRING is "e-Mail Address"
			-- label for the email address field

	email_address_not_updated: STRING is
			-- Email address was not updated
		do
			Result := "Your " + email_address_label + " was not updated."
		end

	password_label: STRING is "Password"
			-- Password text input label

	confirm_label (the_label: STRING): STRING is
			-- Conrirm the_label field label
		require
			valid_the_label: the_label /= Void and then not the_label.is_empty
		do
			Result := "Confirm " + the_label
		end

	parameters_dont_match_message (parameter_label, the_confirm_label: STRING): STRING is
			-- Message to display if parameters don't match
		require
			valid_parameter_label: parameter_label /= Void and then not parameter_label.is_empty
			valid_the_confirm_label: the_confirm_label /= Void and then not the_confirm_label.is_empty
		do
			Result := parameter_label + " and " + the_confirm_label + " must match exactly (including spaces and capital letters).  Please retype both."
		end

	submit_label: STRING is "Submit"

	data_entry_form_summary: STRING is "A table used to format a data entry form."

	system_error_message: STRING is "System Error (server side bug); please re-enter your information"

end -- class GOA_MESSAGE_CATALOG
