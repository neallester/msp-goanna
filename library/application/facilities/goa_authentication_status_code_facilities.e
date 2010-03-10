indexing
	description: "Authentication Status Codes"
	author: "Neal L Lester <neal@3dsafety.com>"
	date: "$Date: 2007-03-29 07:18:13 -0800 (Thu, 29 Mar 2007) $"
	revision: "$Revision: 551 $"
	copyright: "(c) Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

class
	GOA_AUTHENTICATION_STATUS_CODE_FACILITIES

feature -- Session Status Codes

	authentication_status_undefined: INTEGER is 0

	authentication_status_anonymous: INTEGER is 1
			-- Totally Anonymous Session

	authentication_status_identified: INTEGER is 2
			-- User is tentatively identified (through persistent cookied) but not authenticated

	authentication_status_authenticated: INTEGER is 3
			-- User has been authenticated

	authentication_status_authentication_timeout: INTEGER is 4
			-- User was authenticated, but authentication has timed out

	valid_authentication_status_codes: ARRAYED_LIST [INTEGER] is
			-- Valid session status codese
		once
			create Result.make (5)
			Result.extend (authentication_status_undefined)
			Result.extend (authentication_status_anonymous)
			Result.extend (authentication_status_identified)
			Result.extend (authentication_status_authenticated)
			Result.extend (authentication_status_authentication_timeout)
		end


end -- class GOA_AUTHENTICATION_STATUS_CODE_FACILITIES
