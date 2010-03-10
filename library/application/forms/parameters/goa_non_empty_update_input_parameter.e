indexing
	description: "A non empty parameter that updates the database"
	author: "Neal L Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	copyright: "(c) Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

deferred class
	GOA_NON_EMPTY_UPDATE_INPUT_PARAMETER
	
inherit
	
	GOA_NON_EMPTY_INPUT_PARAMETER
		undefine
			process
		end
	GOA_UPDATE_INPUT_PARAMETER
		undefine
			label_class
		end
	

end -- class GOA_NON_EMPTY_UPDATE_INPUT_PARAMETER
