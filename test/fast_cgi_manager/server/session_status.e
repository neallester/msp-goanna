note
	description: "Access to information associated with the user session"
	author: "Neal L. Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	copyright: "(c) 2005 Neal L. Lester and others"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

class
	SESSION_STATUS

inherit

	GOA_SESSION_STATUS
		redefine
			initialize
		end

create

	make

feature -- Attributes


feature -- Setting Attributes

	initialize (processing_result: REQUEST_PROCESSING_RESULT)
		do

		end



end -- class SESSION_STATUS
