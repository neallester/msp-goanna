indexing
	description:	"A DOM tree based XML parser"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "XML Parser"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	DOM_TREE_BUILDER

inherit
   
   XM_EVENT_PARSER
   		export
   			{NONE} make_from_implementation
		redefine
			on_attribute_declaration,
			on_element_declaration,
			on_end_cdata_section,
			on_end_doctype,
			on_entity_declaration,
			on_not_standalone,
			on_notation_declaration,
			on_start_cdata_section,
			on_start_doctype,
			on_xml_declaration,
			on_start_tag,
			on_content,
			on_end_tag,
			on_processing_instruction,
			on_comment
		end
	
	UT_STRING_FORMATTER
		export
			{NONE} all
		end
	
creation {DOM_TREE_BUILDER_FACTORY}
   
	make
      
feature {NONE} -- Initialisation

	make (impl: like implementation) is
			do
				make_from_implementation (impl)
				create {DOM_IMPLEMENTATION_IMPL} dom_impl
				document := dom_impl.create_empty_document
				create nodes.make_default
			end

feature {ANY} -- Access
   
	document: DOM_DOCUMENT
	
	document_type: DOM_DOCUMENT_TYPE
         
feature {NONE} -- Parser call backs

	on_start_tag (name, ns_prefix: UC_STRING; 
		attributes: DS_BILINEAR [DS_PAIR [DS_PAIR [UC_STRING, UC_STRING], UC_STRING]]) is
			-- called whenever the parser findes a start element
		local
			discard: DOM_NODE
			qname: DOM_STRING
			dom_ns_prefix: DOM_STRING
			new_element: DOM_ELEMENT
			cursor: DS_BILINEAR_CURSOR [DS_PAIR [DS_PAIR [UC_STRING, UC_STRING], UC_STRING]]
			pair: DS_PAIR [DS_PAIR [UC_STRING, UC_STRING], UC_STRING]
			node_holder: DOM_TREE_NODE
			new_attribute: DOM_ATTR_IMPL
			new_attributes: DS_LINKED_LIST [DOM_ATTR]
		do
			debug ("parser_events")
				print ("on_start_tag:%R%N%Tname=" + quoted_eiffel_string_out (name.out) 
					+ " ns_prefix=" + quoted_eiffel_string_out (ns_prefix.out))
				print ("%R%N")
				if not attributes.is_empty then
					print ("%Tattributes:%R%N")
					from attributes.start
					until attributes.off
					loop
						pair := attributes.item_for_iteration
						print ("%T%Tname=" + quoted_eiffel_string_out (pair.first.first.out))
						print (" prefix=" + quoted_eiffel_string_out (pair.first.second.out))
						print (" value=" + quoted_eiffel_string_out (pair.second.out))
						print ("%R%N")
						attributes.forth
					end
				end
			end	
			-- build attributes collection
			-- attributes are stored with DS_PAIR [DS_PAIR [name, prefix], value]]
			from
				cursor := attributes.new_cursor
				cursor.start
				create new_attributes.make
			until
				cursor.off
			loop
				pair := cursor.item
				qname := build_qualified_name (pair.first.second, pair.first.first)
				create new_attribute.make_with_namespace (document, nodes.find_namespace_for_attribute (qname, attributes), qname)
				new_attribute.set_value (create {DOM_STRING}.make_from_ucstring (pair.second))
				new_attributes.force_last (new_attribute)
				cursor.forth
			end
			-- build a node holder and extract namespace attributes
			create node_holder.make_with_attributes (new_attributes)
			-- build the element
			qname := build_qualified_name (ns_prefix, name)
			create dom_ns_prefix.make_from_ucstring (ns_prefix)
			new_element := document.create_element_ns (nodes.find_namespace_uri (dom_ns_prefix, node_holder), qname)
			-- set new node as root document element if not already set.
			if document_element = Void then
				document_element := new_element
				node_holder.set_node (document.append_child (document_element))
			else
				node_holder.set_node (nodes.item_node_as_element.append_child (new_element))
			end
			-- add the attributes
			from
				new_attributes.start
			until
				new_attributes.off
			loop
				discard := new_element.set_attribute_node_ns (new_attributes.item_for_iteration)
				new_attributes.forth
			end
			nodes.force (node_holder)
		end

	on_content (chr_data: UC_STRING) is
			-- called whenever the parser finds character data
		local
			discard: DOM_NODE
		do
			debug ("parser_events")
				print ("on_content:%R%N%Tchr_data=" + quoted_eiffel_string_out (chr_data.out))
				print ("%R%N")
			end
			-- normalize the character data if we are not in a CDATA section
			-- if there is anything left then add it to the current composite.
			if not in_cdata_section then
				normalize (chr_data)
			end
			if not chr_data.empty then
				discard := nodes.item_node_as_element.append_child (document.create_text_node (create {DOM_STRING}.make_from_ucstring (chr_data)))
			end
		end

	on_end_tag (name, ns_prefix: UC_STRING) is
			-- called whenever the parser findes an end element
		do
			debug ("parser_events")
				print ("on_end_tag:%R%N%Tname=" + quoted_eiffel_string_out (name.out) + " ns_prefix=" 
					+ quoted_eiffel_string_out (ns_prefix.out))
				print ("%R%N")
			end
			-- if the current node is Void then the parent node has ended
			nodes.remove
		end
   
	on_processing_instruction (target, data: UC_STRING) is
			-- called whenever the parser findes a processing instruction.
		local
			new_element, discard: DOM_NODE
		do
			debug ("parser_events")
				print ("on_processing_instruction:%R%N%Ttarget=" + quoted_eiffel_string_out (target.out) + " data=" 
					+ quoted_eiffel_string_out (data.out))
				print ("%R%N")
			end
			new_element := document.create_processing_instruction (create {DOM_STRING}.make_from_ucstring (target), 
				create {DOM_STRING}.make_from_ucstring (data))
			discard := document.append_child (new_element)
		end
   
	on_comment (com: UC_STRING) is
			-- called whenever the parser finds a comment.
		local
			new_element, discard: DOM_NODE
		do
			debug ("parser_events")
				print ("on_comment:%R%N%Tcom=" + quoted_eiffel_string_out (com.out))
				print ("%R%N")
			end
			new_element := document.create_comment (create {DOM_STRING}.make_from_ucstring (com))
			discard := nodes.item_node_as_element.append_child (new_element)
		end

	on_element_declaration (name: UC_STRING) is
		do
			debug ("parser_events")
				print ("on_element_declaration:%R%N%Tname=" + quoted_eiffel_string_out (name.out))
				print ("%R%N")
			end
		end
		
	on_attribute_declaration (element_name, attribute_name, 
			attribute_type, default_value: UC_STRING; is_required: BOOLEAN) is
		do
			debug ("parser_events")
				print ("on_attribute_declaration:%R%N%Telement_name=" + quoted_eiffel_string_out (element_name.out))
				print (" attribute_name=" + quoted_eiffel_string_out (attribute_name.out) + " attribute_type=" + quoted_eiffel_string_out (attribute_type.out))
				print (" default_value=" + quoted_eiffel_string_out (default_value.out) + " is_required=" + is_required.out)
				print ("%R%N")
			end
		end

	on_xml_declaration (xml_version, encoding: UC_STRING; is_standalone: BOOLEAN) is
		do
			debug ("parser_events")
				print ("on_xml_declaration:R%N%Txml_version=" + quoted_eiffel_string_out (xml_version.out))
				if encoding /= Void then
					print (" encoding=" + quoted_eiffel_string_out (encoding.out))	
				end
				
				print (" is_standalone=" + is_standalone.out)
				print ("%R%N")
			end
		end

	on_entity_declaration (entity_name: UC_STRING; is_parameter_entity: BOOLEAN; 
			value: UC_STRING; value_length: INTEGER; base, system_id, public_id, notation_name: UC_STRING) is
		do
			debug ("parser_events")
				print ("on_entity_declaration:%R%N%Tentity_name=" + quoted_eiffel_string_out (entity_name.out))
				print (" is_parameter_entity=" + is_parameter_entity.out + " value=" + quoted_eiffel_string_out (value.out))
				print (" value_length=" + value_length.out + " base=" + quoted_eiffel_string_out (base.out) 	
					+ " public_id=" + quoted_eiffel_string_out (public_id.out))
				print (" notation_name=" + quoted_eiffel_string_out (notation_name.out))
				print ("%R%N")
			end
		end
		
	on_start_cdata_section is
		do
			debug ("parser_events")
				print ("on_start_cdata_section")
				print ("%R%N")
			end
			in_cdata_section := True
		end

	on_end_cdata_section is
		do
			debug ("parser_events")
				print ("on_end_cdata_section")
				print ("%R%N")
			end
			in_cdata_section := False
		end

	on_start_doctype (name, system_id, public_id: UC_STRING; has_internal_subset: BOOLEAN) is
			-- This is called for the start of the DOCTYPE declaration, before
			-- any DTD or internal subset is parsed.
		local
			uc_public_id, uc_system_id: DOM_STRING
		do
			debug ("parser_events")
				print ("on_start_doctype:%R%N%Tname=" + quoted_eiffel_string_out (name.out))
				if system_id /= Void then
					print (" system_id=" + quoted_eiffel_string_out (system_id.out))
				end 
				if public_id /= Void then
					print (" public_id=" + quoted_eiffel_string_out (public_id.out))
				end
				print (" has_internal_subset=" + has_internal_subset.out)
				print ("%R%N")
			end
			-- create new document type
			if system_id /= Void then
				create uc_system_id.make_from_ucstring (system_id)
			else
				create uc_system_id.make_from_string ("")
			end
			if public_id /= Void then
				create uc_public_id.make_from_ucstring (public_id)
			else
				create uc_public_id.make_from_string ("")
			end
			document_type := dom_impl.create_document_type (create {DOM_STRING}.make_from_ucstring (name), 
				uc_public_id, uc_system_id)
		end

	on_end_doctype is
			-- This is called for the start of the DOCTYPE declaration when the
			-- closing > is encountered, but after processing any external subset.
		local
			discard: DOM_NODE
		do
			debug ("parser_events")
				print ("on_end_doctype")
				print ("%R%N")
			end
			-- store the doctype
			document_type.set_owner_document (document)
			discard := document.append_child (document_type)
		end

	on_notation_declaration (notation_name, base, system_id, public_id: UC_STRING) is
		do
			debug ("parser_events")
				print ("on_notation_declaration:%R%N%Tnotation_name=" + quoted_eiffel_string_out (notation_name.out))
				print (" base=" + quoted_eiffel_string_out (base.out) + " system_id=" + quoted_eiffel_string_out (system_id.out)
					+ " public_id=" + quoted_eiffel_string_out (public_id.out))
				print ("%R%N")
			end
		end

	on_not_standalone: BOOLEAN is
		do
			debug ("parser_events")
				print ("on_not_standalone")
				print ("%R%N")
			end
		end
		
feature {NONE} -- Implementation

	nodes: DOM_NODE_STACK
			-- Stack of nodes currently being processed
	
	in_cdata_section: BOOLEAN
	
	current_namespace_prefix: DOM_STRING
	
	current_namespace_uri: DOM_STRING
	
	document_element: DOM_ELEMENT
	
	dom_impl: DOM_IMPLEMENTATION

	normalize (str: UC_STRING) is
			-- Remove leading and trailing whitespace from 'str'
			-- Modifies 'str' parameter
		require
			str_exists: str /= Void
		do
			str.left_adjust
			str.right_adjust
		ensure
			normalized_exists: str /= Void
		end
		
	build_qualified_name (ns_prefix, name: UC_STRING): DOM_STRING is
			-- Build a fully qualified name from ns_prefix and name.
			-- Include the prefix and colon separator if the prefix  
			-- is not empty
		require
			ns_prefix_exists: ns_prefix /= Void
			name_exists: name /= Void
		do
			create Result.make_from_ucstring (ns_prefix)
			if not Result.is_empty then
				Result.append_string (":")
			end
			Result.append_uc_string (name)
		end
		
end -- class DOM_TREE_BUILDER
