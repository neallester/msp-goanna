note
	description: "Document"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Document Object Model (DOM) Core"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class DOM_DOCUMENT

inherit

	DOM_NODE

	DOM_DOCUMENT_TRAVERSAL
		-- This inheritance is not strictly DOM compliant but removes the need
		-- to cast when creating an iterator.
		
feature

	doctype: DOM_DOCUMENT_TYPE
			-- The Document Type Declaration associated with this
			-- document. For HTML documents as well as XML documents
			-- without a document type declaration this returns `Void'.
		deferred
		end

	document_element: DOM_ELEMENT
    		-- This is a convenience attribute that allows direct access
    		-- to the child node that is the root element of the document.
    		-- For HTML documents, this is the element with the tagName
    		-- "HTML".
		deferred
		end

   create_element (tag_name: DOM_STRING): DOM_ELEMENT
         	-- Creates an element of the type specified.
         	-- Parameters
         	--    tagName   The name of the element type to instantiate.
         	--              For XML, this is case-sensitive. For HTML,
         	--              the tagName parameter may be provided in any case,
         	--              but it must be mapped to the canonical uppercase
         	--              form by the DOM implementation.
         	-- Return Value
         	--    A new Element object.
		require
			tag_name_exists: tag_name /= Void
			valid_node_name: valid_node_name (tag_name)
		deferred
		ensure
			result_exists: Result /= Void
			node_name_set: Result.node_name.is_equal (tag_name)
			no_namespace: Result.local_name = Void and Result.ns_prefix = Void
				and Result.namespace_uri = Void
			proper_result_owner: Result.owner_document = Current
		end

	create_document_fragment: DOM_DOCUMENT_FRAGMENT
			-- Creates an empty DocumentFragment object.
			-- Return Value
			--    A new DocumentFragment.
		deferred
		ensure
			result_exists: Result /= Void
			proper_result_owner: Result.owner_document = Current
		end

	create_text_node (data: DOM_STRING): DOM_TEXT
			-- Creates a Text node given the specified string.
			-- Parameters
			--    data   The data for the node.
			-- Return Value
			--    The new Text object.
		require
			data_exists: data /= Void
		deferred
		ensure
			result_exists: Result /= Void
			text_set: Result.node_value.is_equal (data)
			proper_result_owner: Result.owner_document = Current
		end

	create_comment (data: DOM_STRING): DOM_COMMENT
			-- Creates a Comment node given the specified string.
			-- Parameters
			--    data   The data for the node.
			-- Return Value
			--    The new Comment object.
		require
			data_exists: data /= Void
		deferred
		ensure
			result_exists: Result /= Void
			comment_set: Result.node_value.is_equal (data)
			proper_result_owner: Result.owner_document = Current
		end

	create_cdata_section (data: DOM_STRING): DOM_CDATA_SECTION
			-- Creates a CDATASection node whose value is the specified string.
			-- Parameters
			--    data   The data for the CDATASection [p.43] contents.
			-- Return Value
			--    The new CDATASection [p.43] object.
		require
			data_exists: data /= Void
			-- TODO: check not HTML document. Avoid Not_supported_err exception.
		deferred
		ensure
			result_exists: Result /= Void
			cdata_set: Result.node_value.is_equal (data)
			proper_result_owner: Result.owner_document = Current
		end

	create_processing_instruction (target: DOM_STRING; data: DOM_STRING):
		DOM_PROCESSING_INSTRUCTION
			-- Creates a ProcessingInstruction node given the specified name
			-- and data strings.
			-- Parameters
			--    target   The target part of the processing instruction.
			--    data     The data for the node.
			-- Return Value
			--    The new ProcessingInstruction [p.46] object.
		require
			target_exists: target /= Void
			data_exists: data /= Void
			valid_target: valid_target_chars (target)
		deferred
		ensure
			result_exists: Result /= Void
			target_set: Result.target.is_equal (target)
			proper_result_owner: Result.owner_document = Current
		end

	create_attribute (name: DOM_STRING): DOM_ATTR
			-- Creates an Attr of the given name. Note that the Attr instance
			-- can then be set on an Element using the setAttribute method.
			-- Parameters
			--    name   The name of the attribute.
			-- Return Value
			--    A new Attr object.
		require
			name_exists: name /= Void
			valid_name: valid_name_chars (name)
		deferred
		ensure
			result_exists: Result /= Void
			name_set: Result.node_name.is_equal (name)
			no_namespace_set: Result.local_name = Void and Result.ns_prefix = Void
				and Result.namespace_uri = Void
			-- empty_valid: Result.value.is_equal (create {DOM_STRING}.make_from_string ("")) 
			proper_result_owner: Result.owner_document = Current
		end

	create_entity_reference (name: DOM_STRING): DOM_ENTITY_REFERENCE
			-- Creates an EntityReference object.
			-- Parameters
			--    name   The name of the entity to reference.
			-- Return Value
			--    The new EntityReference object.
		require
			name_exists: name /= Void
			valid_name: valid_entity_name (name)
			-- TODO: not HTML document
		deferred
		ensure
			result_exists: Result /= Void
			-- name_set: Result.name = name
			-- TODO: if entity exists then result has same child list
			proper_result_owner: Result.owner_document = Current
		end

	get_elements_by_tag_name (tagname: DOM_STRING): DOM_NODE_LIST
			-- Returns a NodeList of all the Elements with a given tag name
			-- in the order in which they would be encountered in a preorder
			-- traversal of the Document tree.
			-- Parameters
			--    tagname   The name of the tag to match on.
			--              The special value "*" matches all tags.
			-- Return Value
			--    A new NodeList object containing all the matched Elements.
			-- This method raises no exceptions.
		require
			tagname_exists: tagname /= Void
		deferred
		ensure
			result_exists: Result /= Void
			-- for_all Result.elements element.tagname.is_equal (tagname)
		end

	import_node (imported_node: DOM_NODE; deep: BOOLEAN): DOM_NODE
			-- Imports a node from another document to this document. The returned
			-- has no parent; ('parent_node is Void). The source node is not altered
			-- or removed from the original doeumtnt; this method creates a new copy
			-- of the source node.
			-- For all nodes, importing a node creates a node object owned by the 
			-- importing document, with attribute values identical to the source node's
			-- 'node_name' and 'node_type', plus the attributes related to namespaces
			-- ('prefix', 'local_name', and 'namespace_uri'). As in the 'clone_node'
			-- operation on a DOM_NODE, the source node is not altered.
		require
			imported_node_exists: imported_node /= Void
			not_not_supported_err: import_supported (imported_node)
		deferred
		ensure
			result_exists: Result /= Void
			no_parent: Result.parent_node = Void
			node_imported: Current.has_node (Result)
			shallow_equal: not deep implies imported_node.is_equal (Result)
			deep_equal: deep implies deep_equal (imported_node, Result)
		end

	create_element_ns (new_namespace_uri, qualified_name: DOM_STRING): DOM_ELEMENT
			-- Creates an element of the given qualified name and namespace URI.
			-- DOM Level 2.
		require
			qualified_name_exists: qualified_name /= Void
			not_invalid_character_err: valid_qualified_name_chars (qualified_name)
			not_namespace_err: valid_qualified_name (new_namespace_uri, qualified_name)
		deferred
		ensure
			result_exists: Result /= Void
			node_name_set: Result.node_name.is_equal (qualified_name)
			namespace_uri_set: Result.namespace_uri.is_equal (new_namespace_uri)
			tag_name_set: Result.tag_name.is_equal (qualified_name)
			-- TODO: prefix and localname set.
		end

	create_attribute_ns (new_namespace_uri, qualified_name: DOM_STRING): DOM_ATTR
			-- Creates an attribute of the given qualified name and namespace URI.
			-- DOM Level 2.
		require
			qualified_name_exists: qualified_name /= Void
			not_invalid_character_err: valid_qualified_name_chars (qualified_name)
			not_namespace_err: valid_qualified_name (new_namespace_uri, qualified_name)
		deferred
		ensure
			result_exists: Result /= Void
			node_name_set: Result.node_name.is_equal (qualified_name)
			namespace_uri_set: Result.namespace_uri.is_equal (new_namespace_uri)
			-- TODO: prefix and localname set.
		end

	get_elements_by_tag_name_ns (a_namespace_uri, localname: DOM_STRING): DOM_NODE_LIST
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
		require
			namespace_uri_exists: a_namespace_uri /= Void
			localname_exists: localname /= Void
		deferred
		ensure
			result_exists: Result /= Void
		end
	
	get_element_by_id (element_id: DOM_STRING): DOM_ELEMENT
			-- Returns the element whose ID is given by 'element_id'. If no such
			-- element exists, returns Void. Behaviour is not defined if more than
			-- one element has this ID.
			-- Parameters
			--     element_id The unique id value for an element
			-- Return Value
			--     The matchine element.
			-- This method raises no exceptions.
		require
			element_id_exists: element_id /= Void
		deferred
		end
		
feature -- Validation Utility

	valid_name_chars (new_name: DOM_STRING): BOOLEAN
			-- Does 'new_name' consist of valid characters for a document name?
		require
			new_name_exists: new_name /= Void
		deferred
		end

	valid_qualified_name_chars (new_name: DOM_STRING): BOOLEAN
			-- Does 'new_name' consist of valid characters for a qualified name?
		require
			new_name_exists: new_name /= Void
		deferred
		end

	valid_qualified_name (new_namespace_uri, new_name: DOM_STRING): BOOLEAN
			-- Is 'new_name' a valid name within 'new_namespace_uri'?
		require
			new_name_exists: new_name /= Void
		deferred
		end

	valid_entity_name (new_name: DOM_STRING): BOOLEAN
			-- Is 'new_name' a valid name for an entity?
		require
			new_name_exists: new_name /= Void
		deferred
		end

	valid_target_chars (new_target: DOM_STRING): BOOLEAN
			-- Does 'new_target' consist of valid target characters?
		require
			new_target_exists: new_target /= Void
		deferred
		end

	valid_node_name (new_name: DOM_STRING): BOOLEAN
			-- Is 'new_name' a valid name for a node?
		require
			new_name_exists: new_name /= Void
		deferred
		end

	import_supported (new_node: DOM_NODE): BOOLEAN
			-- Can 'new_node' be imported into this document?
		require
			new_node_exists: new_node /= Void
		deferred
		end
		
invariant

	no_owner_document: owner_document = Void

end -- class DOM_DOCUMENT
