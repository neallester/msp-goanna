note
	description: "Servlet based producer/consumer application"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Servlet API"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

deferred class	GOA_APPLICATION
	
inherit
	
	GOA_SERVLET_CONTEXT
		undefine
			default_create
		end

	GOA_APPLICATION_LOGGER
		export
			{NONE} all
		redefine
			default_create
		end

feature -- Initialization

	default_create
			-- Initialise this servlet application by registering all security realms,
			-- connectors and servlets
		do
			Precursor {GOA_APPLICATION_LOGGER}
			info (generator, "initializing")
			create processor.make (Current)
			create manager
			register_security
			register_servlets
			register_producers
			register_consumers
			run
			info (generator, "terminating")
			Log_hierarchy.close_all
		end
	
feature -- Access

	processor: GOA_REQUEST_PROCESSOR
			-- Request processor
			
	manager: GOA_SERVLET_MANAGER
			-- Servlet manager

feature {NONE} -- Implementation

	register_servlets
			-- Register all servlets for this application
		deferred
		end
		
	register_security
			-- Register all security realms
		deferred
		end
		
	register_producers
			-- Register all producers
		deferred
		end

	register_consumers
			-- Register all consumers
		deferred
		end

	run
			-- Start the request processor threads and wait for them 
			-- exit
		do
			processor.run
		end
		
invariant
	
	processor_exist: processor /= Void
	manager_exists: manager /= Void
	
end -- class GOA_APPLICATION
