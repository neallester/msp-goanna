indexing
	description: "Manages a sequence of connectors and processes requests from each in turn"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Servlet API"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_REQUEST_PROCESSOR

inherit
	
	GOA_APPLICATION_LOGGER
		export
			{NONE} all
		end
	
	GOA_PRODUCER_CONSUMER_CONTROL
		rename
			make as control_make
		export
			{NONE} control_make
		end
	
create

	make
		
feature -- Initialization

	make (application_context: GOA_SERVLET_CONTEXT) is
			-- Initialise this request processor
		require
			application_context_exists: application_context /= Void
		do
			control_make
			context := application_context
		end
	
feature -- Access

	context: GOA_SERVLET_CONTEXT
			-- Application context

invariant
	
	context_not_void: context /= Void
	
end -- class GOA_REQUEST_PROCESSOR
