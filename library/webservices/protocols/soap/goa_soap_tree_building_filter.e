indexing
	description: "Filters that build a SOAP tree."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Colin Adams <colin@colina.demon.co.uk>"
	copyright: "Copyright (c) 2005 Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class	GOA_SOAP_TREE_BUILDING_FILTER

inherit

	XM_CALLBACKS_TO_TREE_FILTER
		redefine
			on_start_tag, on_processing_instruction, on_xml_declaration,
			on_end_tag, on_comment, on_error, on_attribute, on_content
		end

	XM_DTD_CALLBACKS_NULL
		redefine
			on_doctype
		end

	GOA_SOAP_NODE_FACTORY

	KL_IMPORTED_STRING_ROUTINES

create

	make_null,
	set_next

feature -- Status report

	is_parse_error: BOOLEAN
			-- Did a parse error occur?

	last_parse_error: STRING
			-- Last error from parser

	dtd_seen: BOOLEAN
			-- Was DTD seen? (`True' is an error)

	pi_seen: BOOLEAN
			-- Were any processing instructions seen? (`True' is an error)

	invalid_standalone: BOOLEAN
			-- Was a standalone value other than "yes" seen? (`True' is an error)

	no_envelope: BOOLEAN
			-- Was env:Envelope missing? (`True' is an error)

	is_within_document_element: BOOLEAN
			-- Are we within the document_element?

	invalid_comment: BOOLEAN
			-- Was a comment seen outside of document element? (`True' is an error)

	is_error: BOOLEAN is
			-- Were any errors detected?
		do
			Result := is_parse_error
				or else dtd_seen
				or else pi_seen
				or else invalid_standalone
				or else no_envelope
				or else invalid_comment
		end

feature -- Document type definuition callbacks

	on_doctype (a_name: STRING; an_id: XM_DTD_EXTERNAL_ID; has_internal_subset: BOOLEAN) is
			-- Document type declaration.
		do
			dtd_seen := True
		end

feature -- Errors

	on_error (a_message: STRING) is
			-- Event producer detected an error.
		do
			is_parse_error := True
			last_parse_error := a_message
			if not is_parse_error then Precursor (a_message) end
		end

feature -- Document

	on_xml_declaration (a_version: STRING; an_encoding: STRING; a_standalone: BOOLEAN) is
			-- XML declaration.
		do
			if not a_standalone then
				invalid_standalone := True
			end
		end

feature -- Meta

	on_processing_instruction (target, data: STRING) is
			-- Processing instruction.
		do
			pi_seen := True
		end

	on_comment (a_content: STRING) is
			-- Processing a comment.
		do
			if not is_within_document_element then
				invalid_comment := True
			else
				Precursor (a_content)
			end
		end

feature -- Elements

	on_start_tag (namespace, ns_prefix, a_name: STRING) is
			-- called whenever the parser findes a start element.
		local
			an_element: XM_ELEMENT
		do
			if not is_error then
				check
					document_not_void: document /= Void
				end
				
				if current_element = Void then
					-- This is the first element in the document.
					
					is_within_document_element := True
					if STRING_.same_string (namespace, Ns_name_env) and then
						STRING_.same_string (a_name, Envelope_element_name) then
						an_element := new_document_element (document, ns_prefix)
					else
						on_error (Wrong_envelope_error)
						no_envelope := True
					end
				else
					-- This is not the first element in the parent.
					check
						document_not_finished: current_element /= Void
					end
					an_element := new_element (current_element, a_name, namespace, ns_prefix, is_header_block, is_body_block)
					if header_depth > 0 then
						header_depth := header_depth + 1
					elseif body_depth > 0 then
						body_depth := body_depth + 1
					elseif STRING_.same_string (namespace, Ns_name_env) then
						if STRING_.same_string (a_name, Header_element_name) then
							header_depth := 1
						elseif STRING_.same_string (a_name, Body_element_name) then
							body_depth := 1
						end
					end
				end
				check
					element_not_void: not no_envelope implies an_element /= Void
				end
				if not no_envelope then
					current_element := an_element
					handle_position (current_element)
				end
			end
		end

	on_end_tag (a_namespace: STRING; a_prefix: STRING; a_local_part: STRING) is
			-- End tag.
		do
			if not is_error then
				Precursor (a_namespace, a_prefix, a_local_part)
				if STRING_.same_string (a_namespace, Ns_name_env) and then
					STRING_.same_string (a_local_part, Envelope_element_name) then
					is_within_document_element := False
				elseif header_depth > 0 then
					header_depth := header_depth - 1
				elseif body_depth > 0 then
					body_depth := body_depth - 1
				end
			end
		end

	on_attribute (namespace, a_prefix, a_name: STRING; a_value: STRING) is
			-- Add attribute.
		do
			if not is_error then
				Precursor (namespace, a_prefix, a_name, a_value)
			end
		end

	on_content (a_data: STRING) is
			-- Character data
		do
			if not is_error then
				Precursor (a_data)
			end
		end
	
feature -- Implementation

	is_header_block: BOOLEAN is
			-- Are we building an immediate child of env:Header?
		do
			Result := header_depth = 1
		end
	
	is_body_block: BOOLEAN is
			-- Are we building an immediate child of env:Body?
		do
			Result := body_depth = 1
		end

	header_depth, body_depth: INTEGER
			-- Nesting depths for env:Header and env:Body elements

invariant

	parse_error: is_parse_error implies last_parse_error /= Void
	not_header_and_body: not (is_header_block and is_body_block)

end -- class GOA_SOAP_TREE_BUILDING_FILTER
