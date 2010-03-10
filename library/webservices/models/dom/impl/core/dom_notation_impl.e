indexing
	description: "Notation implementation"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Document Object Model (DOM) Core Implementation"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class DOM_NOTATION_IMPL

inherit

	DOM_NOTATION

	DOM_NODE_IMPL
				
feature

	public_id: DOM_STRING
			-- The public identifier of this notation. If the public identifier was 
			-- not specified, this is Void.
		
	system_id: DOM_STRING
			-- The system identifier of this notation. If the system identifier was
			-- not specified, this is Void.
		
feature -- from DOM_NODE

	node_type: INTEGER is
		once
			Result := Notation_node
		end
  
end -- class DOM_NOTATION_IMPL
