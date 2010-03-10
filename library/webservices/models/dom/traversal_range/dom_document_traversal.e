indexing
	description: "DocumentTraversal contains methods that create iterators and%
		% tree-walkers to traverse a node and its children in document order (depth%
 		% first, pre-order traversal, which is equivalent to the order in which the%
		%  start tags occur in the text representation of the document)"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Document Object Model (DOM) Traversal"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class
	DOM_DOCUMENT_TRAVERSAL

feature -- Access

	create_node_iterator (root: DOM_NODE; what_to_show: INTEGER;
		filter: DOM_NODE_FILTER; entity_reference_expansion: BOOLEAN): DOM_NODE_ITERATOR is
			-- Create a new node iterator over the subtree rooted at the specified node.
			-- Parameters:
			-- root - The node which will be iterated together with its children. The
			--		iterator is initially positioned just before this node. The
			--		what_to_show flags and the filter, if any, are not considered when
			--		setting this position.
			-- what_to_show - This flag specifies which node types may appear in the
			--		logical view of the tree presented by the iterator. See the
			--		description of iterator for the set of possible values. These flags
			--		can be combined using 'bit_or'
			-- filter - The filter to be used with this node iterator, or Void to
			--		indicate no filter.
			-- entity_reference_expansion - the value of this flag determines whether
			--		entity reference nodes are expanded.
		require
			root_exists: root /= Void
		deferred
		ensure
			result_exists: Result /= Void
		end
		
--	create_tree_walker (root: DOM_NODE; what_to_show: INTEGER;
--		filter: DOM_NODE_FILTER; entity_reference_expansion: BOOLEAN) is
			-- Create a new tree walker over the subtree rooted at the specified node.
			-- Parameters:
			-- root - The node which will be iterated together with its children. The
			--		walker is initially positioned just before this node. The
			--		what_to_show flags and the filter, if any, are not considered when
			--		setting this position.
			-- what_to_show - This flag specifies which node types may appear in the
			--		logical view of the tree presented by the walker. See the
			--		description of tree walker for the set of possible values. These flags
			--		can be combined using 'bit_or'
			-- filter - The filter to be used with this node walker, or Void to
			--		indicate no filter.
			-- entity_reference_expansion - the value of this flag determines whether
			--		entity reference nodes are expanded.
--		require
--			root_exists: root /= Void
--		deferred
--		ensure
--			result_exists: Result /= Void
--		end

end -- class DOM_DOCUMENT_TRAVERSAL
