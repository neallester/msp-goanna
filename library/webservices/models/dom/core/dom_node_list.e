note
	description: "The abstraction of an ordered collection of nodes, %
		%without defining or constraining how this collection %
		%is implemented.",
		"The items are accessible via an integral index, starting from 0.";
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Document Object Model (DOM) Core"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class DOM_NODE_LIST

feature

   item (index: INTEGER): DOM_NODE
         -- Returns the `index'th item in the collection. If `index'
         -- is greater than or equal to the number of nodes in the list,
         -- this returns `Void'.
         -- Parameters
         --    index   Index into the collection.
         -- Return Value
         --    The node at the `index'th position in the NodeList,
         --    or `Void' if that is not a valid index.
      require
         non_negative_index: index >= 0
      deferred
      end

   length: INTEGER
         -- The number of nodes in the list.
         -- The range of valid child node indices is 0 to `length'-1 inclusive.
      deferred
      end

feature -- Utility

	empty: BOOLEAN
			-- Does this node list have no elements?
		deferred
		end

	force_last (new_node: DOM_NODE)
			-- Add 'new_node' to end of list.
		require
			new_node_exists: new_node /= Void
		deferred
		end

	delete (old_node: DOM_NODE)
			-- Remove 'old_node' from list. If 'old_node' not found go off.
		require
			old_node_exists: old_node /= Void
		deferred
		end
	
	first: DOM_NODE
			-- First node in list.
		deferred
		end

	last: DOM_NODE
			-- Last node in list.
		deferred
		end

invariant

   non_negative_length: length >= 0

end -- class DOM_NODE_LIST
