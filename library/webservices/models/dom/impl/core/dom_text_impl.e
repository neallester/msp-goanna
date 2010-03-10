indexing
	description: "Text implementation"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Document Object Model (DOM) Core Implementation"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class DOM_TEXT_IMPL

inherit

	DOM_TEXT

	DOM_CHARACTER_DATA_IMPL

creation

	make

feature

   split_text (offset: INTEGER): DOM_TEXT is
         -- Breaks this Text node into two Text nodes at the specified
         -- `offset', keeping both in the tree as siblings. This node
         -- then only contains all the content up to the `offset' point.
         -- And a new Text node, which is inserted as the next sibling
         -- of this node, contains all the content at and after
         -- the `offset' point.
         -- Parameters
         --    offset   The offset at which to split, starting from 0.
         -- Return Value
         --    The new Text node.
	  do
      end

end -- class DOM_TEXT_IMPL
