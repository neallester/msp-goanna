indexing
	description: "Node that is a parent"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Document Object Model (DOM) Core Implementation"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class DOM_PARENT_NODE

inherit
	
	DOM_NODE_IMPL
		redefine
			first_child,
			last_child, 
			has_child_nodes,
			normalize	
		end
		
feature {DOM_NODE}

	make is
			-- Initialise this parent node
		do
			-- TODO: remove this creation procedure
		end

feature

	first_child: DOM_NODE is
			-- The first child of this node.
			-- If there is no such node, this returns `Void'.
		do
			if has_child_nodes then
				Result := child_nodes.first
			end
		end

	last_child: DOM_NODE is
			-- The last child of this node.
			-- If there is no such node, this returns `Void'.
		do
			if has_child_nodes then
				Result := child_nodes.last
			end
		end
   
   previous_sibling: DOM_NODE is
         -- The node immediately preceding this node.
         -- If there is no such node, this returns `Void'.
      	 -- No siblings for a parent node
		do
		end

   next_sibling: DOM_NODE is
         -- The node immediately following this node.
         -- If there is no such node, this returns `Void'.
		 -- No siblings for a parent node.
      do
      end

	has_child_nodes: BOOLEAN is
         -- This is a convenience method to allow easy determination
         -- of whether a node has any children.
         -- Return Value
         --    True    if the node has any children,
         --    False   if the node has no children.
	  do
		  Result := child_nodes /= Void and then not child_nodes.empty
      end

	normalize is
			-- Puts all Text modes in the full depth of the sub-tree underneath
			-- this Node, including attribute nodes, into a "normal" form
			-- where only stucture (eg, elements, comments, processing
			-- instructions, CDATA sections and entity references) separates
			-- Text nodes, ie, there are neither adjacent Text nodes nor empty
			-- Text nodes.
		local
			kid, next: DOM_NODE
			text: DOM_TEXT
			cdata: DOM_CDATA_SECTION
			discard: DOM_NODE
		do
			if child_nodes /= Void then
				from
					kid := first_child
				until
					kid = Void
				loop
					next := kid.next_sibling
					-- If the next is a text node then combine it with the kid.
					-- Otherwise, if it is an element, recursively normalize it.
					if next /= Void and kid.node_type = Text_node and next.node_type = Text_node then
						text ?= kid
						text.append_data (next.node_value)
						discard := remove_child (next)
						debug ("normalize")
							print ("combined Text child...%N")
						end
						-- don't advance; there might be another.
						next := kid
					elseif next /= Void and kid.node_type = Cdata_section_node and next.node_type = Cdata_section_node then
						cdata ?= kid
						cdata.append_data (next.node_value)
						discard := remove_child (next)
						debug ("normalize")
							print ("combined Cdata child...%N")
						end
						-- don't advance; there might be another.
						next := kid
					elseif kid.node_type = Element_node then
						kid.normalize
					end
					kid := next
				end
			end
		end

feature {DOM_NODE} -- DOM Status Setting

	set_previous_sibling (new_sibling: like previous_sibling) is
			-- Set the previous sibling of this node
		do
		end

	set_next_sibling (new_sibling: like next_sibling) is
			-- Set the next sibling of this node
		do
		end

feature {NONE} -- Implementation

	ensure_child_list_exists is
			-- Build the child list if it doesn't already exist
		do
			if child_nodes = Void then
				!DOM_NODE_LIST_IMPL! child_nodes.make
			end
		end

end -- class DOM_PARENT_NODE
