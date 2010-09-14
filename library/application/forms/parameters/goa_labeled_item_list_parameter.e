note
	description: "A list parameter that is labeled for presentation to the user"
	author: "Neal L Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	copyright: "(c) Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

deferred class
	
	GOA_LABELED_ITEM_LIST_PARAMETER [G]
	
inherit
	
	GOA_ITEM_LIST_PARAMETER [G]
	GOA_STANDARD_TABLE_PARAMETER
	
feature
	
	add_list_to_standard_data_input_table (xml: GOA_COMMON_XML_DOCUMENT_EXTENDED; processing_result: REQUEST_PROCESSING_RESULT)	
		local
			local_item_list: DS_LINKED_LIST [G]
		do
			local_item_list := item_list (processing_result)
			from
				local_item_list.start
			until
				local_item_list.after
			loop
				add_to_standard_data_input_table (xml, processing_result, local_item_list.index)
				local_item_list.forth
			end
		end

end -- class GOA_LABELED_ITEM_LIST_PARAMETER
