note
	description: "A parameter that updates one or more fields in a data model"
	author: "Neal L Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2007-06-14 13:46:53 -0700 (Thu, 14 Jun 2007) $"
	revision: "$Revision: 579 $"
	copyright: "(c) Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

-- If the data model is updated during processing, REQUEST_PROCESSING_RESULT.was_updated is set to True
-- Will not replace a good value with an invalid one; displays a user message instead

deferred class
	 GOA_UPDATE_PARAMETER

inherit

	GOA_REQUEST_PARAMETER
	GOA_STRING_LABELED_PARAMETER

feature

	process (processing_result: PARAMETER_PROCESSING_RESULT)
		local
			local_current_value: STRING
			the_label: STRING
			message_catalog: GOA_MESSAGE_CATALOG
		do
			start_transaction (processing_result.request_processing_result)
			local_current_value := current_value (processing_result.request_processing_result, processing_result.parameter_suffix)
			validate (processing_result)
			if not equal (processing_result.value, local_current_value) then
				if ok_to_save (processing_result) then
					processing_result.set_was_updated
					add_update_message (processing_result)
					processing_result.set_was_updated
					save_current_value (processing_result)
				elseif not local_current_value.is_empty then
					the_label := label_string (processing_result.request_processing_result, processing_result.parameter_suffix)
					message_catalog := processing_result.session_status.message_catalog
					if include_value_in_error_message then
						processing_result.error_message.add_message (message_catalog.attribute_unchanged_message (the_label, local_current_value))
					else
						processing_result.error_message.add_message (message_catalog.attribute_unchanged_message_no_value (the_label))
					end
				end
			end
			commit (processing_result.request_processing_result)
		end

	ok_to_save (processing_result: PARAMETER_PROCESSING_RESULT): BOOLEAN
			-- Is it OK to save the value of processing_result in the database?
		require
			valid_processing_result: processing_result /= Void
		do
			Result := processing_result.is_value_valid
		end

	add_update_message (processing_result: PARAMETER_PROCESSING_RESULT)
			-- Descendents may redefine if they must send a message to the user when the parameter updates a database value
		require
			valid_processing_result: processing_result /= Void
		do
			-- Default is do nothing
		end

	save_current_value (processing_result: PARAMETER_PROCESSING_RESULT)
			-- Save value in the database
		require
			valid_processing_result: processing_result /= Void
			ok_to_write_data (processing_result.request_processing_result)
		deferred
		ensure
			ok_to_write_data (processing_result.request_processing_result)
		end

	validate (processing_result: GOA_PARAMETER_PROCESSING_RESULT)
			-- Validate the value of processing_result.value
		require
			valid_processing_result: processing_result /= Void
			ok_to_write_data (processing_result.request_processing_result)
		deferred
		ensure
			ok_to_write_data (processing_result.request_processing_result)
		end

	include_value_in_error_message: BOOLEAN
		once
			Result := True
		end



end -- class GOA_UPDATE_PARAMETER
