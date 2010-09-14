note
	description: "Request handling thread."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Servlet API"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class	GOA_REQUEST_CONSUMER

inherit

	GOA_CONSUMER [GOA_QUEUED_REQUEST]
		rename
			make as consumer_make
		export
			{NONE} consumer_make
		end

create
	
	make

feature {NONE} -- Initialisation

	make (thread_name: STRING; app_context: GOA_SERVLET_CONTEXT; queue: GOA_THREAD_SAFE_QUEUE [GOA_QUEUED_REQUEST])
			-- Initialise
		require
			thread_name_not_void: thread_name /= Void
			app_context_not_void: app_context /= Void
			queue_not_void: queue /= Void
		do
			consumer_make (thread_name, queue)
			context := app_context
			debugging (generator, name.out + " initialised")
		end
		
feature {NONE} -- Implementation

	context: GOA_SERVLET_CONTEXT
			-- Servlet application context
			
	process (next: GOA_QUEUED_REQUEST)
			-- Process the next entry in the queue.
		do
			debugging (generator, name.out + " handling request")
			debugging (generator, name.out + " request = " + next.request.to_string)
			context.manager.dispatch (next.request, next.response)
		end
		
invariant
	
	context_not_void: context /= Void
	
end -- class GOA_REQUEST_CONSUMER
