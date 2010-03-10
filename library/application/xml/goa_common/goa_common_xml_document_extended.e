indexing
	description: "Extensions to the GOA_COMMON_XML_DOCUMENT"
	author: "Neal L Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	copyright: "(c) Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

deferred class
	GOA_COMMON_XML_DOCUMENT_EXTENDED
	
inherit
	
	GOA_COMMON_XML_DOCUMENT
	GOA_SCHEMA_FACILITIES
	
feature
	
feature -- Document Writing

	add_text_paragraph (new_class, text_to_add: STRING) is
			-- Add a paragraph containing text_to_add to the document
		require
			ok_to_add_paragraph: ok_to_add_element_or_text (paragraph_element_code)
			is_valid_value_new_class: new_class /= Void implies is_valid_attribute_value (class_attribute_code, new_class)
			valid_text_to_add: text_to_add /= Void
		do
			start_paragraph_element (new_class)
			add_text_item_element (xml_null_code, Void, text_to_add)
			end_current_element
		end
		
	add_text_cell (new_class, new_colspan, new_text: STRING) is
			-- Add a cell containing only text to a table
		require
			valid_new_colspan: new_colspan /= Void and then new_colspan.is_integer
			valid_new_text: new_text /= Void
			ok_to_add_cell: ok_to_add_element_or_text (cell_element_code)
		do
			start_cell_element (Void, new_colspan)
				add_text_item_element (xml_null_code, Void, new_text)
			end_current_element
		end
		
	add_parameter (suffix: INTEGER; the_parameter: GOA_DEFERRED_PARAMETER; processing_result: REQUEST_PROCESSING_RESULT) is
		require
			valid_the_parameter: the_parameter /= Void
			valid_processing_result: processing_result /= Void
			ok_to_add: the_parameter.ok_to_add (Current)
			ok_to_read_data: the_parameter.ok_to_read_data (processing_result)
			is_suffix_valid: the_parameter.is_suffix_valid (processing_result, suffix)
		do
			the_parameter.add_to_document (Current, processing_result, suffix)
		end

	add_standard_input_row (suffix: INTEGER; the_parameter: GOA_STANDARD_TABLE_PARAMETER; processing_result: REQUEST_PROCESSING_RESULT) is
			-- Add a row to the table with three cells: Label | Input | Error Message
		require
			valid_the_parameter: the_parameter /= Void
			ok_to_add_row: ok_to_add_element_or_text (row_element_code)
			valid_processing_result: processing_result /= Void
		do
			the_parameter.add_to_standard_data_input_table (Current, processing_result, suffix)
		end
		
	add_list_to_standard_data_input_table (the_parameter: GOA_LABELED_ITEM_LIST_PARAMETER [ANY]; processing_result: REQUEST_PROCESSING_RESULT) is
			-- Add parameters representing entire list of the_parameter in to standard data input table)
		require
			valid_the_parameter: the_parameter /= Void
			ok_to_add_row: ok_to_add_element_or_text (row_element_code)
			valid_processing_result: processing_result /= Void
		do
			the_parameter.add_list_to_standard_data_input_table (Current, processing_result)
		end
		
	add_plain_text_item_element (new_text: STRING) is
			-- Add text at current point in document
		require
			ok_to_add_text: ok_to_add_element_or_text (text_item_element_code)
		do
			add_text_item_element (xml_null_code, Void, new_text)
		end
		
	add_plain_text_list_item_element (new_text: STRING) is
			-- Add a plain (no class) list item to the document
		require
			valid_new_text: new_text /= Void and not new_text.is_empty
		do
			start_list_item_element (Void)
			add_text_item_element (xml_null_code, Void, new_text)
			end_current_element
		end
	
	start_plain_table_element (new_class: STRING; new_summary: STRING; ) is
			-- Start a plain table element (empty header and footer)
			-- leaves body open to add rows;  use end_current_element twice
			-- to close the body element and then the table element
		require
			ok_to_add_table: ok_to_add_element_or_text (table_element_code)
			is_valid_value_new_class: new_class /= Void implies is_valid_attribute_value (class_attribute_code, new_class)
			is_valid_value_new_summary: new_summary /= Void implies is_valid_attribute_value (summary_attribute_code, new_summary)
			valid_new_summary: new_summary /= Void
		do
			start_table_element (new_class, Void, Void, new_summary)
				start_header_element (Void)
				end_current_element
				start_footer_element (Void)
				end_current_element
				start_body_element (Void)
		end

	start_formatted_table_element (new_class: STRING; new_summary: STRING; new_cellspacing, new_cellpadding: STRING) is
			-- Start a plain table element (empty header and footer)
			-- leaves body open to add rows;  use end_current_element twice
			-- to close the body element and then the table element
		require
			ok_to_add_table: ok_to_add_element_or_text (table_element_code)
			is_valid_value_new_class: new_class /= Void implies is_valid_attribute_value (class_attribute_code, new_class)
			is_valid_value_new_summary: new_summary /= Void implies is_valid_attribute_value (summary_attribute_code, new_summary)
			is_valid_value_new_cellspacing: new_cellspacing /= Void implies is_valid_attribute_value (cellspacing_attribute_code, new_cellspacing)
			is_valid_value_new_cellpadding: new_cellpadding /= Void implies is_valid_attribute_value (cellpadding_attribute_code, new_cellpadding)

			valid_new_summary: new_summary /= Void
		do
			start_table_element (new_class, new_cellspacing, new_cellpadding, new_summary)
				start_header_element (Void)
				end_current_element
				start_footer_element (Void)
				end_current_element
				start_body_element (Void)
		end
	
	

	start_data_entry_table_element (message_catalog: MESSAGE_CATALOG) is
			-- STart a plain table element used for data entry
		require
			valid_message_catalog: message_catalog /= Void
		do
			start_plain_table_element (Void, message_catalog.data_entry_form_summary)
		end	

	add_a_space is
			-- Add a space to the current document
		require
			ok_to_add_text_item_element: ok_to_add_element_or_text (text_item_element_code)
		do
			add_text_item_element (xml_null_code, Void, " ")
		end
				
end -- class GOA_COMMON_XML_DOCUMENT_EXTENDED
