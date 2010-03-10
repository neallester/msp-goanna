indexing
	description: "Objects that represent a SOAP NotUnderstookd element."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Colin Adams <colin@colina.demon.co.uk>"
	copyright: "Copyright (c) 2005 Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_SOAP_NOT_UNDERSTOOD

inherit
	
	GOA_SOAP_HEADER_BLOCK
		redefine
			is_encoding_style_permitted, validate
		end

	XM_UNICODE_CHARACTERS_1_0
		undefine
			copy, is_equal
		end
	
create

	make_last, construct

feature {NONE} -- Initialisation

	construct (a_parent: GOA_SOAP_HEADER; a_header_block: GOA_SOAP_HEADER_BLOCK) is
			-- Establish invariant.
		require
			parent_exists: a_parent /= Void
			header_block_exists: a_header_block /= Void
		local
			a_namespace, an_xmlns_namespace: XM_NAMESPACE
			an_attribute: XM_ATTRIBUTE
			a_qname, a_prefix: STRING
		do
			create a_namespace.make (Ns_prefix_env, Ns_name_env)
			make_last (a_parent, Not_understood_element_name, a_namespace)
			a_namespace := a_header_block.namespace
			if a_namespace.has_prefix then
				a_prefix := STRING_.concat (a_namespace.ns_prefix, Prefix_separator)
				create an_xmlns_namespace.make (Xmlns, Xmlns_namespace)
				create an_attribute.make_last (a_namespace.ns_prefix, an_xmlns_namespace, a_namespace.uri, Current)
			else
				a_prefix := ""
				if a_namespace.uri.count > 0 then
					create an_xmlns_namespace.make ("", Xmlns_namespace)
					create an_attribute.make_last (Xmlns, an_xmlns_namespace, a_namespace.uri, Current)
				end
			end
			a_qname := STRING_.concat (a_prefix, a_header_block.name)
			create a_namespace.make_default
			create an_attribute.make_last (Qname_attr, a_namespace, a_qname, Current)
		end

feature -- Status report

	is_encoding_style_permitted: BOOLEAN is
			-- Is `encoding_style' permitted to be non-Void?
		do
			Result := False
		end

feature -- Status setting

	validate (an_identity: UT_URI) is
			-- Validate `Current'.
		do
			if elements.count > 0 then
				set_validation_fault (Sender_fault, "No element children are allowed for env:NotUnderstood", an_identity)
			elseif not has_attribute_by_name (Qname_attr) then
				set_validation_fault (Sender_fault, "Missing qname attribute from env:NotUnderstood", an_identity)
			else
				Precursor (an_identity)
			end
		end

invariant
	
	correct_name: is_valid_element (Current, Not_understood_element_name)

end -- class GOA_SOAP_NOT_UNDERSTOOD
