note
	description: "A stack of DOM_NODES with typed accessor methods"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "XML Parser"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	DOM_NODE_STACK

	-- Replace ANY below by the name of parent class if any (adding more parents
	-- if necessary); otherwise you can remove inheritance clause altogether.
inherit
	
	DS_ARRAYED_STACK [DOM_TREE_NODE]

create
	make, make_equal, make_default

feature -- Access

	item_node_as_element: DOM_ELEMENT
			-- Return current item as an element
		do
			Result ?= item.node
			check 
				is_element_node: Result /= Void
			end
		end

	find_namespace_for_attribute (qname: DOM_STRING;
		attributes: DS_BILINEAR [DS_PAIR [DS_PAIR [UC_STRING, UC_STRING], UC_STRING]]): DOM_STRING
			-- Find a namespace URI bound to the prefix of 'qname' if one exists. Search
			-- the raw attributes structure first then search the current element and all
			-- ancestors.
		require
			qname_exists: qname /= Void
			attributes_exists: attributes /= Void
		local
			i: INTEGER
			c: UC_CHARACTER
			ns_prefix: DOM_STRING
			cursor: DS_BILINEAR_CURSOR [DS_PAIR [DS_PAIR [UC_STRING, UC_STRING], UC_STRING]]
			pair: DS_PAIR [DS_PAIR [UC_STRING, UC_STRING], UC_STRING]
		do
			create Result.make (0)
			-- extract prefix
			c.make_from_character (':')
			i := qname.index_of (c, 1)
			if i /= 0 then
				ns_prefix := qname.substring (1, i - 1)
				-- search attributes
				-- attributes are stored with DS_PAIR [DS_PAIR [name, prefix], value]]
				from
					cursor := attributes.new_cursor
					cursor.start
				until
					cursor.off
				loop
					pair := cursor.item
					if pair.first.second.is_equal (Default_namespace_prefix)
						and then pair.first.first.is_equal (ns_prefix) then
						create Result.make_from_ucstring (pair.second)
					end
					cursor.forth
				end
				-- if not found then search the element and its ancestors
				if Result.is_empty then
					Result := find_namespace_uri (ns_prefix, Void)	
				end		
			end
		end
		
	find_namespace_uri (ns_prefix: DOM_STRING; current_node: DOM_TREE_NODE): DOM_STRING
			-- Find a namespace URI bound to 'ns_prefix'. Start the search in 
			-- 'current_node', if specified, then traverse stack of nodes.
			-- Return an empty string if not found
		require
			ns_prefix_exists: ns_prefix /= Void
		local
			items: like Current
			found: BOOLEAN
		do
			-- search current node for prefix
			if current_node /= Void then
				Result := current_node.find_namespace_uri (ns_prefix)
			else
				create Result.make (0)
			end
			if Result.is_empty then
				items := clone (Current)
				from
				until
					items.is_empty or found
				loop
					Result := items.item.find_namespace_uri (ns_prefix)
					if not Result.is_empty then
						found := True
					else
						items.remove
					end
				end
			end
		ensure
			empty_uri_if_not_found: Result /= Void
		end
	
feature {NONE} -- Implementation

	Default_namespace_prefix: DOM_STRING
			-- Default namespace prefix
		once
			create Result.make_from_string ("xmlns")
		end

end -- class DOM_NODE_STACK
