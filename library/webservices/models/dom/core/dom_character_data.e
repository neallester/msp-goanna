note
	description: "Character Data"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Document Object Model (DOM) Core"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class DOM_CHARACTER_DATA

inherit

	DOM_NODE

feature

   data: DOM_STRING
			-- The character data of the node that implements this interface.
			-- The DOM implementation may not put arbitrary limits on the amount
			-- of data that may be stored in a CharacterData node. However,
			-- implementation limits may mean that the entirety of a node's data
			-- may not fit into a single DOMString. In such cases, the user
			-- may call substringData to retrieve the data in appropriately
			-- sized pieces.
		deferred
		end

	set_data (v: DOM_STRING)
			-- see `data'
		deferred
		end
	
	substring_data (offset: INTEGER; count: INTEGER): DOM_STRING
         -- Extracts a range of data from the node.
         -- Parameters
         --    offset   Start offset of substring to extract.
         --    count    The number of characters to extract.
         -- Return Value
         --    The specified substring. If the sum of `offset' and `count'
         --    exceeds the `length', then all characters to the end of the
         --    data are returned.
		
	  deferred
      end

   append_data (arg: DOM_STRING)
         -- Append the string to the end of the character data of the node.
         -- Upon success, data provides access to the concatenation
         -- of data and the DOM_String specified.
         -- Parameters
         --    arg   The DOM_String to append.
	  deferred
      end

   insert_data (offset: INTEGER; arg: DOM_STRING)
         -- Insert a string at the specified character offset.
         -- Parameters
         --    offset   The character offset at which to insert.
         --    arg      The DOMString to insert.
	  deferred
      end

   delete_data (offset: INTEGER; count: INTEGER)
         -- Remove a range of characters from the node. Upon success,
         -- data and length reflect the change.
         -- Parameters
         --    offset   The offset from which to remove characters.
         --    count    The number of characters to delete. If the sum
         --             of `offset' and `count' exceeds `length' then
         --             all characters from offset to the end of the data
         --             are deleted.
	  deferred
      end

   replace_data (offset: INTEGER; count: INTEGER; arg: DOM_STRING)
         -- Replace the characters starting at the specified character
         -- `offset' with the specified string.
         -- Parameters
         --    offset   The offset from which to start replacing.
         --    count    The number of characters to replace. If the sum
         --             of `offset' and `count' exceeds `length', then all
         --             characters to the end of the data are replaced
         --             (i.e., the effect is the same as a remove method call
         --             with the same range, followed by an append method
         --             invocation).
         --    arg      The DOMString with which the range must be replaced.
	  deferred
      end

	length: INTEGER
			-- Length of character data
		deferred
		end

end -- class DOM_CHARACTER_DATA
