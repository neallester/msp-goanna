note
	description: "A boolean (checkbox) parameter that is also labeled"
	author: "Neal L Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	copyright: "(c) Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

deferred class
	GOA_LABELED_BOOLEAN_PARAMETER
	
inherit
	
	GOA_BOOLEAN_PARAMETER
	GOA_LABELED_PARAMETER
		redefine
			add_to_standard_data_input_table
		end

feature
	
	add_to_standard_data_input_table (xml: GOA_COMMON_XML_DOCUMENT_EXTENDED; processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER)
		local
			the_parameter_processing_result: PARAMETER_PROCESSING_RESULT
			raw_parameter_name: STRING
		do
			the_parameter_processing_result := parameter_processing_result (processing_result, suffix)
			raw_parameter_name := full_parameter_name (name, suffix)
			xml.start_row_element (Void)
				xml.start_cell_element (Void, "2")
						add_to_document (xml, processing_result, suffix)
						xml.add_item (label (processing_result, suffix))
				xml.end_current_element
				xml.start_cell_element (Void, "1")
					add_messages (xml, processing_result, suffix)
				xml.end_current_element
			xml.end_current_element
		end

end -- class GOA_LABELED_BOOLEAN_PARAMETER
