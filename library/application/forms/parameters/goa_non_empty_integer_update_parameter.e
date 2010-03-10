indexing
	description: "Mandatory Database Update Integer Parameters"
	author: "Neal L Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	copyright: "(c) Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

deferred class
	GOA_NON_EMPTY_INTEGER_UPDATE_PARAMETER
	
inherit
	
	GOA_NON_EMPTY_INTEGER_PARAMETER
	GOA_NON_EMPTY_UPDATE_INPUT_PARAMETER
		undefine
			label_class, validate
		end

end -- class GOA_NON_EMPTY_INTEGER_UPDATE_PARAMETER
