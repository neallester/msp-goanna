indexing
	description: "Node iterators are used to step through a set of nodes, e.g. the set of%
		% nodes in a DOM_NODE_LIST, the document subtree governed by a particular node,%
		% the results of a query, or any other set of nodes. The set of nodes to be%
		% iterated is determined by the implementation of the DOM_NODE_ITERATOR. DOM%
		% Level 2 specifies a single DOM_NODE_ITERATOR implementation for document-order%
		% traversal of a document subtree. Instances of these iterators are created%
		% by calling 'create_node_iterator' of the DOM_DOCUMENT class."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Document Object Model (DOM) Traversal"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class
	DOM_NODE_ITERATOR

feature -- Access

	attached: BOOLEAN is
			-- Is the iterator attached to the underlying subtree?
		deferred	
		end
	
	what_to_show: INTEGER is
			-- Which node types are presented via the iterator. The available set of constants
			-- is defined by the DOM_NODE_FILTER_TYPES class.
		deferred
		end
	
	filter: DOM_NODE_FILTER is
			-- The filter used to screen nodes.
		deferred	
		end
	
	expand_entity_references: BOOLEAN is
			-- Are children of entity reference nodes visible to the iterator? If false, they will
			-- be skipped over.
		    -- To produce a view of the document that has entity references 
     		-- expanded and does not expose the entity reference node itself, use the 
     		-- 'what_to_show' flags to hide the entity reference node and set 
    		-- 'expand_entity_references' to true when creating the iterator. To produce 
     		-- a view of the document that has entity reference nodes but no entity 
     		-- expansion, use the 'what_to_show' flags to show the entity reference node 
     		-- and set 'expand_entity_references' to false.
		deferred
		end
	
	next_node: DOM_NODE is
			-- Returns the next node in the set and advances the position of the 
     		-- iterator in the set. After a DOM_NODE_ITERATOR is created, the first call 
     						-- to 'next_node' returns the first node in the set.
		require
			attached: attached 
		deferred
		end
	
	previous_node: DOM_NODE is
			-- Returns the previous node in the set and moves the position of the 
     		-- iterator backwards in the set.
		require
			attached: attached
		deferred
		end
	
feature -- Status setting

	detach is
			-- Detaches the iterator from the set which it iterated over, releasing 
     		-- any computational resources. 
		require
			attached: attached
		deferred
		ensure
			detached: not attached
		end
	

end -- class DOM_NODE_ITERATOR
