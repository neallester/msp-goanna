indexing
	description: "A parameter that accepts only integers"
	author: "Neal L Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	copyright: "(c) Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

deferred class
	GOA_INTEGER_PARAMETER
	
inherit

	GOA_INPUT_PARAMETER
	GOA_STRING_LABELED_PARAMETER
	KL_IMPORTED_STRING_ROUTINES
	
feature
	
	validate (processing_result: PARAMETER_PROCESSING_RESULT) is
		local
			value: STRING
			index: INTEGER
			is_value_valid, has_leading_zero, is_leading_digit: BOOLEAN
			the_character: CHARACTER
			message_catalog: MESSAGE_CATALOG
		do
			value := STRING_.cloned_string (processing_result.value)
			if value.is_empty then
				value.extend ('0')
			else
				processing_result.value.wipe_out
				from
					index := 1
					is_value_valid := True
					is_leading_digit := True
				until
					index > value.count
				loop
					the_character := value.item (index)
					if the_character.is_digit then
						if is_leading_digit  and then the_character.out.to_integer = 0 then
							has_leading_zero := True
						else
							is_leading_digit := False
							processing_result.value.extend (the_character)
						end
					else
						is_value_valid := False
					end
					index := index + 1
				end
				if has_leading_zero and then processing_result.value.is_empty then
					processing_result.value.extend ('0')
				end
				if not is_value_valid then
					message_catalog := processing_result.session_status.message_catalog
					processing_result.error_message.add_message (message_catalog.integer_only_error_message (label_string (processing_result.request_processing_result, processing_result.parameter_suffix)))
				end
			end
		end
		
	size: INTEGER is
		deferred
		end

end -- class GOA_INTEGER_PARAMETER
