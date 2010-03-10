indexing
	description: "Example producer of messages."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "examples thread"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class	MESSAGE_PRODUCER

inherit
	
	GOA_PRODUCER [STRING]

create
	
	make

feature {NONE} -- Implementation

	generate_next: STRING is
			-- Generate the next element for the queue
		do
			number_messages := number_messages + 1
			Result := "Message (" + name + "): " + number_messages.out
		end
		
	done: BOOLEAN is
			-- Has the producer finished generating events?
		do
			Result := number_messages >= Max_number_messages
		end

	number_messages: INTEGER
			-- Number of messages sent
			
	Max_number_messages: INTEGER is 100
	
			
end -- class MESSAGE_PRODUCER
