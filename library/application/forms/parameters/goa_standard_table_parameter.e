note
	description: "A parameter that may be added to a standard input table"
	author: "Neal L Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	copyright: "(c) Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

deferred class
	GOA_STANDARD_TABLE_PARAMETER
	
inherit
	
	GOA_DEFERRED_PARAMETER
	GOA_TRANSACTION_MANAGEMENT

feature

	add_to_standard_data_input_table (xml: GOA_COMMON_XML_DOCUMENT; processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER)
			-- Add parameter to a standard (3 column) table in xml document
		require
			valid_xml: xml /= Void
			ok_to_add_standard_input_row: xml.ok_to_add_element_or_text (xml.row_element_code)
			valid_processing_result: processing_result /= Void
			ok_to_read_data (processing_result)
			is_valid_suffix: is_suffix_valid (processing_result, suffix)
		deferred
		end

end -- class GOA_STANDARD_TABLE_PARAMETER
