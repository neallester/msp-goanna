indexing
	description: "Produces requests from a connector"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Servlet API"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_REQUEST_PRODUCER

inherit
	
	GOA_PRODUCER [GOA_QUEUED_REQUEST]
		rename
			make as producer_make
		export
			{NONE} producer_make
		end
	
create

	make
		
feature -- Initialization

	make (thread_name: STRING; app_context: GOA_SERVLET_CONTEXT; request_connector: GOA_CONNECTOR;
		queue: GOA_THREAD_SAFE_QUEUE [GOA_QUEUED_REQUEST]) is
			-- Initialise this request processor
		require
			thread_name_not_void: thread_name /= Void
			app_context_exists: app_context /= Void
			request_connector_not_void: request_connector /= Void
			queue_not_void: queue /= Void
		do
			producer_make (thread_name, queue)
			context := app_context
			connector := request_connector
		end

feature -- Access

	context: GOA_SERVLET_CONTEXT
			-- Application context
			
	connector: GOA_CONNECTOR
			-- server connector

feature -- Basic operations
		
	terminate is
			-- Stop this processor from reading requests
		do
			stop := True
		end
	
feature {NONE} -- Implementation

	generate_next: GOA_QUEUED_REQUEST is
			-- Generate the next element for the queue
		do
			debugging (generator, name + " generate next request")
			connector.read_request
			if connector.last_operation_ok then
				create Result.make (connector.last_request, connector.last_response)
			end
			check 
				next_request_not_void: Result /= Void
			end
		end
		
	done: BOOLEAN is
			-- Has the producer finished generating events?
		do
			Result := stop
		end

	stop: BOOLEAN
			-- Stop flag.
			
invariant
	
	context_not_void: context /= Void
	connector_not_void: connector /= Void
	
end -- class GOA_REQUEST_PRODUCER
