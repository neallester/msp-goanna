note
	description: "Radio button selecting an item in a list of objects of type G"
	author: "Neal L Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2006-07-14 22:32:55 -0700 (Fri, 14 Jul 2006) $"
	revision: "$Revision: 507 $"
	copyright: "(c) Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

deferred class
	GOA_RADIO_BUTTON_PARAMETER [G]
	
inherit
	
	GOA_REQUEST_PARAMETER
		redefine
			process, is_suffix_valid
		end
	GOA_SCHEMA_FACILITIES
	GOA_STANDARD_TABLE_PARAMETER
	
feature

	is_queried: BOOLEAN =  False
	
	process (processing_result: PARAMETER_PROCESSING_RESULT)
		local
			value: STRING
			local_is_value_valid, local_was_item_updated: BOOLEAN
		do
			value := processing_result.value
			start_transaction (processing_result.request_processing_result)
			if value.is_empty then
				add_not_received_error_message (processing_result)
			else
				validate (processing_result)
				local_is_value_valid := processing_result.is_value_valid
				local_was_item_updated := was_item_updated (item_in_processing_result (processing_result), currently_selected_object (processing_result.request_processing_result, processing_result.parameter_suffix))
				if processing_result.is_value_valid and then was_item_updated (item_in_processing_result (processing_result), currently_selected_object (processing_result.request_processing_result, processing_result.parameter_suffix)) then
					save_current_value (processing_result)
					if is_a_dependency then
						processing_result.set_was_dependency_updated
					else
						processing_result.set_was_updated
					end
				end
			end
			commit (processing_result.request_processing_result)
		ensure then
			empty_result_implies_not_is_value_valid: processing_result.value.is_empty implies not processing_result.is_value_valid
			valid_processing_result_implies_good_integer_value: processing_result.is_value_valid implies processing_result.value.is_integer and then (0 < processing_result.value.to_integer and processing_result.value.to_integer <= item_list (processing_result.request_processing_result).count)
		end
		
	validate (processing_result: PARAMETER_PROCESSING_RESULT)
		do
			if not value_is_valid_index (processing_result) then
				processing_result.error_message.add_message (processing_result.session_status.message_catalog.system_error_message)
			end
		ensure then
			valid_processing_result_implies_good_integer_value: processing_result.is_value_valid implies processing_result.value.is_integer and then (0 < processing_result.value.to_integer and processing_result.value.to_integer <= item_list (processing_result.request_processing_result).count)
		end
		
	item_in_processing_result (processing_result: PARAMETER_PROCESSING_RESULT): G
			-- The object referenced by value in processing_result
		require
			valid_processing_result: processing_result /= Void
			ok_to_read_data: ok_to_read_data (processing_result.request_processing_result)
			valid_index: value_is_valid_index (processing_result)
		do
			Result := item_list (processing_result.request_processing_result).item (processing_result.value.to_integer)
		ensure
			ok_to_read_data: ok_to_read_data (processing_result.request_processing_result)
		end
		
	value_is_valid_index (processing_result: PARAMETER_PROCESSING_RESULT): BOOLEAN
			-- The object referenced by value in processing_result
		require
			valid_processing_result: processing_result /= Void
			ok_to_read_data: ok_to_read_data (processing_result.request_processing_result)
		local
			value: STRING
			integer_value: INTEGER
		do	
			value := processing_result.value
			if value.is_integer then
				integer_value := value.to_integer
				Result := item_list (processing_result.request_processing_result).valid_index (integer_value)
			end
		ensure
			ok_to_read_data: ok_to_read_data (processing_result.request_processing_result)
		end

	suffix_is_valid_index (processing_result: PARAMETER_PROCESSING_RESULT; suffix: INTEGER): BOOLEAN
			-- The object referenced by value in processing_result
		require
			valid_processing_result: processing_result /= Void
			ok_to_read_data: ok_to_read_data (processing_result.request_processing_result)
		do	
			Result := item_list (processing_result.request_processing_result).valid_index (suffix)
		ensure
			ok_to_read_data: ok_to_read_data (processing_result.request_processing_result)
		end
	
	save_current_value (processing_result: PARAMETER_PROCESSING_RESULT)
		do
			process_item_selected (processing_result, item_in_processing_result (processing_result))
		end
		
	add_not_received_error_message (processing_result: PARAMETER_PROCESSING_RESULT)
			-- Add error message to if the parameter was not included with the request
		require
			valid_processing_result: processing_result /= Void
			ok_to_read_data: ok_to_read_data (processing_result.request_processing_result)
		deferred
		ensure
			ok_to_read_data: ok_to_read_data (processing_result.request_processing_result)
		end
		
	process_item_selected (processing_result: PARAMETER_PROCESSING_RESULT; the_object: G)
			-- Process the_object which was selected from the list
		require
			valid_processing_result: processing_result /= Void
			valid_the_object: the_object /= Void
			valid_index: value_is_valid_index (processing_result)
			ok_to_write_data: ok_to_write_data (processing_result.request_processing_result)
		deferred
		ensure
			ok_to_write_data: ok_to_write_data (processing_result.request_processing_result)
		end
		
	item_list (processing_result: REQUEST_PROCESSING_RESULT): DS_LINKED_LIST [G]
			-- List upon which this radio button acts
		require
			valid_processing_result: processing_result /= Void
		deferred
		end
		
	currently_selected_object (processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER): G
			-- The currently selected object in the list
		require
			valid_processing_result: processing_result /= Void
			ok_to_read_data: ok_to_read_data (processing_result)
		deferred
		ensure then
			ok_to_read_data: ok_to_read_data (processing_result)
			no_side_effects: item_list (processing_result).index = old item_list (processing_result).index
		end
		
	is_currently_selected_object (processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER; the_object: G): BOOLEAN
			-- Is the_object the currently selected object
		require
			valid_processing_result: processing_result /= Void
			ok_to_read_data: ok_to_read_data (processing_result)
		local
			list_index: INTEGER
		do
			list_index := item_list (processing_result).index
			if use_equal then
				Result := equal (the_object, currently_selected_object (processing_result, suffix))
			else
				Result := the_object = currently_selected_object (processing_result, suffix)
			end
			item_list (processing_result).go_i_th (list_index)
		ensure then
			ok_to_read_data: ok_to_read_data (processing_result)
			no_side_effects: item_list (processing_result).index = old item_list (processing_result).index
		end		
		
	current_value (processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER): STRING
		do
			Result := currently_selected_object (processing_result, suffix).out
		end
		
	was_item_updated (item_in_list, item_in_database: G): BOOLEAN
			-- Was item updated by the user
		do
			Result := item_in_list /= item_in_database
		end
		
	add_to_document (xml: GOA_COMMON_XML_DOCUMENT_EXTENDED; processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER)
		do
-- Nothing			
		end
		
	ok_to_add (xml: GOA_COMMON_XML_DOCUMENT_EXTENDED): BOOLEAN
		do
			Result := False
			-- Because this is a multi-row parameter, we cannot it to the document using
			-- add_to_document.  It's parameters do not include the necessary information
			-- (i.e. which row we are adding)
			-- Use GOA_LABELED_RADIO_BUTTON_PARAMETER.add_to_standard_input_row instead
		end
		
	is_suffix_valid (processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER): BOOLEAN
		do
			Result := 	True
		end
		
	item_label (processing_result: REQUEST_PROCESSING_RESULT; the_item: G): GOA_XML_ITEM
			-- The label to display for the_item
		require
			valid_processing_result: processing_result /= Void
			valid_the_item: the_item /= Void
		deferred
		end

	add_to_standard_data_input_table (xml: GOA_COMMON_XML_DOCUMENT_EXTENDED; processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER)
		local
			the_list: DS_LINKED_LIST [G]
			the_parameter_processing_result: PARAMETER_PROCESSING_RESULT
		do
			the_list := item_list (processing_result)
			the_parameter_processing_result := parameter_processing_result (processing_result, suffix)
			from
				the_list.start
			until
				the_list.after
			loop
				xml.start_row_element (Void)
					xml.start_cell_element (Void, "1")
						xml.add_radio_element (Void, full_parameter_name (name, suffix), the_list.index.out, yes_no_string_for_boolean (is_currently_selected_object (processing_result, suffix, the_list.item_for_iteration)), yes_no_string_for_boolean (is_disabled (processing_result, suffix)))
					xml.end_current_element
					xml.start_cell_element (Void, "1")
						item_label (processing_result, the_list.item_for_iteration).add_to_document (xml)
					xml.end_current_element
					xml.start_cell_element (Void, "1")
						if the_list.is_first and then the_parameter_processing_result /= Void then
							the_parameter_processing_result.error_message.add_to_document (xml)
						end
					xml.end_current_element
				xml.end_current_element
				the_list.forth
			end
		end
		
	use_equal: BOOLEAN
			-- Use equal (rather than =) to determine if selected object matches current object
		once
			Result := False
		end
		
	
end -- class GOA_RADIO_BUTTON_PARAMETER
