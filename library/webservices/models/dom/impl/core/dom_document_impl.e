indexing
	description: "Document implementation"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Document Object Model (DOM) Core Implementation"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class DOM_DOCUMENT_IMPL

inherit

	DOM_DOCUMENT

	DOM_PARENT_NODE
		rename
			make as parent_node_make
		export
			{NONE} parent_node_make
		redefine
			append_child, insert_before, remove_child
		end

	DOM_XML_NAMESPACE_CONSTANTS
		export
			{NONE} all
		end
		
creation

	make

feature {DOM_IMPLEMENTATION_IMPL} -- Factory creation

	make (new_doctype: DOM_DOCUMENT_TYPE) is
			-- Create new document with specified doctype. 
			-- 'doctype' may be Void.
		do
			parent_node_make
			doctype := new_doctype
			if doctype /= Void then
				doctype.set_owner_document (Current)
			end
		ensure
			doctype_set: doctype = new_doctype
			doctype_owner_set: doctype /= Void implies doctype.owner_document = Current
		end

feature -- Access

	doctype: DOM_DOCUMENT_TYPE 
			-- The Document Type Declaration associated with this
			-- document. For HTML documents as well as XML documents
			-- without a document type declaration this returns `Void'.

	document_element: DOM_ELEMENT 
    		-- This is a convenience attribute that allows direct access
    		-- to the child node that is the root element of the document.
    		-- For HTML documents, this is the element with the tagName
    		-- "HTML".

   create_element (tag_name: DOM_STRING): DOM_ELEMENT is
         	-- Creates an element of the type specified.
         	-- Parameters
         	--    tagName   The name of the element type to instantiate.
         	--              For XML, this is case-sensitive. For HTML,
         	--              the tagName parameter may be provided in any case,
         	--              but it must be mapped to the canonical uppercase
         	--              form by the DOM implementation.
         	-- Return Value
         	--    A new Element object.
		do
			!DOM_ELEMENT_IMPL! Result.make (Current, tag_name)
		end

	create_document_fragment: DOM_DOCUMENT_FRAGMENT is
			-- Creates an empty DocumentFragment object.
			-- Return Value
			--    A new DocumentFragment.
		do
			!DOM_DOCUMENT_FRAGMENT_IMPL! Result.make (Current)
		end

	create_text_node (data: DOM_STRING): DOM_TEXT is
			-- Creates a Text node given the specified string.
			-- Parameters
			--    data   The data for the node.
			-- Return Value
			--    The new Text object.
		do
			!DOM_TEXT_IMPL! Result.make (Current, data)
		end

	create_comment (data: DOM_STRING): DOM_COMMENT is
			-- Creates a Comment node given the specified string.
			-- Parameters
			--    data   The data for the node.
			-- Return Value
			--    The new Comment object.
		do
			!DOM_COMMENT_IMPL! Result.make (Current, data)
		end

	create_cdata_section (data: DOM_STRING): DOM_CDATA_SECTION is
			-- Creates a CDATASection node whose value is the specified string.
			-- Parameters
			--    data   The data for the CDATASection [p.43] contents.
			-- Return Value
			--    The new CDATASection [p.43] object.
		do
			!DOM_CDATA_SECTION_IMPL! Result.make (Current, data)
		end

	create_processing_instruction (target: DOM_STRING; data: DOM_STRING):
		DOM_PROCESSING_INSTRUCTION is
			-- Creates a ProcessingInstruction node given the specified name
			-- and data strings.
			-- Parameters
			--    target   The target part of the processing instruction.
			--    data     The data for the node.
			-- Return Value
			--    The new ProcessingInstruction [p.46] object.
		do
			!DOM_PROCESSING_INSTRUCTION_IMPL! Result.make (Current, target, data)
		end

	create_attribute (name: DOM_STRING): DOM_ATTR is
			-- Creates an Attr of the given name. Note that the Attr instance
			-- can then be set on an Element using the setAttribute method.
			-- Parameters
			--    name   The name of the attribute.
			-- Return Value
			--    A new Attr object.
		do
			!DOM_ATTR_IMPL! Result.make (Current, name)
		end

	create_entity_reference (name: DOM_STRING): DOM_ENTITY_REFERENCE is
			-- Creates an EntityReference object.
			-- Parameters
			--    name   The name of the entity to reference.
			-- Return Value
			--    The new EntityReference object.
		do
			!DOM_ENTITY_REFERENCE_IMPL! Result.make (Current, name)
		end

	get_elements_by_tag_name (tagname: DOM_STRING): DOM_NODE_LIST is
			-- Returns a NodeList of all the Elements with a given tag name
			-- in the order in which they would be encountered in a preorder
			-- traversal of the Document tree.
			-- Parameters
			--    tagname   The name of the tag to match on.
			--              The special value "*" matches all tags.
			-- Return Value
			--    A new NodeList object containing all the matched Elements.
			-- This method raises no exceptions.
		do
		end

	import_node (imported_node: DOM_NODE; deep: BOOLEAN): DOM_NODE is
			-- Imports a node from another document to this document. The returned
			-- has no parent; ('parent_node is Void). The source node is not altered
			-- or removed from the original doeumtnt; this method creates a new copy
			-- of the source node.
			-- For all nodes, importing a node creates a node object owned by the 
			-- importing document, with attribute values identical to the source node's
			-- 'node_name' and 'node_type', plus the attributes related to namespaces
			-- ('prefix', 'local_name', and 'namespace_uri'). As in the 'clone_node'
			-- operation on a DOM_NODE, the source node is not altered.
		do
		end

	create_element_ns (new_namespace_uri, qualified_name: DOM_STRING): DOM_ELEMENT is
			-- Creates an element of the given qualified name and namespace URI.
			-- DOM Level 2.
		do
			create {DOM_ELEMENT_IMPL} Result.make_with_namespace (Current, 
				new_namespace_uri, qualified_name)
		end

	create_attribute_ns (new_namespace_uri, qualified_name: DOM_STRING): DOM_ATTR is
			-- Creates an attribute of the given qualified name and namespace URI.
			-- DOM Level 2.
		do
			create {DOM_ATTR_IMPL} Result.make_with_namespace (Current,
				new_namespace_uri, qualified_name)
		end

	get_elements_by_tag_name_ns (a_namespace_uri, localname: DOM_STRING): DOM_NODE_LIST is
			-- Returns a NodeList of all the Elements with a given local name and
			-- namespace URI in the order in which they would be encountered in a preorder
			-- traversal of the Document tree.
			-- Parameters
			--    a_namespace_uri	The namespace URI of the elements to match on. The special 
			--                  special value "*" matches all namespaces.
			--    localname The local name of the elements to match on. The special value "*"
			--              matches all local names.
			-- Return Value
			--    A new NodeList object containing all the matched Elements.
			-- This method raises no exceptions.
		do
		end
	
	get_element_by_id (element_id: DOM_STRING): DOM_ELEMENT is
			-- Returns the element whose ID is given by 'element_id'. If no such
			-- element exists, returns Void. Behaviour is not defined if more than
			-- one element has this ID.
			-- Parameters
			--     element_id The unique id value for an element
			-- Return Value
			--     The matchine element.
			-- This method raises no exceptions.
		do
		end
		
	append_child (new_child: DOM_NODE): DOM_NODE is
			-- Adds the node `newChild' to the end of the list of children
			-- of this node. If the `newChild' is already in the tree,
			-- it is first removed.
			-- If `newChild' is an element it is set as the document element.
			-- If `newChild' is a document type element then it is set as the
			-- the doc_type element.
			-- Parameters
			--    newChild   The node to add. If it is a DocumentFragment
			--               object, the entire contents of the document
			--               fragment are moved into the child list
			--               of this node
			-- Return Value
			--    The node added.
		do
			Result := Precursor (new_child)
			if new_child.node_type = Element_node then
				document_element ?= new_child
			elseif new_child.node_type = Document_type_node then
				doctype ?= new_child
			end
		ensure then
			doc_element_if_element: new_child.node_type = Element_node implies document_element = new_child
			doctype_if_doc_type_element: new_child.node_type = Document_type_node implies doctype = new_child
		end
		
	insert_before (new_child: DOM_NODE; ref_child: DOM_NODE): DOM_NODE is
			-- Inserts the node newChild before the existing child node
			-- `refChild'. If `refChild' is `Void', insert `newChild' at the end
			-- of the list of children. If `newChild' is a DocumentFragment
			-- object, all of its children are inserted, in the same order,
			-- before `refChild'. If the `newChild' is already in the tree,
			-- it is first removed.
			-- If `newChild' is an element it is set as the document element.
			-- If `newChild' is a document type element then it is set as the
			-- the doc_type element.
			-- Parameters
			--    newChild   The node to insert.
			--    refChild   The reference node, i.e., the node before
			--               which the new node must be inserted.
			-- Return Value
			--    The node being inserted.
			-- (from DOM_NODE_IMPL)
		do
			Result := Precursor (new_child, ref_child)
			if new_child.node_type = Element_node then
				document_element ?= new_child
			elseif new_child.node_type = Document_type_node then
				doctype ?= new_child
			end
		ensure then
			doc_element_if_element: new_child.node_type = Element_node implies document_element = new_child
			doctype_if_doc_type_element: new_child.node_type = Document_type_node implies doctype = new_child
		end
		
	remove_child (old_child: DOM_NODE): DOM_NODE is
			-- Removes the child node indicated by oldChild from the list
			-- of children, and returns it.
			-- If 'old_child' is the document element then unset it.
			-- If 'old_child' is the document type then unset it.
			-- Parameters
			--    oldChild   The node being removed.
			-- Return Value
			--    The node removed.
			-- (from DOM_NODE_IMPL)
		do
			Result := Precursor (old_child)
			if old_child = document_element then
				document_element := Void
			elseif old_child = doctype then
				doctype := Void
			end
		ensure then
			doc_element_unset_if_equal: old_child = old document_element implies document_element = Void
			doctype_unset_if_equal: old_child = old doctype implies doctype = Void
		end
		
feature -- Document Traversal

	create_node_iterator (root: DOM_NODE; what_to_show: INTEGER;
		filter: DOM_NODE_FILTER; entity_reference_expansion: BOOLEAN): DOM_NODE_ITERATOR is
			-- Create a new node iterator over the subtree rooted at the specified node.
			-- Parameters:
			-- root - The node which will be iterated together with its children. The
			--		iterator is initially positioned just before this node. The
			--		what_to_show flags and the filter, if any, are not considered when
			--		setting this position.
			-- what_to_show - This flag specifies which node types may appear in the
			--		logical view of the tree presented by the iterator. See the
			--		description of iterator for the set of possible values. These flags
			--		can be combined using 'bit_or'
			-- filter - The filter to be used with this node iterator, or Void to
			--		indicate no filter.
			-- entity_reference_expansion - the value of this flag determines whether
			--		entity reference nodes are expanded.
		do
			create {DOM_NODE_ITERATOR_IMPL} Result.make (Current, root, what_to_show,
				filter, entity_reference_expansion)
			-- TODO: need to register this iterator when it supports deletion notification.
		end
		
feature -- from DOM_NODE
   
	node_name: DOM_STRING is
         -- The name of this node, depending on its type.
      once
		  !! Result.make_from_string ("#document")
      end

   node_type: INTEGER is
         -- A code representing the type of the underlying object.
      once
		  Result := Document_node
      end

feature -- Validation Utility

	valid_name_chars (new_name: DOM_STRING): BOOLEAN is
			-- Does 'new_name' consist of valid characters for a document name?
			-- Follows the syntax: 
			-- 		NCNameChar ::= Letter | Digit | '.' | '-' | '_' | ':' | CombiningChar
			--			| Extender
			--		NCName ::= (Letter | '_') (NCNameChar)*
		do
			Result := True
			debug ("dom_assertions")
				print (generator + ".valid_name_chars: " + "not implemented" + "%R%N")
			end
		end

	valid_qualified_name_chars (new_name: DOM_STRING): BOOLEAN is
			-- Does 'new_name' consist of valid characters for a qualified name?
			-- Follows the syntax:
			--		QName ::= NCName (':' NCName)
		do
			Result := True
			debug ("dom_assertions")
				print (generator + ".valid_qualified_name_chars: " + "not implemented" + "%R%N")
			end
		end

	valid_qualified_name (new_namespace_uri, new_name: DOM_STRING): BOOLEAN is
			-- Is 'new_name' a valid name within 'new_namespace_uri'?
			-- Fails if the qualified name is malformed, if the qualified name has a prefix and
			-- the namespace URI is Void, if the qualified name has a prefix that is "xml" 
			-- and the namespace URI is different from "http://www.w3.org/XML/1998/namespace",
			-- or if the qualified name is "xmlns" and the namespace URI is different from
			-- "http://www.w3.org/2000/xmlns".
		local
			colon_index: INTEGER
			has_prefix: BOOLEAN
			name_prefix: DOM_STRING
		do
			Result := True
			colon_index := new_name.index_of (Qname_separator, 1)
			if colon_index > 0 then
				has_prefix := True
				name_prefix := new_name.substring (1, colon_index - 1)
			end
			if has_prefix and new_namespace_uri = Void then
				Result := False
			elseif has_prefix 
				and then name_prefix.is_equal (Xml_prefix) 
				and then not new_namespace_uri.is_equal (Xml_namespace_uri) then
				Result := False
			elseif not has_prefix 
				and then new_name.is_equal (Xmlns_qname) 
				and then not new_namespace_uri.is_equal (Xmlns_default_uri) then
				Result := False
			end
			debug ("dom_assertions")
				print (generator + ".valid_qualified_name: " + Result.out + "%R%N")
			end
		end

	valid_entity_name (new_name: DOM_STRING): BOOLEAN is
			-- Is 'new_name' a valid name for an entity?
		do
			Result := True
			debug ("dom_assertions")
				print (generator + ".valid_entity_name: " + "not implemented" + "%R%N")
			end
		end

	valid_target_chars (new_target: DOM_STRING): BOOLEAN is
			-- Does 'new_target' consist of valid target characters?
		do
			Result := True
			debug ("dom_assertions")
				print (generator + ".valid_target_chars: " + "not implemented" + "%R%N")
			end
		end
	
	valid_node_name (new_name: DOM_STRING): BOOLEAN is
			-- Is 'new_name' a valid name for a node?
		do
			Result := True
			debug ("dom_assertions")
				print (generator + ".valid_node_name: " + "not implemented" + "%R%N")
			end
		end

	import_supported (new_node: DOM_NODE): BOOLEAN is
			-- Can 'new_node' be imported into this document?
		do
			Result := True
			debug ("dom_assertions")
				print (generator + ".import_supported: " + "not implemented" + "%R%N")
			end
		end
		
end -- class DOM_DOCUMENT_IMPL
