indexing
	description: "Objects that filter nodes with 'id' attributes"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "XMLE Tool"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	ID_NODE_FILTER

inherit
	DOM_NODE_FILTER

feature -- Basic opterations

	accept_node (node: DOM_NODE): INTEGER is
			-- Test whether a specified node is visible in the logical view of a 
     		-- DOM_TREE_WALKER or DOM_NODE_ITERATOR. This function will be called by the 
     		-- implementation of DOM_TREE_WALKER and DOM_NODE_ITERATOR; it is not intended to 
     		-- be called directly from user code.     		
		do
			Result := Filter_skip
			if node.has_attributes and node.attributes.has_named_item (Id_attribute) then	
				Result := Filter_accept	
			end		
		end
		
feature {NONE} -- Implementation

	Id_attribute: DOM_STRING is
	 	once
	 		create Result.make_from_string ("id") 	
	 	end
	
end -- class ID_NODE_FILTER
