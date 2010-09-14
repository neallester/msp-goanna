note
	description: "Node types"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "Document Object Model (DOM) Core"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."
	
class DOM_NODE_TYPE

feature -- Constants

	Element_node: INTEGER = 1
         -- The node is an Element

	Attribute_node: INTEGER = 2
         -- The node is an Attr

	Text_node: INTEGER = 3
         -- The node is a Text

	Cdata_section_node: INTEGER = 4
         -- The node is a CDATASection

	Entity_reference_node: INTEGER = 5
         -- The node is an EntityReference

	Entity_node: INTEGER = 6
         -- The node is an Entity

	Processing_instruction_node: INTEGER = 7
         -- The node is a ProcessingInstruction

	Comment_node: INTEGER = 8
         -- The node is a Comment

	Document_node: INTEGER = 9
         -- The node is a Document

	Document_type_node: INTEGER = 10
         -- The node is a DocumentType

	Document_fragment_node: INTEGER = 11
         -- The node is a DocumentFragment

	Notation_node: INTEGER = 12
         -- The node is a Notation
	
end -- class DOM_NODE_TYPE
