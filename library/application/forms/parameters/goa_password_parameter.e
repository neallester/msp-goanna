note
	description: "Password input parameters"
	author: "Neal L Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2007-06-14 13:46:53 -0700 (Thu, 14 Jun 2007) $"
	revision: "$Revision: 579 $"
	copyright: "(c) Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

deferred class
	GOA_PASSWORD_PARAMETER

inherit

	GOA_NON_EMPTY_INPUT_PARAMETER
		redefine
			type
		end

feature

	type: STRING
			-- Type of the input
		once
			Result := password_input_type
		end

	label_string (processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER): STRING
			-- label for this parameter (intended for presentation to the user
		do
			Result := processing_result.session_status.message_catalog.password_label
		end

end -- class GOA_PASSWORD_PARAMETER
