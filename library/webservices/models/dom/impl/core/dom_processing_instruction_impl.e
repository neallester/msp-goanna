indexing
	description: "Processing instruction implementation"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Document Object Model (DOM) Core Implementation"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class DOM_PROCESSING_INSTRUCTION_IMPL

inherit

	DOM_PROCESSING_INSTRUCTION

	DOM_CHARACTER_DATA_IMPL
		rename
			make as cdata_make
		redefine
			node_value
		end

creation

	make

feature -- Factory creation

	make (owner_doc: DOM_DOCUMENT; new_target, new_data: DOM_STRING) is
			-- Create a new processing instruction node
		require
			owner_doc_exists: owner_doc /= Void
			target_exists: new_target /= Void
			data_exists: new_data /= Void
		do
			cdata_make (owner_doc, new_data)
			target := new_target
		end

feature

	target: DOM_STRING
			-- The target of this processing instruction. XML defines this as being
			-- the first token following the markup that begins the processing 
			-- instruction.
	
feature -- from DOM_NODE

	node_type: INTEGER is
		once
			Result := Processing_instruction_node
		end
	
	node_name: DOM_STRING is
		do
			Result := target
		end

	node_value: DOM_STRING is
		do
			Result := data
		end

end -- class DOM_PROCESSING_INSTRUCTION_IMPL
