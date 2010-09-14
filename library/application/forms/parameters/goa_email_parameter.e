note
	description: "Parameter that accepts e-mail address from users"
	author: "Neal L Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2007-09-08 08:50:56 -0700 (Sat, 08 Sep 2007) $"
	revision: "$Revision: 593 $"
	copyright: "(c) Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

-- Performs very basic validity check of email address and then
-- optionally validates the email address domain
-- Domain validating requires that program 'dig' is in the system's execution page
-- Set configuration.validate_email_domain to false if dig is not available on the system
-- will not replace a valid email address with an invalid address

deferred class
	GOA_EMAIL_PARAMETER

inherit

	GOA_NON_EMPTY_UPDATE_INPUT_PARAMETER
		undefine
			ok_to_save
		redefine
			validate
		end
	GOA_EMAIL_STATUS_FACILITIES
	GOA_SHARED_APPLICATION_CONFIGURATION

feature

	is_queried: BOOLEAN = False

	size: INTEGER
		deferred
		end


	validate (processing_result: PARAMETER_PROCESSING_RESULT)
			-- Process the paramter
		local
			message_catalog: GOA_MESSAGE_CATALOG
			current_email_address, new_email_address, domain: STRING
			address_is_valid: BOOLEAN
			at_index: INTEGER
			shell_command: KL_SHELL_COMMAND
		do
			message_catalog := processing_result.session_status.message_catalog
			if is_mandatory then
				Precursor (processing_result)
			end
			new_email_address := processing_result.value
			current_email_address := current_value (processing_result.request_processing_result, processing_result.parameter_suffix)
			if processing_result.is_value_valid and not processing_result.value.is_empty then
				address_is_valid := new_email_address.occurrences ('@') = 1
				if address_is_valid then
					at_index := new_email_address.index_of ('@', 1)
					address_is_valid := at_index > 1 and then at_index < new_email_address.count - 3
					if address_is_valid and then configuration.validate_email_domain then
						domain := new_email_address.substring (at_index + 1, new_email_address.count)
						create shell_command.make ("dig " + domain + " MX | grep %"ANSWER SECTION%" &> /dev/null")
						shell_command.execute
						address_is_valid := shell_command.exit_code = 0
					end
				end
				if not address_is_valid then
					processing_result.error_message.add_message (message_catalog.invalid_email_message)
					if domain = Void then
						domain := "No Domain"
					end
					log_hierarchy.logger (configuration.application_log_category).info ("invalid_email_address: " + new_email_address + "; Domain: " + domain)
				end
			end
			if not equal (new_email_address, current_email_address) then
				if processing_result.is_value_valid and not processing_result.value.is_empty then
					set_email_status (processing_result, email_valid)
				elseif processing_result.is_value_valid then
					set_email_status (processing_result, email_not_validated)
				elseif not ok_to_save (processing_result) then
					processing_result.error_message.add_message (message_catalog.email_address_not_updated)
				end
			end
		end

feature {NONE} -- Implementation

	set_email_status (processing_result: PARAMETER_PROCESSING_RESULT; new_status: INTEGER)
			-- Set status code for this e-mail address
		require
			valid_processing_result: processing_result /= Void
			ok_to_write_data: ok_to_write_data (processing_result.request_processing_result)
			is_valid_email_status_code: is_valid_email_status_code (new_status)
		deferred
		end

	is_mandatory: BOOLEAN
			-- Is user required to enter this email address?
			-- Default is yes
		once
			Result := True
		end

end -- class GOA_EMAIL_PARAMETER
