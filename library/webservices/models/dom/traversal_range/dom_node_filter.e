indexing
	description: "Filters are objects that know how to 'filter out' nodes. If a%
		% DOM_NODE_ITERATOR or DOM_TREE_WALKER is given a filter, it applies the filter%
		% before it returns the next node. If the filter says to accept the node, the%
		% iterator returns it; otherwise, the iterator looks for the next node and%
		% pretends that the node that was rejected was not there."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Document Object Model (DOM) Traversal"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class
	DOM_NODE_FILTER

inherit

	DOM_NODE_FILTER_CONSTANTS
	
feature -- Basic opterations

	accept_node (node: DOM_NODE): INTEGER is
			-- Test whether a specified node is visible in the logical view of a 
     		-- DOM_TREE_WALKER or DOM_NODE_ITERATOR. This function will be called by the 
     		-- implementation of DOM_TREE_WALKER and DOM_NODE_ITERATOR; it is not intended to 
     		-- be called directly from user code.
     	require
     		node_exists: node /= Void
		deferred
		ensure
			valid_result: Result = Filter_accept
				or Result = Filter_reject
				or Result = Filter_skip
		end
	
end -- class DOM_NODE_FILTER
