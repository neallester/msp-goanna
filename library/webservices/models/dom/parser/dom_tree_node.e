indexing

	description: "A container for a DOM_NODE and its namespace declarations, if any"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "XML Parser"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	DOM_TREE_NODE

inherit
	
	UT_STRING_FORMATTER
		export
			{NONE} all
		end
		
creation
	
	make_with_attributes, make_with_node
	
feature
		
	make_with_attributes (attributes: DS_BILINEAR [DOM_ATTR]) is
			-- Create new holder and extract namespace declarations from
			-- 'attributes'.
		require
			attributes_exist: attributes /= Void
		local
			c: DS_BILINEAR_CURSOR [DOM_ATTR]
			attr_name, nc_name: DOM_STRING
		do
			-- search for namespace declarations. They will have the prefix "xmlns" (for a
			-- default namespace) or "xmlns:NCName" (for a named namespace).
			from
				c := attributes.new_cursor
				c.start
			until
				c.off
			loop
				-- check attribute for named namespace prefix
				attr_name := c.item.name
				if attr_name.substring_index (Namespace_name_prefix, 1) > 0 then
					-- named namespace. Extract NCName and store in namespaces
					if namespaces = Void then
						create namespaces.make (1)
					end
					nc_name := attr_name.substring (attr_name.index_of (Namespace_name_separator, 1) + 1, attr_name.count)
					namespaces.force (c.item.node_value, nc_name)
					debug ("namespace")
						print ("Found namespace prefix=" + quoted_eiffel_string_out (nc_name.out))
						print (" uri=" + quoted_eiffel_string_out (c.item.node_value.out) + "%R%N")
					end
				elseif attr_name.is_equal (Default_namespace_prefix) then
					-- default namespace, store as default
					default_namespace := c.item.node_value	
					debug ("namespace")
						print ("Found default namespace uri=" + quoted_eiffel_string_out (c.item.node_value.out) + "%R%N")
					end
				end
				c.forth
			end
		end
		
	make_with_node (new_node: like node) is
			-- Create new tree node holding 'new_node'
		require
			node_exists: new_node /= Void
		do
			set_node (new_node)
		end
		
feature -- Status
	
	node: DOM_NODE
			-- The node
	
	namespaces: DS_HASH_TABLE [DOM_STRING, DOM_STRING]
			-- Namespaces declared within the scope of this node.
	
	default_namespace: DOM_STRING
			-- Default namespace, or Void if not defined in this node.
			
feature -- Status setting

	set_node (new_node: like node) is
			-- Set 'node' to 'new_node'
		require
			node_exists: new_node /= Void
		do
			node := new_node
		end
	
	find_namespace_uri (ns_prefix: DOM_STRING): DOM_STRING is
			-- Find a namespace URI bound to 'ns_prefix'. Return
			-- an empty string if not found.
		require
			ns_prefix_exists: ns_prefix /= Void
		do	
			create Result.make_from_string ("")								
			if not ns_prefix.is_empty then
				if namespaces /= Void and then namespaces.has (ns_prefix) then
					Result := namespaces.item (ns_prefix)
				end
			else
				-- try default prefix
				if default_namespace /= Void then
					Result := default_namespace
				end
			end
			debug ("namespace")
				print ("Found namespace for prefix " + quoted_eiffel_string_out (ns_prefix.out) + "=")
				print (quoted_eiffel_string_out (Result.out))
				print ("%R%N")
			end
		ensure
			empty_uri_if_not_found: Result /= Void
		end
		
feature {NONE} -- Implementation

	Namespace_name_prefix: DOM_STRING is
			-- Namespace prefix
		once
			create Result.make_from_string ("xmlns:")
		end
		
	Default_namespace_prefix: DOM_STRING is
			-- Default namespace prefix
		once
			create Result.make_from_string ("xmlns")
		end
	
	Namespace_name_separator: UC_CHARACTER is
			-- Default namespace name separator
		once
			Result.make_from_character (':')
		end
end -- class DOM_TREE_NODE
