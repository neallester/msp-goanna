note
	description : "Collections of nodes that can be accessed by name. %
      	%NamedNodeMaps are not maintained in any particular order. %
      	%Objects contained in an object implementing NamedNodeMap %
      	%may also be accessed by an ordinal index, but this is %
      	%simply to allow convenient enumeration of the contents %
      	%of a NamedNodeMap, and does not imply that the DOM specifies %
      	%an order to these Nodes.";
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Document Object Model (DOM) Core"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class DOM_NAMED_NODE_MAP

inherit

	DOM_NODE_TYPE
		
feature

   get_named_item (name: DOM_STRING): DOM_NODE
         -- Retrieves a node specified by `name'. 
         -- Parameters 
         --    name   Name of a node to retrieve.
         -- Return Value 
         --    A Node (of any type) with the specified name.
		 -- Note: precondition 'has_item' is not standard DOM.
	  require
		  has_item: has_named_item (name)
      deferred
      end

   set_named_item (arg: DOM_NODE): DOM_NODE
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
	  require
		  arg_exists: arg /= Void
		  -- not_wrong_document_err: arg.owner_document = owner_document
		  -- not_no_modification_allowed_err: not readonly
		  not_inuse_attribute_err: arg.node_type = Attribute_node implies
			  arg.owner_document = Void
      deferred
	  ensure
		  arg_set: get_named_item (arg.node_name) = arg
      end

   remove_named_item (name: DOM_STRING): DOM_NODE
         -- Removes a node specified by `name'. If the removed node
         -- is an Attr with a default value it is immediately replaced.
         -- Parameters
         --    name   The name of a node to remove.
         -- Return Value
         --    The node removed from the map.
		 -- Note: precondition 'not_not_found_err' is not standard DOM.
	  require
		  not_not_found_err: has_named_item (name)
		  -- not_no_modification_allowed_err: not readonly
      deferred
	  ensure
		  item_removed: not has_named_item (name)
		  result_exists: Result /= Void
		  result_named_item: Result.node_name.is_equal (name)
      end

	has_named_item (name: DOM_STRING): BOOLEAN
			-- Does an item named 'name' exist in this map?
		require
			name_exists: name /= Void
		deferred
		end

   item (index: INTEGER): DOM_NODE
         -- Returns the `index'th item in the map. If index is greater
         -- than or equal to the number of nodes in the map,
         -- this returns null.
         -- Parameters
         --    index   Index into the map.
         -- Return Value
         --    The node at the `index'th position in the NamedNodeMap,
         --    or null if that is not a valid index.
	  require
		  positive_index: index >= 0
      deferred
      end

   length: INTEGER
         -- The number of nodes in the map.
         -- The range of valid child node indices is 0 to `length'-1 inclusive.
      deferred
      end

	get_named_item_ns (namespace_uri, local_name: DOM_STRING): DOM_NODE
			-- Retrieves a node specified by local name and namespace URI.
			-- DOM Level 2.
			-- Note: precondition 'has_item' is not standard DOM.
		require
			namespace_uri_exists: namespace_uri /= Void
			local_name_exists: local_name /= Void
			has_item: has_named_item_ns (namespace_uri, local_name)
		deferred
		ensure
			result_exists: Result /= Void
			named_item_found: Result.namespace_uri.is_equal (namespace_uri) and
				Result.local_name.is_equal (local_name)
		end

	set_named_item_ns (arg: DOM_NODE): DOM_NODE
			-- Adds a node using its namespace_uri and local_name. If a node
			-- with that namespace URI and local name is already present in this
			-- map, it is replaced by the new one.
			-- DOM Level 2.
		require
			arg_exists: arg /= Void
			-- not_wrong_document_err: arg.owner_document = owner_document
			-- not_no_modification_allowed_err: not readonly
			not_inuse_attribute_err: arg.node_type = Attribute_node implies
				arg.owner_document = Void
      deferred
	  ensure
		  arg_set: get_named_item_ns (arg.namespace_uri, arg.local_name) = arg
      end

	remove_named_item_ns (namespace_uri, local_name: DOM_STRING): DOM_NODE
			-- Removes a node specified by local name and namespace URI.
			-- A removed attribute may be known to have a default value when
			-- this map contains the attributes attached to an element,
			-- as returned by the attributes attribute fo the DOM_NODE interface.
			-- If so, an attribute immediately appears containing teh default
			-- value as well as the corresponding namespace URI, local name,
			-- and prefix when applicable.
			-- DOM Level 2.
			-- Note: precondition 'not_not_found_err' is not standard DOM.
		require
			not_not_found_err: has_named_item_ns (namespace_uri, local_name)
			-- not_no_modification_allowed_err: not readonly
      	deferred
		ensure
			item_removed: not has_named_item_ns (namespace_uri, local_name)
			result_exists: Result /= Void
			result_named_node: Result.namespace_uri.is_equal (namespace_uri) and
				Result.local_name.is_equal (local_name)
      	end
		
	has_named_item_ns (namespace_uri, local_name: DOM_STRING): BOOLEAN
			-- Does an item named 'local_name' in 'namespace_uri' 
			-- exist in this map?
		require
			namespace_uri_exists: namespace_uri /= Void
			local_name_exists: local_name /= Void
		deferred
		end
	
feature -- Validation Utility

	empty: BOOLEAN
			-- Does this node list have no elements?
		deferred
		end

end -- class DOM_NAMED_NODE_MAP
