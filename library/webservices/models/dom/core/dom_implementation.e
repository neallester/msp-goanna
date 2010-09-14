note
	description: "Implementation"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Document Object Model (DOM) Core"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class DOM_IMPLEMENTATION

feature

	create_document (namespace_uri, qualified_name: DOM_STRING; 
		doctype: DOM_DOCUMENT_TYPE): DOM_DOCUMENT
			-- Creates an XML DOCUMENT object of the specified type with
			-- its document element. 
			-- Parameters:
			--	`namespace_uri' - The namespace URI of the document element to create.
			--	`qualified_name' - The qualified name of the document element to be created.
			--	`doctype' - The type of document to be created or Void. When Void, its
			-- DOM_NODE.owner_document attribute is set to the document being created.
			-- DOM Level 2.
		require
			qualified_name_exists: qualified_name /= Void
			not_invalid_character_err: valid_qualified_name_chars (qualified_name)
			not_namespace_err: well_formed_namespace_qualified_name (namespace_uri, qualified_name)
			not_wrong_document_err: -- TODO: check for doctype created with different implementation
		deferred
		ensure
			valid_result: Result /= Void
			-- namespace_set: Result.namespace.equals (namespace_uri)
			-- qualified_name_set: Result.qualified_name.equals (qualified_name)
			doctype_owner_set: Result.doctype /= Void implies 
				Result.doctype.owner_document = Result
		end
		
	create_document_type (qualified_name, public_id, system_id: DOM_STRING): DOM_DOCUMENT_TYPE
			-- Creates an empty DOM_DOCUMENT_TYPE node. Entity declarations 
			-- and notations are not made available. Entity reference expansions
			-- and default attribute additions do not occur. 
			-- Parameters:
			--	`qualified_name' - The qualified name of the document type to be created.
			--	`publid_id' - The external subset public identifier.
			--	`system_id' - The external subset system identifier.
			-- DOM Level 2.
		require
			qualified_name_exists: qualified_name /= Void
			public_id_exists: public_id /= Void
			system_id_exists: system_id /= Void
			not_invalid_character_err: valid_qualified_name_chars (qualified_name)
			not_namespace_err: well_formed_qualified_name (qualified_name)	
		deferred
		ensure
			valid_result: Result /= Void
			owner_document_void: Result.owner_document = Void
		end
		
	has_feature (feature_name: DOM_STRING; version: DOM_STRING) : BOOLEAN
			-- Test if the DOM implementation implements a specific feature.
			-- Parameters
			--  'feature_name' - The package name of the feature to test. One of: XML,
			--    HTML, Views, StyleSheets, CSS, CSS2, Events, UIEvents, MouseEvents, 
			--    MutationEvents, HTMLEvents, Traversal, Range.
			--  'version'  - This is the version number of the package name
			--    to test. In Level 1, this is the string "1.0".
			--    In Level 2, this is the string "2.0".
			--    If the version is not specified, supporting any
			--    version of the feature will cause the method to
			--    return True.
		require
			valid_feature_name: feature_name /= Void
		deferred
		end

feature -- Non DOM Utility 

	create_empty_document: DOM_DOCUMENT
			-- Creates an XML DOCUMENT object of the specified type.
			-- Non-DOM utility
		require
			not_wrong_document_err: -- TODO: check for doctype created with different implementation
		deferred
		ensure
			valid_result: Result /= Void
			doctype_set_if_specified: Result.doctype /= Void implies 
				Result.doctype.owner_document = Result
		end

feature -- Validation Utility 

	valid_qualified_name_chars (qualified_name: DOM_STRING): BOOLEAN
			-- Does 'qualified_name' contain valid characters?
			-- Non-DOM uility
		do
			Result := True
		end

	well_formed_qualified_name (qualified_name: DOM_STRING): BOOLEAN
			-- Is 'qualified_name' well formed?
			-- Non-DOM uility
		do
			Result := True
		end

	well_formed_namespace_qualified_name (namespace_uri, qualified_name: DOM_STRING): BOOLEAN
			-- Is 'qualified_name' a well formed name within 'namespace_uri'?
			-- Check if the 'qualified_name' is malformed, if the 'qualified_name' has a prefix and
			-- the 'namespace_uri' is Void, or if the 'qualified_name' has a prefix that is "xml"
			-- and the 'namespace_uri' is different from "http://www.w3.org/XML/1998/namespace".
			-- Non-DOM uility
		do
			Result := True
		end

end -- class DOM_IMPLEMENTATION
