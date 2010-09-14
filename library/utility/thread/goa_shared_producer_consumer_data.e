note
	description: "Shared objects for producers and consumers."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "utility thread"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class	GOA_SHARED_PRODUCER_CONSUMER_DATA

feature 

	mutex: MUTEX
			-- Request mutex
		note
			once_status: "global"
		once
			create Result
		end

	condition: CONDITION_VARIABLE
			-- Request condition variable
		note
			once_status: "global"
		once
			create Result.make
		end
		
end -- class GOA_SHARED_PRODUCER_CONSUMER_DATA
