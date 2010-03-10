indexing
	description: "Example message producer consumer controller."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "examples thread"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class MESSAGE_CONTROL

inherit
	
	GOA_PRODUCER_CONSUMER_CONTROL
		rename
			make as control_make
		export
			{NONE} control_make
		end
	
create
	
	make 

feature {NONE} -- Initialisation

	make is
			-- Initialise
		do
			create queue
			control_make
			add_producer (new_producer)
			add_producer (new_producer)
			add_consumer (new_consumer)
			add_consumer (new_consumer)
			add_consumer (new_consumer)
		end
		
feature -- Factory operations

	new_consumer: MESSAGE_CONSUMER is
			-- Factory method for creating a new concrete consumer instance.
		do
			label := label + 1
			create Result.make (label.out, queue)
		end
	
	new_producer: MESSAGE_PRODUCER is
			-- Factory method for creating a new concrete producer instance.
		do
			label := label + 1
			create Result.make (label.out, queue)
		end
	
feature {NONE} -- Factory attributes

	queue: GOA_THREAD_SAFE_QUEUE [STRING]
	
	label: INTEGER
	
end -- class GOA_MESSAGE_CONTROL
