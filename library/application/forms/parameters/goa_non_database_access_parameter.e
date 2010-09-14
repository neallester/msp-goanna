note
	description: "A parameter that does not require access to an open database"
	author: "Neal L Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	copyright: "(c) Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

deferred class
	GOA_NON_DATABASE_ACCESS_PARAMETER
	
inherit
	
	GOA_DEFERRED_PARAMETER
	GOA_NON_DATABASE_ACCESS_TRANSACTION_MANAGEMENT

end -- class GOA_NON_DATABASE_ACCESS_PARAMETER
