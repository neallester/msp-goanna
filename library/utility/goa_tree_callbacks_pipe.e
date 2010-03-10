indexing
	description: "Objects that build XML documents"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Colin Adams <colin@colina.demon.co.uk>"
	copyright: "Copyright (c) 2005 Colin Adams"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_TREE_CALLBACKS_PIPE
	
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
			a_dummy: XM_CALLBACKS
		do
			start := new_namespace_resolver
			error := new_stop_on_error
			content := new_content_concatenator
			whitespace := new_whitespace_normalizer
			create tree.make_null
			last := tree
				-- Dummy because we already store 'start' in
				-- a variable of a descendant type
			a_dummy := callbacks_pipe (<<
				start,
				whitespace,
				content,
				error,
				tree >>)
		end
		
feature -- Filters (part of the pipe)

	start: XM_CALLBACKS_FILTER
			-- Starting point for XM_CALLBACKS_SOURCE (e.g. parser)

	whitespace: XM_WHITESPACE_NORMALIZER
			-- Normalize white space

	content: XM_CONTENT_CONCATENATOR
			-- Content concatenator

	error: XM_STOP_ON_ERROR_FILTER
			-- Error collector

	tree: XM_CALLBACKS_TO_TREE_FILTER
			-- Tree construction

	last: XM_CALLBACKS_FILTER
			-- Last element in the pipe, to which further filters can be added

feature -- Shortcuts

	document: XM_DOCUMENT is
			-- Document (from tree building filter)
		require
			not_error: not error.has_error
		do
			Result := tree.document
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

	tree_not_void: tree /= Void
	whitespace_not_void: whitespace /= Void
	content_not_void: content /= Void
	error_not_void: error /= Void

end -- class GOA_TREE_CALLBACKS_PIPE
