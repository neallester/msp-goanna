indexing
	description: "Element implementation"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Document Object Model (DOM) Core Implementation"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class DOM_ELEMENT_IMPL

inherit

	DOM_ELEMENT

	DOM_CHILD_AND_PARENT_NODE
		rename 
			make as parent_node_make
		export
			{NONE} parent_node_make
		redefine
			local_name, namespace_uri, ns_prefix, set_prefix	
		end
		
creation

	make, make_with_namespace

feature {DOM_DOCUMENT} -- Factory creation

	make (doc: DOM_DOCUMENT_IMPL; new_name: DOM_STRING) is
			-- Create new element node
		require
			document_exists: doc /= Void
			new_name_exists: new_name /= Void
		do
			parent_node_make
			!DOM_NAMED_MAP_IMPL [DOM_ATTR]! attributes.make (Current)
			set_owner_document (doc)
			tag_name := new_name
		end

	make_with_namespace (doc: DOM_DOCUMENT_IMPL; new_namespace_uri, qualified_name: DOM_STRING) is
			-- Create new element within namespace.
		require
			namespace_uri_exists: new_namespace_uri /= Void
			qualified_name_exists: qualified_name /= Void
		local
			i: INTEGER
			c: UC_CHARACTER
		do
			make (doc, qualified_name)
			namespace_uri := new_namespace_uri
			-- extract prefix and local name
			c.make_from_character (':')
			i := qualified_name.index_of (c, 1)
			if i > 0 then
				ns_prefix := qualified_name.substring (1, i - 1)
				local_name := qualified_name.substring (i + 1, qualified_name.count)
			else
				local_name := clone (qualified_name)
			end
		end

feature

   tag_name: DOM_STRING 
         -- The name of the element. For example, in:
         --    <elementExample id="demo">
         --    ...
         --    </elementExample> ,
         -- `tagName' has the value "elementExample". Note that this is
         -- case-preserving in XML, as are all of the operations of the DOM.
         -- The HTML DOM returns the `tagName' of an HTML element in the
         -- canonical uppercase form, regardless of the case in the source
         -- HTML document.

   get_attribute (name: DOM_STRING): DOM_STRING is
         -- Retrieves an attribute value by `name'.
         -- Parameters
         --    name   The name of the attribute to retrieve.
         -- Return Value
         --    The Attr value as a string, or the empty string if that
         --    attribute does not have a specified or default value.
	  do
		  Result := attributes.get_named_item (name).node_value
      end

	get_attribute_ns (new_namespace_uri, name: DOM_STRING): DOM_STRING is
			-- Retrieves an attribute value by `name' and namespace URI.
			-- Parameters
			--    name   The name of the attribute to retrieve.
			-- Return Value
			--    The Attr value as a string, or the empty string if that
			--    attribute does not have a specified or default value.
			-- DOM Level 2.
		do
			Result := attributes.get_named_item_ns (new_namespace_uri, name).node_value
		end
		
   set_attribute (name: DOM_STRING; value: DOM_STRING) is
         -- Adds a new attribute. If an attribute with that `name' is
         -- already present in the element, its `value' is changed to be
         -- that of the `value' parameter. This `value' is a simple string,
         -- it is not parsed as it is being set. So any markup (such as
         -- syntax to be recognized as an entity reference) is treated
         -- as literal text, and needs to be appropriately escaped by the
         -- implementation when it is written out. In order to assign
         -- an attribute `value' that contains entity references, the user
         -- must create an Attr node plus any Text and EntityReference nodes,
         -- build the appropriate subtree, and use setAttributeNode to assign
         -- it as the `value' of an attribute.
         -- Parameters
         --    name    The name of the attribute to create or alter.
         --    value   Value to set in string form.
	  local
		  new_attr, discard: DOM_ATTR
	  do
		  new_attr := owner_document.create_attribute (name)
		  new_attr.set_value (value)
		  discard := set_attribute_node (new_attr)
      end

	set_attribute_ns (new_namespace_uri, name: DOM_STRING; value: DOM_STRING) is
			-- Adds a new attribute. If an attribute with that `name' and namespace URI is
			-- already present in the element, its `value' is changed to be
			-- that of the `value' parameter. This `value' is a simple string,
			-- it is not parsed as it is being set. So any markup (such as
			-- syntax to be recognized as an entity reference) is treated
			-- as literal text, and needs to be appropriately escaped by the
			-- implementation when it is written out. In order to assign
			-- an attribute `value' that contains entity references, the user
			-- must create an Attr node plus any Text and EntityReference nodes,
			-- build the appropriate subtree, and use setAttributeNode to assign
			-- it as the `value' of an attribute.
			-- Parameters
			--    name    The name of the attribute to create or alter.
			--    value   Value to set in string form.
			-- DOM Level 2.
		local
			new_attr, discard: DOM_ATTR
	  	do
			new_attr := owner_document.create_attribute_ns (namespace_uri, name)
			new_attr.set_value (value)
			discard := set_attribute_node (new_attr)	
		end
      
   remove_attribute (name: DOM_STRING) is
         -- Removes an attribute by `name'. If the removed attribute
         -- has a default value it is immediately replaced.
         -- Parameters
         --    name   The name of the attribute to remove.
	  local
		  discard: DOM_NODE
	  do
		  discard := attributes.remove_named_item (name)
      end

   remove_attribute_ns (new_namespace_uri, name: DOM_STRING) is
         -- Removes an attribute by 'namespac_uri' and `name'. If 
         -- the removed attribute has a default value it is immediately replaced.
         -- Parameters
         --    name   The name of the attribute to remove.
	  local
		  discard: DOM_NODE
	  do
		  discard := attributes.remove_named_item_ns (new_namespace_uri, name)
      end
      
   get_attribute_node (name: DOM_STRING): DOM_ATTR is
         -- Retrieves an Attr node by `name'.
         -- Parameters
         --    name   The name of the attribute to retrieve.
         -- Return Value
         --    The Attr node with the specified attribute `name' or null
         --    if there is no such attribute.
	  do
		  Result := attributes.get_named_item (name)
      end

   set_attribute_node (new_attr: DOM_ATTR): DOM_ATTR is
         -- Adds a new attribute. If an attribute with that name is
         -- already present in the element, it is replaced by the new one.
         -- Parameters
         --    newAttr   The Attr node to add to the attribute list.
         -- Return Value
         --    If the newAttr attribute replaces an existing attribute
         --    with the same name, the previously existing Attr node is
         --    returned, otherwise null is returned.
	  do
		  Result := attributes.set_named_item (new_attr)
      end

   set_attribute_node_ns (new_attr: DOM_ATTR): DOM_ATTR is
         -- Adds a new attribute. If an attribute with that name is
         -- already present in the element, it is replaced by the new one.
         -- Parameters
         --    newAttr   The Attr node to add to the attribute list.
         -- Return Value
         --    If the newAttr attribute replaces an existing attribute
         --    with the same name, the previously existing Attr node is
         --    returned, otherwise null is returned.
	  do
		  Result := attributes.set_named_item_ns (new_attr)
      end
      
   remove_attribute_node (old_attr: DOM_ATTR): DOM_ATTR is
         -- Removes the specified attribute.
         -- Parameters
         --    oldAttr   The Attr node to remove from the attribute list.
         --              If the removed Attr has a default value it is
         --              immediately replaced.
         -- Return Value
         --    The Attr node that was removed.
	  do
		  Result := attributes.remove_named_item (old_attr.name)
      end

   get_elements_by_tag_name (name: DOM_STRING): DOM_NODE_LIST is
         -- Returns a NodeList of all descendant elements with a given
         -- tag name, in the order in which they would be encountered
         -- in a preorder traversal of the Element tree.
         -- Parameters
         --    name   The name of the tag to match on. The special value
         --           "*" matches all tags.
         -- Return Value
         --    A list of matching Element nodes.
	  do
      end

	has_attribute (name: DOM_STRING): BOOLEAN is
			-- Returns true when an attribute with a given name is specified
			-- on this element or has a default value, false otherwise.
			-- DOM Level 2.
		do
			Result := attributes.has_named_item (name)
		end

	has_attribute_ns (new_namespace_uri: DOM_STRING; name: DOM_STRING): BOOLEAN is
			-- Returns True when an attirbute with a given local name and namespace
			-- URI is specified o this element or has a default value, false otherwise.
			-- DOM Level 2.
		do
			Result := attributes.has_named_item_ns (new_namespace_uri, name)
		end
			
	-- TODO: getAttributeNodeNS, setAttributeNodeNS, getElementsByTagNameNS.

feature -- from DOM_NODE
   
	namespace_uri: DOM_STRING
			-- The namespace URI of this node, or Void if it is unspecified.
			-- This is not a computed value that is the result of a namespace
			-- lookup based on an examination of the namespace declarations
			-- in scope. It is merely the namespace URI given at creation time.
			-- For nodes of any type other than Element_node and Attribute_node
			-- and nodes created with a DOM Level 1 method, such as 
			-- create_element from the DOM_DOCUMENT interface, this is always
			-- Void.
			-- DOM Level 2.
		
	ns_prefix: DOM_STRING
			-- The namespace prefix of this node, or Void if it is unspecified.
			-- DOM Level 2.
	
	set_prefix (new_prefix: DOM_STRING) is
			-- Set the namespace prefix of this node.
			-- DOM Level 2.
		do
			ns_prefix := new_prefix
		end	
		
	local_name: DOM_STRING
			-- Returns the local part of the qualified name of this node.
			-- DOM Level 2.
	
	node_name: DOM_STRING is
         -- The name of this node, depending on its type.
      do
		  Result := tag_name
      end

   node_type: INTEGER is
         -- A code representing the type of the underlying object.
      once
		  Result := Element_node
      end


feature -- Validation Utility

	valid_name_chars (new_name: DOM_STRING): BOOLEAN is
			-- Does 'new_name' consist of valid name characters?
		do
			Result := True
			debug ("dom_assertions")
				print (generator + ".valid_name_chars: " + "not implemented" + "%R%N")
			end

		end

end -- class DOM_ELEMENT_IMPL
