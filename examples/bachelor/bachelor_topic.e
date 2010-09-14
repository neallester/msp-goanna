note
	description: "A Topic used in the bachelor application"
	author: "Neal L. Lester"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"

deferred class
	BACHELOR_TOPIC

	inherit
		TOPIC
			undefine
				initialize, undo, receive_child_notification, parent_initialized, update, make, make_root
			end

feature 

	reset
		deferred
	end

end -- class BACHELOR_TOPIC