note
	description: "A input parameter whose value must not be empty"
	author: "Neal L Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	copyright: "(c) Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

deferred class
	GOA_NON_EMPTY_PARAMETER
	
inherit
	
	GOA_DEFERRED_PARAMETER
	GOA_STRING_LABELED_PARAMETER
		redefine
			label_class
		end
	GOA_COMMON_ATTRIBUTE_VALUES
	
feature
	
	process (processing_result: PARAMETER_PROCESSING_RESULT)
			-- Process the paramter
		do
			start_transaction (processing_result.request_processing_result)
				validate (processing_result)
			commit (processing_result.request_processing_result)
		ensure then
			empty_value_is_error: processing_result.value.is_empty implies not processing_result.error_message.is_empty
		end
		
	is_empty_error_message (processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER): STRING
			-- Error message to add if value for this parameter is empty
		require
			is_suffix_valid: is_suffix_valid (processing_result, suffix)
		do
			Result := label_string (processing_result, suffix) + " " + processing_result.session_status.message_catalog.is_required_message
		ensure
			valid_result: Result /= Void and then not Result.is_empty
		end
		
	label_class (processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER): STRING
			-- CSS class for label of this parameter
		once
			Result := class_required
		end

	validate (processing_result: GOA_PARAMETER_PROCESSING_RESULT)
		require
			ok_to_read_data: ok_to_read_data (processing_result.request_processing_result)
			valid_processing_result: processing_result /= Void
			is_valid_suffix: is_suffix_valid (processing_result.request_processing_result, processing_result.parameter_suffix)
		do
			if processing_result.value.is_empty then
				processing_result.error_message.add_message (is_empty_error_message (processing_result.request_processing_result, processing_result.parameter_suffix))
			end
		ensure then
			empty_value_is_error: processing_result.value.is_empty implies not processing_result.error_message.is_empty
			ok_to_read_data: ok_to_read_data (processing_result.request_processing_result)
		end

end -- class GOA_NON_EMPTY_PARAMETER
