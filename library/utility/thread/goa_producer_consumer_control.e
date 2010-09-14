note
	description: "Coordinates producers and consumers."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "utility thread"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

deferred class GOA_PRODUCER_CONSUMER_CONTROL

inherit
	
	GOA_SHARED_PRODUCER_CONSUMER_DATA
		export
			{NONE} all
		end
	
	THREAD_CONTROL
		export
			{NONE} all
		end

	GOA_APPLICATION_LOGGER
		export
			{NONE} all
		end
		
feature {NONE} -- Initialization

	make
			-- Initialise
		do
			create consumers.make
			create producers.make
		end

feature -- Status report

	is_running: BOOLEAN 
			-- Are the producer and consumer threads running?

feature -- Basic operations

	run
			-- Start the pipeline
		require
			not_running: not is_running
		do
			start_consumers
			start_producers
			is_running := True
			wait_for_producers
			terminate_consumers
		ensure
			running: is_running
		end

feature -- Element change

	add_consumer (new_consumer: GOA_CONSUMER [ANY])
			-- Add consumer to the list of consumers to start
		require
			not_running: not is_running
			new_consumer_not_void: new_consumer /= Void
		do
			consumers.extend (new_consumer)
		end
	
	add_producer (new_producer: GOA_PRODUCER [ANY])
			-- Add producer to the list of producer to start
		require
			not_running: not is_running
			new_producer_not_void: new_producer /= Void
		do
			producers.extend (new_producer)
		end

feature {NONE} -- Implementation
		
	consumers: LINKED_LIST [GOA_CONSUMER [ANY]]
			-- List of consumers
	
	producers: LINKED_LIST [GOA_PRODUCER [ANY]]
			-- List of producers

	start_consumers
			-- Initialise and launch 'number_of_consumers' consumers
		require
			not_running: not is_running
		do
			debugging (generator, "starting consumers") 
			from
				consumers.start
			until
				consumers.off
			loop	
				consumers.item.launch
				consumers.forth
			end
		end
	
	start_producers
			-- Start producers
		require
			not_running: not is_running
			producers_available: not producers.is_empty
		do
			debugging (generator, "starting producers")
			from
				producers.start
			until
				producers.off
			loop
				producers.item.launch
				producers.forth
			end
		end
		
	wait_for_producers
			-- Wait for all producers to terminate
		require
			running: is_running
			consumers_available: not consumers.is_empty
		do			
			debugging (generator, "waiting for producers to terminate") 
			from
				producers.start
			until
				producers.off
			loop
				producers.item.join
				producers.forth
			end
		end
		
	terminate_consumers
			-- Stop all consumer threads
		require
			running: is_running
		do			
			debugging (generator, "terminating consumers") 
			from
				consumers.start
			until
				consumers.off
			loop
				consumers.item.terminate
				consumers.forth
			end
			condition.broadcast
			from
				consumers.start
			until
				consumers.off
			loop
				consumers.item.join
				consumers.forth
			end
		end
		
invariant
	
	producer_list_not_void: producers /= Void
	consumer_list_not_void: consumers /= Void
	
end -- class GOA_PRODUCER_CONSUMER_CONTROL
