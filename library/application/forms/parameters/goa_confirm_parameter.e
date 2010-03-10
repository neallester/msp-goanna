indexing
	description: "Parameters that confirm the value of another input"
	author: "Neal L Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	copyright: "(c) Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

deferred class
	GOA_CONFIRM_PARAMETER

inherit

	GOA_UPDATE_INPUT_PARAMETER
		undefine
			label_class
		redefine
			validate, current_value, type
		end
	
feature
	
	label_string (processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER): STRING is
			-- label for this parameter (intended for presentation to the user
		do
			Result := processing_result.session_status.message_catalog.confirm_label (parameter_to_confirm.label_string (processing_result, suffix))
		end
		
	parameter_to_confirm: GOA_NON_EMPTY_INPUT_PARAMETER is
			-- The parameter which will be confirmed
		deferred
		end
		
	current_value (processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER): STRING is
			-- current_value for this parameter (intended for presentation to the user
		do
			Result := parameter_to_confirm.current_value (processing_result, suffix)
		end
		
	size: INTEGER is
			-- Size of the parameter
		do
			Result := parameter_to_confirm.size
		end
		
	type: STRING is
			-- Type of the parameter
		do
			Result := parameter_to_confirm.type
		end
		
	validate (processing_result: PARAMETER_PROCESSING_RESULT) is
			-- Process
		local
			other_processing_result: PARAMETER_PROCESSING_RESULT
			request_processing_result: REQUEST_PROCESSING_RESULT
		do
			request_processing_result := processing_result.request_processing_result
			if request_processing_result.has_parameter_result (parameter_to_confirm.name, processing_result.parameter_suffix) then
				other_processing_result := processing_result.request_processing_result.parameter_processing_result (parameter_to_confirm.name, processing_result.parameter_suffix)
				if not equal (other_processing_result.value, processing_result.value) then
					processing_result.error_message.add_message (request_processing_result.session_status.message_catalog.parameters_dont_match_message (parameter_to_confirm.label_string (request_processing_result, processing_result.parameter_suffix), label_string (request_processing_result, processing_result.parameter_suffix)))
					add_unprocessed_message (other_processing_result)			
				end
			else
				processing_result.error_message.add_message ("Unable to confirm")
				-- This will only happen if an illegal request is received that has the confirm parameter without the origianl parameter
			end
		end
		
	add_unprocessed_message (other_processing_result: PARAMETER_PROCESSING_RESULT) is
			-- Add an error message to the processing result for parameter_to_confirm, if needed
		require
			valid_other_processing_result: other_processing_result /= Void
		deferred
		end
		
	label_class (processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER): STRING is
			-- CSS class for label of this parameter
		do
			Result := parameter_to_confirm.label_class (processing_result, suffix)
		end
		
invariant
	
	process_parameter_to_confirm_first: parameter_to_confirm.processing_order < processing_order

end -- class GOA_CONFIRM_PARAMETER
