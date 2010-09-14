note
	description: "A node that is a child"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Document Object Model (DOM) Core Implementation"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."
deferred class DOM_CHILD_NODE

inherit
	
	DOM_NODE_IMPL
		redefine
			parent_node,
			set_parent_node
		end
		
feature

   previous_sibling: DOM_NODE
         -- The node immediately preceding this node.
         -- If there is no such node, this returns `Void'.
	 
   next_sibling: DOM_NODE
         -- The node immediately following this node.
         -- If there is no such node, this returns `Void'.
	  
   parent_node: DOM_NODE
         -- The parent of this node. All nodes, except Document,
         -- DocumentFragment, and Attr may have a parent. However,
         -- if a node has just been created and not yet added to the tree,
         -- or if it has been removed from the tree, this is `Void'.
		 --| Default is Void. Descendants override.

feature {DOM_NODE} -- DOM Status Setting

	set_previous_sibling (new_sibling: like previous_sibling)
			-- Set the previous sibling of this node
		do
			previous_sibling := new_sibling
		end

	set_next_sibling (new_sibling: like next_sibling)
			-- Set the next sibling of this node
		do
			next_sibling := new_sibling
		end

	set_parent_node (new_parent: like parent_node)
			-- Set the parent node of this node
		do
			parent_node := new_parent
		end

feature {NONE} -- Implementation

	ensure_child_list_exists
			-- Build the child list if it doesn't already exist
		do
			-- No children.
		end

end -- class DOM_CHILD_NODE
