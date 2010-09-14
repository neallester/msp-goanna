note
	description: "Ask user for their gener using an HTML radio button"
	author: "Neal L. Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2006-10-01 13:33:03 -0700 (Sun, 01 Oct 2006) $"
	revision: "$Revision: 513 $"
	copyright: "(c) 2005 Neal L. Lester and others"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

class

	GENDER_PARAMETER
	
inherit
	
	GOA_RADIO_BUTTON_PARAMETER [STRING]
	GOA_NON_DATABASE_ACCESS_TRANSACTION_MANAGEMENT
	
create
	
	make
	
feature

	name: STRING = "gender"
	
	currently_selected_object (processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER): STRING
		do
			if processing_result.session_status.is_male then
				Result := processing_result.message_catalog.male
			else
				Result := processing_result.message_catalog.female
			end
		end
		
	item_list (processing_result: REQUEST_PROCESSING_RESULT): DS_LINKED_LIST [STRING]
		once
			create Result.make_equal
			Result.force_last (processing_result.message_catalog.male)
			Result.force_last (processing_result.message_catalog.female)
		end
		
	process_item_selected (processing_result: PARAMETER_PROCESSING_RESULT; the_object: STRING)
		do
			if equal (the_object, processing_result.message_catalog.male) then
				processing_result.session_status.set_is_male
			else
				processing_result.session_status.set_is_female
			end
		end
		
	add_not_received_error_message (processing_result: PARAMETER_PROCESSING_RESULT)
		do
			-- Nothing; since we are starting out with a default value
			-- This shouldn't be a problem.  If there were no default value and
			-- The field is "mandatory", add an error message to the processing_result here
		end
		
	item_label (processing_result: REQUEST_PROCESSING_RESULT; the_item: STRING): GOA_USER_MESSAGE
			-- 
		do
			create Result.make_from_string (the_item)
		end
		
end -- class GENDER_PARAMETER
