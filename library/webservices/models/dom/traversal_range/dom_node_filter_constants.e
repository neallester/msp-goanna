note
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

	Filter_accept: INTEGER = 1
	Filter_reject: INTEGER = 2
	Filter_skip: INTEGER = 3
	
	Show_all: INTEGER = 65535
	Show_element: INTEGER = 1
	Show_attribute: INTEGER = 2
	Show_text: INTEGER = 4
	Show_cdata_section: INTEGER = 8
	Show_entity_reference: INTEGER = 16
	Show_entity: INTEGER = 32
	Show_processing_instruction: INTEGER = 64
	Show_comment: INTEGER = 128
	Show_document: INTEGER = 256
	Show_document_type: INTEGER = 512
	Show_document_fragment: INTEGER = 1024
	Show_notation: INTEGER = 2048

end -- class DOM_NODE_FILTER_CONSTANTS
