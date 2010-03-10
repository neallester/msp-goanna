indexing
	description: "Node list implementation"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Document Object Model (DOM) Core Implementation"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class DOM_NODE_LIST_IMPL

inherit

	DOM_NODE_LIST
		undefine
			copy, is_equal
		end

	DS_ARRAYED_LIST [DOM_NODE]
		rename
			make as arrayed_list_make,
			is_empty as empty,
			item as index_item,
			count as length
		end

creation

	make

feature -- Creation

	make is
			-- Create new empty node list.
		do
			arrayed_list_make (0)
		end

feature -- Access

	item (i: INTEGER): DOM_NODE is
         -- Returns the `index'th item in the collection. If `index'
         -- is greater than or equal to the number of nodes in the list,
         -- this returns `Void'.
         -- Parameters
         --    index   Index into the collection.
         -- Return Value
         --    The node at the `index'th position in the NodeList,
         --    or `Void' if that is not a valid index.
	  local 
		  adjusted_index: INTEGER
      do
		  -- adjust index and check if valid
		  adjusted_index := i + 1
		  if not valid_index (adjusted_index) then
			  Result := Void
		  else
			  Result := index_item (adjusted_index)
		  end
      end

end -- class DOM_NODE_LIST_IMPL
