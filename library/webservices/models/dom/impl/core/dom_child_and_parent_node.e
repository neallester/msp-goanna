note
	description: "A node that is both a parent and a child"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Document Object Model (DOM) Core Implementation"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class DOM_CHILD_AND_PARENT_NODE

inherit
	
	DOM_PARENT_NODE
		undefine
			previous_sibling,
			next_sibling,
			set_previous_sibling,
			set_next_sibling,
			parent_node,
			set_parent_node
		end
		
	DOM_CHILD_NODE
		undefine
			first_child,
			last_child, 
			has_child_nodes,
			normalize,
			ensure_child_list_exists	
		end

end -- class DOM_CHILD_AND_PARENT_NODE
