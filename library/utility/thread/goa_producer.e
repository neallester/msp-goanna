indexing
	description: "Threaded producer."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "utility thread"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

deferred class GOA_PRODUCER [K]

inherit
	
	GOA_NAMED_THREAD
		rename
			make as named_thread_make
		export
			{GOA_PRODUCER_CONSUMER_CONTROL} all
			{NONE} named_thread_make
		end

	GOA_SHARED_PRODUCER_CONSUMER_DATA
		export
			{NONE} all
		end

	GOA_APPLICATION_LOGGER
		export
			{NONE} all
		end
		
feature {NONE} -- Initialisation

	make (new_name: STRING; queue: like request_queue) is
			-- Initialise this producer to write to 'queue'
		require
			new_name_not_void: new_name /= Void
			queue_not_void: queue /= Void
		do
			named_thread_make (new_name)
			request_queue := queue
		end
		
feature {GOA_PRODUCER_CONSUMER_CONTROL} -- Basic operations

	execute is
			-- Feed threads
		do
			from
			until
				done
			loop
				debugging (generator, name + " locking")
				mutex.lock
				debugging (generator, name + " generating next request")
				request_queue.put (generate_next)
				debugging (generator, name + " unlocking")
				mutex.unlock
				debugging (generator, name + " signalling consumers")
				condition.signal
			end
		end

feature {NONE} -- Implementation

	generate_next: K is
			-- Generate the next element for the queue
		deferred
		end
		
	done: BOOLEAN is
			-- Has the producer finished generating events?
		deferred
		end

	request_queue: GOA_THREAD_SAFE_QUEUE [K]
			-- Queue of requests to write to

invariant
	
	request_queue_not_void: request_queue /= Void
	
end -- class GOA_PRODUCER
