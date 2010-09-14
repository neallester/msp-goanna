note
	description: "Implementation implementation"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Document Object Model (DOM) Core Implementation"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class DOM_IMPLEMENTATION_IMPL

inherit

	DOM_IMPLEMENTATION

feature

	create_document (namespace_uri, qualified_name: DOM_STRING; 
		doctype: DOM_DOCUMENT_TYPE): DOM_DOCUMENT
			-- Creates an XML DOCUMENT object of the specified type with
			-- its document element. 
			-- Introduced in DOM Level 2.
			-- Parameters:
			--	`namespace_uri' - The namespace URI of the document element to create.
			--	`qualified_name' - The qualified name of the document element to be created.
			--	`doctype' - The type of document to be created or Void. 
		local
			document_element: DOM_ELEMENT
			discard: DOM_NODE
		do 
			create {DOM_DOCUMENT_IMPL} Result.make (doctype)
			document_element := Result.create_element_ns (namespace_uri, qualified_name)
			discard := Result.append_child (document_element)
		end

	create_empty_document: DOM_DOCUMENT
			-- Creates an empty XML DOCUMENT object of the specified type.
			-- Non DOM.
			-- Parameters:
		do 
			create {DOM_DOCUMENT_IMPL} Result.make (Void)
		end

	create_document_type (qualified_name, public_id, system_id: DOM_STRING): DOM_DOCUMENT_TYPE
			-- Creates an empty DOM_DOCUMENT_TYPE node. Entity declarations 
			-- and notations are not made available. Entity reference expansions
			-- and default attribute additions do not occur. 
			-- Introduced in DOM Level 2.
			-- Parameters:
			--	`qualified_name' - The qualified name of the document type to be created.
			--	`publid_id' - The external subset public identifier.
			--	`system_id' - The external subset system identifier.
		do 	
			create {DOM_DOCUMENT_TYPE_IMPL} Result.make (Void, qualified_name, public_id, system_id)
		end

	has_feature (feature_name: DOM_STRING; version: DOM_STRING) : BOOLEAN
			-- Test if the DOM implementation implements a specific feature.
			-- Parameters
			--  'feature_name' - The package name of the feature to test.
			--    In Level 1, the legal values are "HTML" and "XML" (case-insensitive).
			--  'version'  - This is the version number of the package name
			--    to test. In Level 1, this is the string "1.0".
			--    In Level 2, this is the string "2.0".
			--    If the version is not specified, supporting any
			--    version of the feature will cause the method to
			--    return True.
			-- Return Value
			--    True if the feature is implemented in the specified version,
			--    False otherwise.
		do
		end

end -- class DOM_IMPLEMENTATION_IMPL
