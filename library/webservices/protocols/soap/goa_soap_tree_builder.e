indexing
	description: "Objects that build a SOAP tree."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Colin Adams <colin@colina.demon.co.uk>"
	copyright: "Copyright (c) 2005 Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class	GOA_SOAP_TREE_BUILDER

inherit

	ANY

	XM_CALLBACKS_FILTER_FACTORY
		export {NONE} all end

creation

	make

feature {NONE} -- Initialization

	make is
			-- Create a new pipe.
		local
			a_namespace_resolver: XM_NAMESPACE_RESOLVER
		do
			namespace_resolver := new_namespace_resolver
			namespace_resolver.set_forward_xmlns (True)
			start := a_namespace_resolver
			content := new_content_concatenator
			unicode_validation := new_unicode_validation
			error := new_stop_on_error
			create tree_filter.make_null
			last := tree_filter
			dtd_target := tree_filter
			start := callbacks_pipe (<<
				namespace_resolver,
				unicode_validation,
				content,
				error,
				tree_filter>>)
		end
		
feature -- Filters (part of the pipe)

	dtd_target: XM_DTD_CALLBACKS
			-- Starting point for XM_DTD_CALLBACKS_SOURCE

	start: XM_CALLBACKS
			-- Starting point for XM_CALLBACKS_SOURCE (e.g. parser)

	namespace_resolver: XM_NAMESPACE_RESOLVER
			-- Namespace resolver

	unicode_validation: XM_UNICODE_VALIDATION_FILTER
			-- Unicode validator

	content: XM_CONTENT_CONCATENATOR
			-- Content concatenator

	error: XM_STOP_ON_ERROR_FILTER
			-- Error collector

	tree_filter: GOA_SOAP_TREE_BUILDING_FILTER
			-- Tree construction

	last: XM_CALLBACKS_FILTER
			-- Last element in the pipe, to which further filters can be added

feature -- Shortcuts

	document: XM_DOCUMENT is
			-- Document (from tree building filter)
		require
			not_error: not error.has_error
		do
			Result := tree_filter.document
		end

	last_error: STRING is
			-- Error (from error filter)
		require
			error: error.has_error
		do
			Result := error.last_error
		ensure
			last_error_not_void: Result /= Void
		end

invariant

	tree_not_void: tree_filter /= Void
	error_not_void: error /= Void

end -- class GOA_SOAP_TREE_BUILDER
