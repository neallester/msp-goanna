note
	description: "Example consumer of messages."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "examples thread"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class MESSAGE_CONSUMER

inherit
	
	GOA_CONSUMER [STRING]

create
	
	make
	
feature {NONE} -- Implementation

	process (next: STRING)
			-- Process the next entry in the queue.
		do
			print (next + "%N")
		end

end -- class MESSAGE_CONSUMER
