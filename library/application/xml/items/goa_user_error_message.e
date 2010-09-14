note
	description: "An error message that will be displayed to the user"
	author: "Neal L Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	copyright: "(c) Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

class
	GOA_USER_ERROR_MESSAGE

inherit
	GOA_USER_MESSAGE
		redefine
			add_to_document, ok_to_add, add_message, add_message_item
		end
	L4E_SHARED_HIERARCHY
	GOA_SHARED_APPLICATION_CONFIGURATION

create
	
	make_with_processing_result
	
feature {GOA_XML_DOCUMENT, GOA_DEFERRED_PARAMETER} -- Services
	
	add_to_document (the_document: GOA_COMMON_XML_DOCUMENT_EXTENDED)
			-- Add to document
		do
			if not messages.is_empty then
				the_document.start_division_element (the_document.class_error_message)
					Precursor (the_document)
				the_document.end_current_element
			end
		end
		
feature -- Queries
		
	ok_to_add (the_document: GOA_COMMON_XML_DOCUMENT_EXTENDED): BOOLEAN
			-- Is it OK to add this message to the_document
		do
			if is_empty then
				Result := True
			else
				Result := the_document.ok_to_add_element_or_text (the_document.division_element_code)
			end
		end
		
	add_message (new_message: STRING)
			-- Add new_message to error message, appending a space if needed
		do
			Precursor (new_message)
			processing_result.set_not_all_parameters_are_valid
			log_hierarchy.logger (configuration.application_log_category).info ("User Error: " + new_message)
		ensure then
			not_all_parameters_are_valid: not processing_result.all_parameters_are_valid
		end
		
	add_message_item (new_item: GOA_XML_ITEM)
			-- Add new item to error message
		do
			Precursor (new_item)
			processing_result.set_not_all_parameters_are_valid
		ensure then
			not_all_parameters_are_valid: not processing_result.all_parameters_are_valid
		end

feature {NONE} -- Creation

	make_with_processing_result (new_processing_result: REQUEST_PROCESSING_RESULT)
			-- Creation
		require
			valid_new_processing_result: new_processing_result /= Void
		do
			make
			processing_result := new_processing_result
		ensure
			processing_result_updated: processing_result = new_processing_result
		end
		
feature {NONE} -- Implementation
		
	processing_result: REQUEST_PROCESSING_RESULT
		
invariant
	
	valid_processing_result: processing_result /= Void

end -- class GOA_USER_ERROR_MESSAGE
