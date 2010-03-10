indexing
	description: "Objects that can serializer XML documents"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "DOM Serialization"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	DOM_XML_SERIALIZER

inherit
	DOM_SERIALIZER
		redefine
			make
		end
	
	DOM_NODE_TYPE
		export
			{NONE} all
		end
	
creation
	make

feature -- Initialization

	make is
			-- Create a new XML DOM serializer using the default format.
		do
			Precursor
			character_entity_reference := text_character_entity_reference
		end

feature -- Serialization

	serialize (node: DOM_NODE) is
			-- Serialize 'node' to specified output medium
		do
			serialize_node_recurse (node, 0)
		end
		
feature {NONE} -- Implementation

	serialize_node_recurse (node: DOM_NODE; indent_level: INTEGER) is
			-- Serialize 'node' to specified output medium
		do
			-- check node type and serialize accordingly
			inspect
				node.node_type
			when Element_node then 
				serialize_element_recurse (node, indent_level)
			when Attribute_node then 
				serialize_attribute (node)
			when Text_node then 
				serialize_text (node)
			when Cdata_section_node then 
				serialize_cdata_section (node)
			when Entity_reference_node then 
				serialize_entity_reference (node)
			-- TODO: when Entity_node then serialize_entity (node)
			when Processing_instruction_node then 
				serialize_processing_instruction (node)
			when Comment_node then 
				serialize_comment (node)
			when Document_node then 
				serialize_document (node)
			when Document_type_node then 
				serialize_document_type (node)
			-- TODO: when Document_fragment_node then serialize_document_fragment (node)
			when Notation_node then 
				serialize_notation (node)
			else
				debug ("unhandled_node_types")
					print ("Unhandled node type: " + node.generator + " name: " + node.node_name.out)
					print ("%R%N")
				end
				-- TODO: handle other types
			end		
		end

feature {NONE} -- Node-specific serialization
				
	serialize_element_recurse (element: DOM_NODE; indent_level: INTEGER) is
			-- Serialize 'element' to specified output medium
		require
			valid_node_type: element.node_type = Element_node
		local
			i: INTEGER
			attrs: DOM_NAMED_MAP [DOM_ATTR]
			attr: DOM_ATTR
			child_nodes : DOM_NODE_LIST
			use_indentation: BOOLEAN
			child_nodes_length: INTEGER
			is_empty_minimized: BOOLEAN
			is_space_preserved: BOOLEAN
		do			
			-- TODO: declare 'is_empty_minimized' as attribute
			--       and add required setters
			is_empty_minimized := True
			-- TODO: declare 'is_space_preserved' as attribute
			--       and add required setters
			is_space_preserved := False
			-- output this element, its attributes, and recursively, all of its children
			output.put_string ("<")
			output.put_string (element.node_name.out)
			-- attributes
			from
				attrs := element.attributes
				i := 0
			until
				i >= attrs.length
			loop
				attr := attrs.item (i)
				-- print the attribute if it was specified
				if attr.specified then
					output.put_character (' ')
					serialize_attribute (attr)
				end
				i := i + 1
			end	
			-- children
			if element.has_child_nodes or else not is_empty_minimized then
				-- close start tag
				output.put_character ('>')
				child_nodes := element.child_nodes
				child_nodes_length := child_nodes.length
				if not is_space_preserved then
					use_indentation := True
					-- Let's check whether the element
					-- has text nodes and is not empty
					from
						i := 0
					until
						i >= child_nodes_length
					loop
						if child_nodes.item (i).node_type = Text_node then
							use_indentation := False
							i := child_nodes.length
						end
						i := i + 1
					end	
				end
				from
					i := 0
				until
					i >= child_nodes_length
				loop
					if use_indentation then
						serialize_new_line
						serialize_indent (indent_level + indent_amount)
					end
					serialize_node_recurse (child_nodes.item (i), indent_level + indent_amount)
					i := i + 1
				end
				if use_indentation then
					serialize_new_line
					serialize_indent (indent_level)
				end
				-- close tag
				output.put_string ("</")
				output.put_string (element.node_name.out)
			else
				-- empty tag
				output.put_character ('/')
			end			
			output.put_character ('>')
		end

	serialize_attribute (attribute: DOM_NODE) is
			-- Serialize 'attribute' to specified output medium
		require
			valid_node_type: attribute.node_type = Attribute_node
		local
			attr_value: DOM_STRING
		do
			output.put_string (attribute.node_name.out)
			output.put_character ('=')
			attr_value := attribute.node_value
			if attr_value = Void then
				create attr_value.make_from_string ("")
			end
			serialize_quoted (attr_value)
			character_entity_reference := text_character_entity_reference
		end
		
	serialize_text (node: DOM_NODE) is
			-- Serialize 'node' to output stream
		require
			valid_node_type: node.node_type = Text_node
		do
			serialize_escaped (node.node_value)
		end
	
	serialize_cdata_section (node: DOM_NODE) is
			-- Serialize 'node' to output stream			
		require
			valid_node_type: node.node_type = Cdata_section_node
		do
			output.put_string ("<!CDATA[")
			output.put_string (node.node_value.out)
			output.put_string ("]]>")
		end
	
	serialize_entity_reference (node: DOM_NODE) is
			-- Serialize 'node' to output stream			
		require
			valid_node_type: node.node_type = Entity_reference_node
		do
			output.put_character ('&')
			output.put_string (node.node_name.out)
			output.put_character (';')
		end
	
	serialize_processing_instruction (node: DOM_NODE) is
			-- Serialize 'node' to output stream
		require
			valid_node_type: node.node_type = Processing_instruction_node
		do
			output.put_string ("<?")
			output.put_string (node.node_name.out)
			output.put_character (' ')
			output.put_string (node.node_value.out)
			output.put_string ("?>")
		end
	

	serialize_comment (node: DOM_NODE) is
			-- Serialize 'node' to output stream.
		require
			valid_node_type: node.node_type = Comment_node
		do
			output.put_string ("<!--")
			output.put_string (node.node_value.out)
			output.put_string ("-->")
		end
	
	serialize_document (node: DOM_NODE) is
			-- Serialize 'node' output medium.
		require
			valid_node_type: node.node_type = Document_node
		local
			doc_nodes: DOM_NODE_LIST
			index: INTEGER
			is_xml_declared: BOOLEAN
		do
			-- output document declaration
			-- TODO: declare 'is_xml_declared' as attribute
			--       and add required setters
			is_xml_declared := True
			if is_xml_declared then
				output.put_string ("<?xml version=%"1.0%" encoding=%"ISO-8859-1%" standalone=%"yes%"?>")
			end
			from
				doc_nodes := node.child_nodes
			variant
				doc_nodes.length - index
			until
				index >= doc_nodes.length
			loop
				serialize_new_line
				serialize_node_recurse (doc_nodes.item (index), 0)
				index := index + 1
			end
		end

	serialize_document_type (doctype: DOM_NODE) is
			-- Serialize 'doctype' to output stream
		require
			valid_node_type: doctype.node_type = Document_type_node
		local
			doctype_node: DOM_DOCUMENT_TYPE
			child_nodes: DOM_NODE_LIST
			i: INTEGER
		do
			doctype_node ?= doctype
			check
				doctype_exists: doctype_node /= Void
			end
			output.put_string ("<!DOCTYPE ")
			output.put_string (doctype_node.name.out)
			if doctype_node.system_id /= Void then
				output.put_string (" " + doctype_node.system_id.out)
			end
			if doctype_node.public_id /= Void then
				output.put_string (" " + doctype_node.public_id.out)
			end
			if doctype_node.has_child_nodes then
				-- serialize internal subset
				output.put_string ("[")
				serialize_new_line
				from
					child_nodes := doctype_node.child_nodes
					i := 0
				until
					i >= child_nodes.length
				loop
					serialize_node_recurse (child_nodes.item (i), indent_amount)
					i := i + 1
				end	
				-- close tag
				serialize_new_line
				output.put_string ("]>")
			else
				-- close external subset
				output.put_string (">")
			end			
		end

	serialize_notation (node: DOM_NODE) is
			-- Serialize 'node' to output stream
		require
			valid_node_type: node.node_type = Notation_node
		local
			notation: DOM_NOTATION
		do
			output.put_string ("<!NOTATION ")
			output.put_string (node.node_name.out)
			notation ?= node
			if notation /= Void then
				serialize_external_id (notation.public_id, notation.system_id)
			end
			output.put_character ('>')
		end

feature {NONE} -- Helper features

	serialize_external_id (public_id: DOM_STRING; system_id: DOM_STRING) is
			-- Serialize supplied public and system IDs if any
		do
			if public_id /= Void then
				output.put_string (" PUBLIC %"")
				output.put_string (public_id.out)
				output.put_character ('%"')
			end
			if system_id /= Void then
				if public_id = Void then
					output.put_string (" SYSTEM")
				end
				output.put_character (' ')
				serialize_quoted (system_id)
			end
		end

	serialize_quoted (value: DOM_STRING) is
			-- Serialize 'value' in qoutes with all the necessary
			-- escapement
		require
			non_void_value: value /= Void
		local
			attribute_quote: CHARACTER
		do
-- GM: Commented out for new GOBO port
--			attribute_quote := '"'
--			if value.index_of (quote_character, 1) > 0 then
--				if value.index_of (apostrophe_character, 1) > 0 then
--					character_entity_reference := quoted_character_entity_reference
--				else
--					attribute_quote := '%''
--				end
--			end
--			output.put_character (attribute_quote)
--			serialize_escaped (value)
--			output.put_character (attribute_quote)
		end
		
	serialize_indent (level: INTEGER) is
			-- Output indentation corresponding to 'level'
		local
			indent: STRING
		do
			if not is_compact_format then
				if level > 0 then
					indent := string_routines.make_buffer (level)
					indent.fill_blank
					output.put_string (indent)	
				end
			end
		end
	
	serialize_new_line is
			-- Write a new line to the output depending on format.
		do
			if not is_compact_format then
				output.put_string ("%R%N")
			end
		end
	
	serialize_escaped (str: DOM_STRING) is
			-- Write 'str' as text content or attribute value
			-- Non printable characters are escaped using
			-- character references or deault entity references
			-- specified by the format
		require
			str_exists: str /= Void
		local
			i: INTEGER
			char: UC_CHARACTER
			is_printable: BOOLEAN
			code: INTEGER
		do
			from
				i := 1
			until
				i > str.count
			loop
-- GM: commented out for new GOBO port
--				char := str.item (i)
				if character_entity_reference /= Void and then
					character_entity_reference.has (char.code)
				then
					output.put_character ('&')
					output.put_string (character_entity_reference.item (char.code))
					output.put_character (';')
				else
-- The following inspect statement causes the ISE Eiffel compiler to generate
-- C code that cannot be compiled. ie, a huge case statement. The boolean expression
-- replacement below is equivalent in functionality but not as efficient.
--					inspect char.code
--					when
--						9,               --     0x9
--						10,              --     0xA
--						13,              --     0xD
--						32 .. 55295,     --  0x0020 -   0xD7FF
--						57344 .. 65533,  --  0xE000 -   0xFFFD
--						65536 .. 1114111 -- 0x10000 - 0x10FFFF
--					then
--						is_printable := True
--					else
--						is_printable := False
--					end
					code := char.code
					is_printable := 
						code = 9
						or else code = 10
						or else code = 13
						or else (code >= 32 and then code <= 55295)
						or else (code >= 57344 and then code <= 65533)
						or else (code >= 65536 and then code <= 1114111)
					-- The character is printable if
					-- the encoding allows that
					-- The encoding should be handled here
					-- Let's default to ISO-8859-1
					if is_printable and then char.code <= 255 then
						-- TODO: use 'char.as_character' when available
						output.put_character (integer_routines.to_character (char.code))
					else
						output.put_string ("&#x")
						-- TODO: use 'char.as_hexadecimal' when available
						output.put_string (as_hexadecimal_number (char))
						output.put_character (';')
					end
				end
				i := i + 1
			end
		end

	character_entity_reference: DS_TABLE [STRING, INTEGER]
			-- The entity references for characters

	text_character_entity_reference: DS_TABLE [STRING, INTEGER] is
			-- The entity references for characters in text
			-- or attribute without quotes
		once
			create {DS_HASH_TABLE [STRING, INTEGER]} Result.make (2)
			Result.put ("amp", 38)
			Result.put ("lt",  60)
		end

	quoted_character_entity_reference: DS_TABLE [STRING, INTEGER] is
			-- The entity references for characters in quoted
			-- attribute values
		once
			create {DS_HASH_TABLE [STRING, INTEGER]} Result.make (3)
			Result.put ("quot", 34)
			Result.put ("amp",  38)
			Result.put ("lt",   60)
		end

	apostrophe_character: UC_CHARACTER is
			-- Character representing '%''
		once
-- GM: commented out for new GOBO port
--			Result.make_from_character ('%'')
		end

	quote_character: UC_CHARACTER is
			-- Character representing '"'
		once
-- GM: commented out for new GOBO port
--			Result.make_from_character ('"')
		end

	integer_routines: KL_INTEGER_ROUTINES is
			-- Special routines for INTEGER
		once
			create Result
		end

	string_routines: KL_STRING_ROUTINES is
			-- routines for STRING
		once
			create Result
		end

	as_hexadecimal_number (c: UC_CHARACTER): STRING is
			-- Hexadecimal representation of the given character
		require
			positive_code: c.code > 0
		local
			i: INTEGER
			code: INTEGER
		do
			from
				Result := string_routines.make_buffer (8)
				code := c.code
				i := Result.count
			variant
				i
			until
				i <= 0
			loop
				Result.put (hexadecimal_digits.item (code \\ 256 + 1), i)
				i := i - 1
				code := code // 256
				if code = 0 then
					-- Done
					Result.tail (Result.count - i)
					i := 0
				end
			end
		ensure
			non_void_result: Result /= Void
			non_empty_result: not Result.is_empty
		end

	hexadecimal_digits: STRING is "0123456789abcdef"
			-- 1-based hexadecimal digits

end -- class DOM_XML_SERIALIZER
