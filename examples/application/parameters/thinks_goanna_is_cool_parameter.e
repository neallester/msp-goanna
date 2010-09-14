note
	description: "Ask user if he/she thinks goanna is cool"
	author: "Neal L. Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	copyright: "(c) 2005 Neal L. Lester and others"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

class
	THINKS_GOANNA_IS_COOL_PARAMETER
	
inherit
	
	GOA_STRING_LABELED_BOOLEAN_PARAMETER
	GOA_NON_DATABASE_ACCESS_TRANSACTION_MANAGEMENT

create
	
	make
	
feature

	name: STRING = "thinks_goanna_is_cool"
	
	boolean_in_database (processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER): BOOLEAN
		do
			Result := processing_result.session_status.thinks_goanna_is_cool
		end
		
	label_string (processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER): STRING
		do
			Result := processing_result.message_catalog.thinks_goanna_is_cool_label
		end

	process_checked (processing_result: PARAMETER_PROCESSING_RESULT)
		do
			processing_result.session_status.set_thinks_goanna_is_cool (True)
		end

		
	process_not_checked (processing_result: PARAMETER_PROCESSING_RESULT)
		do
			processing_result.session_status.set_thinks_goanna_is_cool (False)
		end

end -- class THINKS_GOANNA_IS_COOL_PARAMETER
