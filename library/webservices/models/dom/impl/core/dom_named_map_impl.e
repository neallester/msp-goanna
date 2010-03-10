indexing
	description: "Named map implementation"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Document Object Model (DOM) Core Implementation"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class DOM_NAMED_MAP_IMPL [G -> DOM_NODE]

inherit

	DOM_NAMED_MAP [G]
		undefine
			is_equal, copy
		end

	DS_HASH_TABLE [G, DOM_STRING]
		rename
			count as length,
			make as hashtable_make,
			is_empty as empty,
			item as get_named_item,
			has as has_named_item
		end

creation

	make

feature -- Factory creation

	make (new_owner: like owner_node) is
			-- Create new named node map for 'owner_node'
		require
			owner_node_exists: new_owner /= Void
		do
			hashtable_make (5)
			set_owner_node (new_owner)
		end
			
feature

	owner_node: DOM_NODE
			-- The owner of this node map.

	set_owner_node (new_owner: like owner_node) is
			-- Set the owner node
		require
			new_owner_exists: new_owner /= Void
		do
			owner_node := new_owner
		end

	set_named_item (arg: G): G is
			-- Adds a node using its nodeName attribute.
			-- As the nodeName attribute is used to derive the name
			-- which the node must be stored under, multiple nodes
			-- of certain types (those that have a "special" string value)
			-- cannot be stored as the names would clash. This is seen
 			-- as preferable to allowing nodes to be aliased.
			-- Parameters
			--    arg   A node to store in a named node map.
			--          The node will later be accessible
			--          using the value of the nodeName attribute
			--          of the node. If a node with that name
			--          is already present in the map, it is replaced
			--          by the new one.
			-- Return Value
			--    If the new Node replaces an existing node with the same name
			--    the previously existing Node is returned, otherwise null
			--    is returned.
		do
			put (arg, arg.node_name)
			Result := arg
		end

	remove_named_item (name: DOM_STRING): G is
			-- Removes a node specified by `name'. If the removed node
			-- is an Attr with a default value it is immediately replaced.
			-- Parameters
			--    name   The name of a node to remove.
			-- Return Value
			--    The node removed from the map.
			-- Note: precondition 'not_not_found_err' is not standard DOM.
		do
			Result := get_named_item (name)
			remove (name)
		end

	get_named_item_ns (namespace_uri, local_name: DOM_STRING): G is
			-- Retrieves a node specified by local name and namespace URI.
			-- DOM Level 2.
			-- Note: precondition 'has_item_ns' is not standard DOM.
		do
			-- combine namespace_uri and local_name to build extended name
			-- and retrieve it
			Result := get_named_item (combine_name (namespace_uri, local_name))
		end

	set_named_item_ns (arg: G): G is
			-- Adds a node using its namespace_uri and local_name. If a node
			-- with that namespace URI and local name is already present in this
			-- map, it is replaced by the new one.
			-- DOM Level 2.
		do
			-- combine namespace_uri and local_name of 'arg' to build extended name
			-- and store it
			force (arg, combine_name (arg.namespace_uri, arg.local_name))
			Result := arg
      	end

	remove_named_item_ns (namespace_uri, local_name: DOM_STRING): G is
			-- Removes a node specified by local name and namespace URI.
			-- A removed attribute may be known to have a default value when
			-- this map contains the attributes attached to an element,
			-- as returned by the attributes attribute fo the DOM_NODE interface.
			-- If so, an attribute immediately appears containing teh default
			-- value as well as the corresponding namespace URI, local name,
			-- and prefix when applicable.
			-- DOM Level 2.
			-- Note: precondition 'not_not_found_err' is not standard DOM.
		local
			combined_name: DOM_STRING
		do
			-- combine namespace_uri and local_name and remove existing 
			-- named node
			combined_name := combine_name (namespace_uri, local_name)
			Result := get_named_item (combined_name)
			remove (combined_name)
      	end
		
	has_named_item_ns (namespace_uri, local_name: DOM_STRING): BOOLEAN is
			-- Does an item named 'local_name' in 'namespace_uri' 
			-- exist in this map?
		do
			-- combine namespace_uri and local_name and search for it
			Result := has_named_item (combine_name (namespace_uri, local_name))
		end

	item (index: INTEGER): G is
			-- Returns the `index'th item in the map. If index is greater
			-- than or equal to the number of nodes in the map,
			-- this returns null.
			-- Parameters
			--    index   Index into the map.
			-- Return Value
			--    The node at the `index'th position in the NamedNodeMap,
			--    or null if that is not a valid index.
		local
			local_keys: DS_HASH_TABLE_CURSOR [G, DOM_STRING]
			current_index: INTEGER
		do
			local_keys := new_cursor
			if index + 1 <= length then
				-- skip forwards index amount
				from
					local_keys.start      
				until
					current_index >= index
				loop
					local_keys.forth
					current_index := current_index + 1		
				end
				Result := local_keys.item		  
			end
 		end

feature {NONE} -- Implementation

	combine_name (uri, local_name: DOM_STRING): DOM_STRING is
			-- Combine 'uri' and 'local_name' to form a 
			-- distinct name for storing attributes with a namespace.
		require
			uri_exists: uri /= Void
			name_exists: local_name /= Void
		do
			Result := clone (uri)
			Result.append_string (":")
			Result.append_uc_string (local_name)
		ensure
			combined_name_exists: Result /= Void
			combined_name_big_enough: Result.count = uri.count + local_name.count + 1
		end
	
	Empty_namespace_uri: DOM_STRING is
		once
			create Result.make_from_string ("")
		end
		
end -- class DOM_NAMED_MAP_IMPL
