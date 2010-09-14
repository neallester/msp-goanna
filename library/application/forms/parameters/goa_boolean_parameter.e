note
	description: "Parameters that are either on or off (html checkbox input)"
	author: "Neal L Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2010-02-26 11:12:53 -0800 (Fri, 26 Feb 2010) $"
	revision: "$Revision: 624 $"
	copyright: "(c) Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

deferred class
	GOA_BOOLEAN_PARAMETER

inherit

	GOA_REQUEST_PARAMETER
		redefine
			display_value, current_value
		end
	GOA_SCHEMA_FACILITIES

feature -- Processing

	process (processing_result: PARAMETER_PROCESSING_RESULT)
		do
			start_transaction (processing_result.request_processing_result)
				validate (processing_result)
				if processing_result.is_value_valid and then boolean_updated (processing_result) then
					processing_result.request_processing_result.set_was_updated
					if processing_result.value.is_empty then
						process_not_checked (processing_result)
					else
						process_checked (processing_result)
					end
				end
			commit (processing_result.request_processing_result)
		end

	display_value (processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER): STRING
		local
			parameter_result: PARAMETER_PROCESSING_RESULT
		do
			parameter_result := processing_result.parameter_processing_result (name, suffix)
			if parameter_result /= Void then
				Result := yes_no_string_for_boolean (not parameter_result.value.is_empty)
			else
				Result := current_value (processing_result, suffix)
			end
		end

	boolean_updated (processing_result: PARAMETER_PROCESSING_RESULT): BOOLEAN
			-- Does processing_result contain a change for the boolean value contained in the database?
		require
			ok_to_read_data: ok_to_read_data (processing_result.request_processing_result)
			valid_processing_result: processing_result /= Void
			is_valid_suffix: is_suffix_valid (processing_result.request_processing_result, processing_result.parameter_suffix)
		do
			if processing_result.value.is_empty and boolean_in_database (processing_result.request_processing_result, processing_result.parameter_suffix) then
				Result := True
			elseif not processing_result.value.is_empty and not boolean_in_database (processing_result.request_processing_result, processing_result.parameter_suffix) then
				Result := True
			end
		ensure
			ok_to_read_data: ok_to_read_data (processing_result.request_processing_result)
		end

	is_checked (processing_result: PARAMETER_PROCESSING_RESULT): BOOLEAN
			-- Is the parameter checked in processing_result?
		require
			ok_to_read_data: ok_to_read_data (processing_result.request_processing_result)
			valid_processing_result: processing_result /= Void
			is_valid_suffix: is_suffix_valid (processing_result.request_processing_result, processing_result.parameter_suffix)
		do
			Result := equal (processing_result.value.as_lower, on)
		ensure
			ok_to_read_data: ok_to_read_data (processing_result.request_processing_result)
		end

	current_value (processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER): STRING
		do
			Result := yes_no_string_for_boolean (boolean_in_database (processing_result, suffix))
		end

	validate (processing_result: PARAMETER_PROCESSING_RESULT)
		require
			valid_processing_result: processing_result /= Void
			ok_to_read_data: ok_to_read_data (processing_result.request_processing_result)
		do
			-- Nothing (both checked and unchecked are valid) by default
		ensure
			ok_to_read_data: ok_to_read_data (processing_result.request_processing_result)
		end

feature -- As XML

	add_to_document (xml: GOA_COMMON_XML_DOCUMENT_EXTENDED; processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER)
		do
			xml.add_checkbox_element (input_class (processing_result, suffix), full_parameter_name (name, suffix), display_value (processing_result, suffix), xml.yes_no_string_for_boolean (is_disabled (processing_result, suffix)), script_name (processing_result, suffix))
		end


	ok_to_add (xml: GOA_COMMON_XML_DOCUMENT): BOOLEAN
		do
			Result := xml.ok_to_add_element_or_text (xml.checkbox_element_code)
		end

feature -- Deferred Features

	process_checked (processing_result: PARAMETER_PROCESSING_RESULT)
		require
			ok_to_read_data: ok_to_read_data (processing_result.request_processing_result)
			valid_processing_result: processing_result /= Void
			is_valid_suffix: is_suffix_valid (processing_result.request_processing_result, processing_result.parameter_suffix)
		deferred
		ensure
			ok_to_read_data: ok_to_read_data (processing_result.request_processing_result)
		end

	process_not_checked (processing_result: PARAMETER_PROCESSING_RESULT)
		require
			ok_to_read_data: ok_to_read_data (processing_result.request_processing_result)
			valid_processing_result: processing_result /= Void
			is_valid_suffix: is_suffix_valid (processing_result.request_processing_result, processing_result.parameter_suffix)
		deferred
		ensure
			ok_to_read_data: ok_to_read_data (processing_result.request_processing_result)
		end

	boolean_in_database (processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER): BOOLEAN
		require
			ok_to_read_data: ok_to_read_data (processing_result)
			valid_processing_result: processing_result /= Void
			is_valid_suffix: is_suffix_valid (processing_result, suffix)
		deferred
		ensure
			ok_to_read_data: ok_to_read_data (processing_result)
		end

end -- class GOA_BOOLEAN_PARAMETER
