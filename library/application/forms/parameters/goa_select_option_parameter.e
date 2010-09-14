note
	description: "Obtain information from the user via an html select/option element"
	author: "Neal L Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2007-06-14 13:46:53 -0700 (Thu, 14 Jun 2007) $"
	revision: "$Revision: 579 $"
	copyright: "(c) Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

deferred class
	GOA_SELECT_OPTION_PARAMETER [G]

inherit

	GOA_REQUEST_PARAMETER
	GOA_SCHEMA_FACILITIES

feature

	process (processing_result: PARAMETER_PROCESSING_RESULT)
		local
			item_selected: G
			local_option_list: DS_LINKED_LIST [G]
		do
			start_transaction (processing_result.request_processing_result)
			local_option_list := option_list (processing_result.request_processing_result, processing_result.parameter_suffix)
			if processing_result.value.is_integer and then 0 < processing_result.value.to_integer and then processing_result.value.to_integer <= local_option_list.count then
				item_selected := local_option_list.item (processing_result.value.to_integer)
				if not same_item (item_selected, currently_selected_item_in_database (processing_result.request_processing_result, processing_result.parameter_suffix), processing_result.request_processing_result) and ok_to_save (processing_result) then
					set_currently_selected_item_in_database (processing_result, item_selected)
					processing_result.set_was_updated
				elseif always_update (processing_result.request_processing_result, processing_result.parameter_suffix) then
					set_currently_selected_item_in_database (processing_result, item_selected)
				end
			end
			commit  (processing_result.request_processing_result)
		end

	display_text_for_item_index (processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER; index: INTEGER): STRING
			-- Text for the item at index
		require
			ok_to_read_data (processing_result)
			valid_processing_result: processing_result /= Void
			valid_index: 0 < index and index <= option_list (processing_result, suffix).count
		do
			Result := text_for_item (processing_result, suffix, option_list (processing_result, suffix).item (index))
		end

	text_for_item (processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER; item: G): STRING
			-- Text for the item at index
		require
			ok_to_read_data (processing_result)
			valid_processing_result: processing_result /= Void
			valid_item: item /= Void
		deferred
		end

	same_item (a, b: G; processing_result: REQUEST_PROCESSING_RESULT): BOOLEAN
			-- Are a & b the same item?
		require
			ok_to_read_data (processing_result)
		do
			Result := equal (a, b)
 		ensure
 			ok_to_read_data (processing_result)
 		end

 	show_the_item_as_selected (the_item: G; processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER): BOOLEAN
		require
			valid_the_item: the_item /= Void
			valid_processing_result: processing_result /= Void
			ok_to_read_data (processing_result)
		local
			item_in_database: G
		do
			item_in_database := currently_selected_item_in_database (processing_result, suffix)
			if item_in_database /= Void then
				Result := same_item (the_item, item_in_database, processing_result)
			else
				Result := same_item (the_item, default_selected_item (processing_result, suffix), processing_result)
			end
 		ensure
 			ok_to_read_data (processing_result)
 		end

 	default_selected_item (processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER): G
			-- The item to select in the list if there is not a value selected in the database
		require
			valid_processing_result: processing_result /= Void
			ok_to_read_data (processing_result)
 		deferred
 		ensure
 			ok_to_read_data (processing_result)
 		end

 	ok_to_save (processing_result: PARAMETER_PROCESSING_RESULT): BOOLEAN
 			-- Is it OK to save this parameter?
		require
			valid_processing_result: processing_result /= Void
			ok_to_read_data (processing_result.request_processing_result)
 		do
 			Result := True
 		ensure
 			ok_to_read_data (processing_result.request_processing_result)
 		end

	always_update (processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER): BOOLEAN
			-- Should we call set_currently_selected_item_in_database even if database hasn't been updated
			-- Default is "no"
		do
			Result := False
		end

 	currently_selected_item_in_database (processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER): G
 			-- The list item that is currently selected in the database
		require
			valid_processing_result: processing_result /= Void
			ok_to_read_data (processing_result)
 		deferred
 		ensure
 			ok_to_read_data (processing_result)
 		end

 	set_currently_selected_item_in_database (processing_result: PARAMETER_PROCESSING_RESULT; new_item: G)
 			-- Set the currently selected item in the list
		require
			valid_processing_result: processing_result /= Void
			valid_new_item: new_item /= Void
			ok_to_read_data (processing_result.request_processing_result)
 		deferred
 		ensure
 			ok_to_read_data (processing_result.request_processing_result)
 		end

	option_list (processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER): DS_LINKED_LIST [G]
			-- The list upon which this parameter will operate
		require
			valid_processing_result: processing_result /= Void
			ok_to_read_data (processing_result)
		deferred
		ensure
			ok_to_read_data (processing_result)
		end

	current_value (processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER): STRING
			-- current_value for this parameter (intended for presentation to the user
		do
			Result := ""
		end

	add_to_document (xml: GOA_COMMON_XML_DOCUMENT_EXTENDED; processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER)
		local
			local_option_list: DS_LINKED_LIST [G]
			index: INTEGER
		do
			local_option_list := option_list (processing_result, suffix)
			xml.start_select_element (input_class (processing_result, suffix), full_parameter_name (name, suffix), yes_no_string_for_boolean (is_disabled (processing_result, suffix)), Void, Void, script_name (processing_result, suffix))
				from
					local_option_list.start
				until
					local_option_list.after
				loop
					index := local_option_list.index
					xml.add_option_element (local_option_list.index.out, yes_no_string_for_boolean (show_the_item_as_selected (local_option_list.item_for_iteration, processing_result, suffix)), text_for_item (processing_result, suffix, local_option_list.item_for_iteration))
					local_option_list.go_i_th (index)
					local_option_list.forth
				end
			xml.end_current_element
		end

	ok_to_add (xml: GOA_COMMON_XML_DOCUMENT_EXTENDED): BOOLEAN
		do
			Result := xml.ok_to_add_element_or_text (xml.select_element_code)
		end

end -- class GOA_SELECT_OPTION_PARAMETER
