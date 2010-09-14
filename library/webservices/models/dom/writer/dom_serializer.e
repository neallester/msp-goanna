note
	description: "Objects that can serialize a DOM to a STRING"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "DOM Serialization"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class
	DOM_SERIALIZER

inherit

	KL_IMPORTED_OUTPUT_STREAM_ROUTINES

feature -- Initialization

	make
			-- Create a new DOM serializer using the default format.
		do
			indent_amount := Default_indent
			line_separator := Default_line_separator
		end
		
feature -- Status report

	output: like OUTPUT_STREAM_TYPE
			-- Output stream to serialize to.

	indent_amount: INTEGER
			-- Line indent amount

	line_separator: STRING
			-- Line separator

	is_compact_format: BOOLEAN
			-- Is the serializer using the compact format.
			
feature -- Status setting

	set_output (output_medium: like OUTPUT_STREAM_TYPE)
			-- Set the output stream that this serializer will write to.
		require
			output_medium_exists: output_medium /= Void			
		do
			output := output_medium
		ensure
			output_set: output = output_medium
		end
	
	set_compact_format
			-- Set compact format
		do
			is_compact_format := True
		end
	
	set_pretty_format
			-- Set pretty (indented) format
		do
			is_compact_format := False
		end
	
feature -- Serialization

	serialize (node: DOM_NODE)
			-- Serialize 'node' to specified output medium.
		require
			output_exists: output /= Void
			node_exists: node /= Void
		deferred
		end
	
	frozen serialize_node (node: DOM_NODE)
		obsolete "To be removed in the next version, use serialize"
			-- Serialize 'node' to specified output medium
		require
			output_exists: output /= Void
			node_exists: node /= Void
		do
			serialize (node)
		end
		
	frozen serialize_element (element: DOM_ELEMENT)
		obsolete "To be removed in the next version, use serialize"
			-- Serialize 'element' to specified output medium
		require
			output_exists: output /= Void
			element_exists: element /= Void
		do
			serialize (element)
		end
	
feature {NONE} -- Implementation
		
	Default_indent: INTEGER = 4
			-- Default indentation amount		
						
	Default_line_separator: STRING = "%R%N"
			-- Default line separator

invariant

	positive_indent: indent_amount >= 0
	line_separator_exists: line_separator /= Void
	
end -- class DOM_SERIALIZER
