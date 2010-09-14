note
	description: "Attribute implementation"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Document Object Model (DOM) Core Implementation"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class DOM_ATTR_IMPL

inherit

	DOM_ATTR

	DOM_PARENT_NODE
		rename
			make as parent_make
		redefine
			set_node_value, 
			node_value, 
			namespace_uri, 
			local_name,
			ns_prefix,
			set_prefix
		end
			
create

	make, make_without_owner, make_with_namespace

feature -- Factory creation

	make (owner_doc: DOM_DOCUMENT; new_name: DOM_STRING)
			-- Create a new attribute node.
		require
			owner_doc_exists: owner_doc /= Void
			new_name_exists: new_name /= Void
		do
			make_without_owner (new_name)
			set_owner_document (owner_doc)
		end

	make_without_owner (new_name: DOM_STRING)
			-- Create a new attribute node without an owner document.
		require
			new_name_exists: new_name /= Void
		do
			parent_make
			name := new_name
			specified := true 
			create {DOM_STRING} value.make_from_string ("")
		end

	make_with_namespace (owner_doc: DOM_DOCUMENT; new_namespace_uri, new_qualified_name : DOM_STRING)
			-- Create a new attribute node with a namespace
		require
			owner_doc_exists: owner_doc /= Void
			new_name_exists: new_qualified_name /= Void
			new_namespace_uri_exists: new_namespace_uri /= Void
		local
			i: INTEGER
			c: UC_CHARACTER
		do
			make (owner_doc, new_qualified_name)
			namespace_uri := new_namespace_uri
			-- extract prefix and local name
			c.make_from_character (':')
			i := new_qualified_name.index_of (c, 1)
			if i > 0 then
				ns_prefix := new_qualified_name.substring (1, i - 1)
				local_name := new_qualified_name.substring (i + 1, new_qualified_name.count)
			else
				local_name := clone (new_qualified_name)
			end
		end
		
feature

   name: DOM_STRING
         -- The name of this attribute.

   specified: BOOLEAN
         -- If this attribute was explicitly given a value in the original
         -- document, this is `True'; otherwise, it is `False'. Note that
         -- the implementation is in charge of this attribute, not the
         -- user. If the user changes the value of the attribute (even if
         -- it ends up having the same value as the default value) then
         -- the `specified' flag is automatically flipped to `True'. To
         -- re-specify the attribute as the default value from the DTD,
         -- the user must delete the attribute. The implementation will
         -- then make a new attribute available with `specified' set to `False'
         -- and the default value (if one exists).
         -- In summary:
         --    If the attribute has an assigned value in the document
         --    then specified is `True', and the value is the assigned value.
         --    If the attribute has no assigned value in the document and
         --    has a default value in the DTD, then `specified' is `False',
         --    and the value is the default value in the DTD.
         --    If the attribute has no assigned value in the document and
         --    has a value of #IMPLIED in the DTD, then the attribute does
         --    not appear in the structure model of the document.
		 -- DOM Level 2.

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
		
   value: DOM_STRING
         -- The value of the attribute is returned as a string. Character
         -- and general entity references are replaced with their values.

   set_value (v: DOM_STRING)
         -- This creates a Text node with the unparsed contents of the string.
	  do
		  value := v
      end

	owner_element: DOM_ELEMENT 
			-- The element node this attribute is attached to or Void if this 
			-- attribute is not in use.
			-- DOM Level 2.

	ns_prefix: DOM_STRING
			-- The namespace prefix of this node, or Void if it is unspecified.
			-- DOM Level 2.

	set_prefix (new_prefix: DOM_STRING)
			-- Set the namespace prefix of this node.
			-- DOM Level 2.
		do
			ns_prefix := new_prefix
		end

	local_name: DOM_STRING
			-- Returns the local part of the qualified name of this node.
			-- DOM Level 2.
			
feature -- from DOM_NODE
   
	node_name: DOM_STRING
         -- The name of this node, depending on its type.
      do
		  Result := name
      end

	node_value: DOM_STRING
         -- The value of this node, depending on its type.
      do 
		  Result := value
	  end

   set_node_value (v: DOM_STRING)
         -- see `value'
   	  do
		  set_value (v)
      end

   node_type: INTEGER
         -- A code representing the type of the underlying object.
      once
		  Result := Attribute_node
      end

end -- class DOM_ATTR_IMPL
