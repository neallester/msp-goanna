indexing
	description: "Constants for node filter results and types."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Document Object Model (DOM) Traversal"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	DOM_NODE_FILTER_CONSTANTS

feature -- Access

	Filter_accept: INTEGER is 1
	Filter_reject: INTEGER is 2
	Filter_skip: INTEGER is 3
	
	Show_all: INTEGER is 65535
	Show_element: INTEGER is 1
	Show_attribute: INTEGER is 2
	Show_text: INTEGER is 4
	Show_cdata_section: INTEGER is 8
	Show_entity_reference: INTEGER is 16
	Show_entity: INTEGER is 32
	Show_processing_instruction: INTEGER is 64
	Show_comment: INTEGER is 128
	Show_document: INTEGER is 256
	Show_document_type: INTEGER is 512
	Show_document_fragment: INTEGER is 1024
	Show_notation: INTEGER is 2048

end -- class DOM_NODE_FILTER_CONSTANTS
