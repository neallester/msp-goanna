note
	description: "Returns current date time of current machine"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "XMLRPC examples test"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class	CURRENT_DATE_TIME

inherit
	
	GOA_SERVICE
	
	DT_SHARED_SYSTEM_CLOCK
		export
			{NONE} all
		end
		
create
	
	make
			
feature -- Access
			
		
	get_current_time: DT_DATE_TIME
			-- Return current time
		do
			Result := system_clock.date_time_now
		end

feature -- Creation

	new_tuple (a_name: STRING): TUPLE
			--	Tuple of default-valued arguments to pass to call `a_name'.
		local
			a_tuple: TUPLE []
		do
			create a_tuple; Result := a_tuple
		end

feature {NONE} -- Implementation

	Get_current_time_name: STRING = "getCurrentTime"
			-- Name of `get_current_time' service

feature {NONE} -- Initialisation

	self_register
			-- Register all actions for this service
		do	
			register (agent get_current_time, Get_current_time_name)				
		end

end -- class CURRENT_DATE_TIME
