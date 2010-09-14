note
	description: "Shared access to the parameter processors"
	author: "Neal L. Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	copyright: "(c) 2005 Neal L. Lester and others"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

class

	SHARED_REQUEST_PARAMETERS
	
inherit

	GOA_SHARED_REQUEST_PARAMETERS
	
feature
	
	name_parameter: NAME_PARAMETER
			-- Allow user to input their name
		once
			create Result.make
		end
		
	gender_parameter: GENDER_PARAMETER
			-- Allow user to input their gender
		once
			create Result.make
		end
		
	programming_language_parameter: PROGRAMMING_LANGUAGE_PARAMETER
			-- Allow user to select their favorate programming language from a pull down
		once
			create Result.make
		end
		
	thinks_goanna_is_cool_parameter: THINKS_GOANNA_IS_COOL_PARAMETER
			-- Does user think Goanna is cool?
		once
			create Result.make
		end
		
end -- class SHARED_REQUEST_PARAMETERS
