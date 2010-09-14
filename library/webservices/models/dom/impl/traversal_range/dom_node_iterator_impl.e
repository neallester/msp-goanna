note
	description: "Node iterator implementation."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Document Object Model (DOM) Traversal Impl"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	DOM_NODE_ITERATOR_IMPL

inherit

	DOM_NODE_ITERATOR
	
	DOM_NODE_FILTER_CONSTANTS
		export
			{NONE} all
		end

	DOM_NODE_TYPE
		export
			{NONE} all
		end
		
create
	make

feature -- Initialization

	make (doc: DOM_DOCUMENT_IMPL; root_node: DOM_NODE; show_options: INTEGER; 
		node_filter: DOM_NODE_FILTER; expand_entity_references_flag: BOOLEAN)
				-- Create a new node iterator.
			require
				doc_exists: doc /= Void
				root_exists: root_node /= Void
				positive_show_options: show_options >= 0			
			do
				attached := True
				forward := True
				what_to_show := show_options
				filter := node_filter
				expand_entity_references := expand_entity_references_flag
				document := doc
				root := root_node
			end
		
feature -- Access

	attached: BOOLEAN
			-- Is the iterator attached to the underlying subtree?
	
	what_to_show: INTEGER
			-- Which node types are presented via the iterator. The available set of constants
			-- is defined by the DOM_NODE_FILTER_TYPES class.
	
	filter: DOM_NODE_FILTER
			-- The filter used to screen nodes.
	
	expand_entity_references: BOOLEAN
			-- Are children of entity reference nodes visible to the iterator? If false, they will
			-- be skipped over.
		    -- To produce a view of the document that has entity references 
     		-- expanded and does not expose the entity reference node itself, use the 
     		-- 'what_to_show' flags to hide the entity reference node and set 
    		-- 'expand_entity_references' to true when creating the iterator. To produce 
     		-- a view of the document that has entity reference nodes but no entity 
     		-- expansion, use the 'what_to_show' flags to show the entity reference node 
     		-- and set 'expand_entity_references' to false.
	
	next_node: DOM_NODE
			-- Returns the next node in the set and advances the position of the 
     		-- iterator in the set. After a DOM_NODE_ITERATOR is created, the first call 
     						-- to 'next_node' returns the first node in the set.
     	local
     		accepted: BOOLEAN
		do
			-- if root is Void there is no next node
			if root /= Void then
				from
					Result := current_node
					accepted := False
				until
					accepted
				loop
					-- if last direction is not forward, repeat node
					if not forward and Result /= Void then
						Result := current_node
					else
						-- get next node via depth-first traversal
						if expand_entity_references and Result /= Void 
							and Result.node_type = Entity_reference_node then
							Result := find_next_node (Result, False)
						else
							Result := find_next_node (Result, True)
						end
					end
					forward := True
					-- if we got something in the list then return it, otherwise
					-- filter the result
					if Result /= Void then
						accepted := accept_node(Result)	
						if accepted then
							current_node := Result	
						end
					else
						-- accept Void as the result
						accepted := True					
					end
				end	
			end
		end
	
	previous_node: DOM_NODE
			-- Returns the previous node in the set and moves the position of the 
     		-- iterator backwards in the set.
		do
		end
	
feature -- Status setting

	detach
			-- Detaches the iterator from the set which it iterated over, releasing 
     		-- any computational resources. 
		do
		
		end
	
feature {NONE} -- Implementation

	document: DOM_DOCUMENT_IMPL
		-- The document whos nodes will be iterated
	
	root: DOM_NODE
		-- The root node from which to start
	
	current_node: DOM_NODE
		-- The last node returned.
		
	forward: BOOLEAN
		-- The direction of the iterator on the current_node.
	
	accept_node (node: DOM_NODE): BOOLEAN
			-- The node is accepted if it passes the what_to_show and the filter.
		require
			node_exists: node /= Void
		local
			i, j: BOOLEAN
		do
			if filter = Void then
				Result := what_to_show.bit_and ((1).bit_shift_left (node.node_type - 1)) /= 0
			else
				i := what_to_show.bit_and ((1).bit_shift_left (node.node_type - 1)) /= 0
				j := filter.accept_node (node) = Filter_accept
				Result := i and j
			end
		end
		
	find_next_node (node: DOM_NODE; visit_children: BOOLEAN): DOM_NODE
			-- The method nextNode(Node, boolean) returns the next node 
     		-- from the actual DOM tree.
     		-- The boolean visitChildren determines whether to visit the children.
     		-- The result is the nextNode.
		local
			found: BOOLEAN
			parent: DOM_NODE
		do
			if node = Void then
				Result := root
				found := True
			end
			-- only check children if we visit children
			if not found then			
				if visit_children then
					-- if node has children, return first child
					if node.has_child_nodes then
						Result := node.first_child
						found := True
					end
				end
			end
			-- check for next sibling
			if not found then
				Result := node.next_sibling
				found := Result /= Void
			end
			-- return parent's 1st sibling
			if not found then
				from
					parent := node.parent_node
				until
					found or parent = Void
				loop
					Result := parent.next_sibling
					if Result /= Void then
						found := True
					else
						parent := parent.parent_node
					end
				end				
			end
		end
	
 	find_previous_node (node: DOM_NODE): DOM_NODE
 			-- return the previous node from the actual DOM tree.
 		do
 		end
 	
end -- class DOM_NODE_ITERATOR_IMPL
