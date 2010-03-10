indexing
	description: "Allow user to select their favorate programming language from a pull down"
	author: "Neal L. Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2006-10-01 13:33:03 -0700 (Sun, 01 Oct 2006) $"
	revision: "$Revision: 513 $"
	copyright: "(c) 2005 Neal L. Lester and others"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

class
	PROGRAMMING_LANGUAGE_PARAMETER
	
inherit
	
	GOA_LABELED_SELECT_OPTION_PARAMETER [PROGRAMMING_LANGUAGE_SELECTION]
	GOA_STRING_LABELED_PARAMETER
	GOA_NON_DATABASE_ACCESS_TRANSACTION_MANAGEMENT
	
creation
	
	make

feature
	
	name: STRING is "programming_language"
	
	option_list (processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER): DS_LINKED_LIST [PROGRAMMING_LANGUAGE_SELECTION] is
		local
			new_selection: PROGRAMMING_LANGUAGE_SELECTION
			message_catalog: MESSAGE_CATALOG
		once
			message_catalog := processing_result.message_catalog
			create Result.make_equal
			create new_selection.make (message_catalog.eiffel, message_catalog.eiffel_comment)
			Result.force_last (new_selection)
			create new_selection.make (message_catalog.java, message_catalog.java_comment)
			Result.force_last (new_selection)
			create new_selection.make (message_catalog.c, message_catalog.c_comment)
			Result.force_last (new_selection)
			create new_selection.make (message_catalog.lisp, message_catalog.lisp_comment)
			Result.force_last (new_selection)
		end
		
	default_selected_item (processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER): PROGRAMMING_LANGUAGE_SELECTION is
		do
			Result := option_list (processing_result, suffix).item (1)
		end

	currently_selected_item_in_database (processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER): PROGRAMMING_LANGUAGE_SELECTION is
		do
			Result := processing_result.session_status.programming_language
		end
		
	text_for_item (processing_result: REQUEST_PROCESSING_RESULT;  suffix: INTEGER; item: PROGRAMMING_LANGUAGE_SELECTION): STRING is
		do
			Result := item.name
		end
	
	label_string (processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER): STRING is
		do
			Result := processing_result.message_catalog.programming_language_label
		end
		
	set_currently_selected_item_in_database (processing_result: PARAMETER_PROCESSING_RESULT; new_item: PROGRAMMING_LANGUAGE_SELECTION) is
		do
			processing_result.session_status.set_programming_language (new_item)
		end
		
end -- class PROGRAMMING_LANGUAGE_PARAMETER
