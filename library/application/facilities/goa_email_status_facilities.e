note
	description: "Status codes for email addresses"
	author: "Neal L Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2007-05-27 10:37:45 -0700 (Sun, 27 May 2007) $"
	revision: "$Revision: 576 $"
	copyright: "(c) Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

class
	GOA_EMAIL_STATUS_FACILITIES

feature
	
	email_not_validated: INTEGER = 0
			-- email address has not been validated
			
	email_invalid: INTEGER = 100
			-- email address is not valid
			
	email_valid: INTEGER = 200
			-- email passed validatioin
			
	email_confirmed: INTEGER = 300
			-- email address is confirmed good (recipient has confirmed receipt of an e-mail to this address)
			
	is_valid_email_status_code (the_code: INTEGER): BOOLEAN
			-- Does the_code represent a valid email status code?
		do
			Result := valid_email_status_codes.has (the_code)
		end
			
	valid_email_status_codes: DS_LINKED_LIST [INTEGER]
			-- Valid status codes
		once
			create Result.make_equal
			Result.force_last (email_not_validated)
			Result.force_last (email_invalid)
			Result.force_last (email_valid)
			Result.force_last (email_confirmed)
		end
		

end -- class GOA_EMAIL_STATUS_FACILITIES
