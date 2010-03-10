indexing
	description: "Allow user to enter their name"
	author: "Neal L. Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	copyright: "(c) 2005 Neal L. Lester and others"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

class
	NAME_PARAMETER

inherit
	
	GOA_NON_EMPTY_UPDATE_INPUT_PARAMETER
	GOA_NON_DATABASE_ACCESS_TRANSACTION_MANAGEMENT
	
creation
	
	make

feature
	
	name: STRING is "name"
	
	size: INTEGER is 50
	
	current_value (processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER): STRING is
		do
			Result := processing_result.session_status.name
		end
		
	save_current_value (processing_result: PARAMETER_PROCESSING_RESULT) is
		do
			processing_result.session_status.set_name (processing_result.value)
		end
		
	label_string (processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER): STRING is
		do
			Result := processing_result.message_catalog.name_label
		end

end -- class NAME_PARAMETER
