indexing
	description: "Parameter that accepts input from the user through an html text_area tag"
	author: "Neal L Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2007-06-14 13:46:53 -0700 (Thu, 14 Jun 2007) $"
	revision: "$Revision: 579 $"
	copyright: "(c) Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

deferred class
	GOA_TEXT_AREA_PARAMETER

inherit

	GOA_REQUEST_PARAMETER

feature

	add_to_document (xml: GOA_COMMON_XML_DOCUMENT_EXTENDED; processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER) is
		do
			xml.add_text_area_element (input_class (processing_result, suffix), full_parameter_name (name, suffix), rows (processing_result, suffix).out, columns (processing_result, suffix).out, display_value (processing_result, suffix))
		end

	ok_to_add (xml: GOA_COMMON_XML_DOCUMENT_EXTENDED): BOOLEAN is
		do
			Result := xml.ok_to_add_element_or_text (xml.text_area_element_code)
		end

	rows (processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER): INTEGER is
			-- Number of rows in the text area element
		require
			valid_processing_result: processing_result /= Void
			is_suffix_valid:  is_suffix_valid (processing_result, suffix)
		deferred
		end

	columns (processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER): INTEGER is
			-- Number of columns in the text area element
		require
			valid_processing_result: processing_result /= Void
			is_suffix_valid:  is_suffix_valid (processing_result, suffix)
		deferred
		end

end -- class GOA_TEXT_AREA_PARAMETER
