indexing
	description: "Text"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Document Object Model (DOM) Core"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class DOM_TEXT

inherit

   DOM_CHARACTER_DATA
	  
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
	  require
		  not_index_size_err: offset >= 0 and offset <= length
		  not_no_modification_allowed_err: not readonly
      deferred
	  ensure
		  result_exists: Result /= Void
		  first_half: length = offset - 1
		  second_half: Result.length = old length - offset	
		  second_half_sibling: next_sibling = Result
      end

feature -- from DOM_NODE

   node_type: INTEGER is
      once
      	  Result := Text_node
      end

	node_name: DOM_STRING is
		once
			!! Result.make_from_string ("#text")
		end
	
end -- class DOM_TEXT
