indexing
	description: "A parameter that has a label for display to the user"
	author: "Neal L Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2006-06-26 20:03:29 -0700 (Mon, 26 Jun 2006) $"
	revision: "$Revision: 505 $"
	copyright: "(c) Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

deferred class
	GOA_LABELED_PARAMETER

inherit
	
	GOA_DEFERRED_PARAMETER
	GOA_STANDARD_TABLE_PARAMETER
	
feature
	
	label (processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER): GOA_XML_ITEM is
			-- label for this parameter (intended for presentation to the user
		require
			valid_processing_result: processing_result /= Void
			ok_to_read_data (processing_result)
			is_valid_suffix: is_suffix_valid (processing_result, suffix)
		deferred
		ensure
			valid_result: Result /= Void
		end

	label_class (processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER): STRING is
			-- CSS  Class (if any) to use for the label (if any) associated with this parameter
			-- Void if none (default = Void)
		require
			valid_processing_result: processing_result /= Void
			ok_to_read_data: ok_to_read_data (processing_result)
			is_suffix_valid: is_suffix_valid (processing_result, suffix)
		once
			Result := Void
		ensure
			ok_to_read_data: ok_to_read_data (processing_result)
		end

	add_to_standard_data_input_table (xml: GOA_COMMON_XML_DOCUMENT_EXTENDED; processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER) is
			-- Add labeled parameter to a standard table in xml document
		do
			xml.start_row_element (Void)
				xml.start_cell_element (Void, "1")
		 			xml.add_item (label (processing_result, suffix))
		 		xml.end_current_element
		 		xml.start_cell_element (Void, "1")
						add_to_document (xml, processing_result, suffix)
				xml.end_current_element
				xml.start_cell_element (Void, "1")
					add_messages (xml, processing_result, suffix)
				xml.end_current_element
			xml.end_current_element
		end
		
	add_messages (xml: GOA_COMMON_XML_DOCUMENT_EXTENDED; processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER) is
			-- Add dependency messages for this parameter (if any) to document
		require
			valid_xml: xml /= Void
			ok_to_add_item: xml.current_element_code = xml.cell_element_code
			valid_processing_result: processing_result /= Void
		local
			the_parameter_processing_result: PARAMETER_PROCESSING_RESULT
		do
			the_parameter_processing_result := parameter_processing_result (processing_result, suffix)
			if the_parameter_processing_result /= Void then
				xml.add_item (the_parameter_processing_result.error_message)
			end
		end

end -- class GOA_LABELED_PARAMETER
