note
	description: "Objects that represent a SOAP Upgrade header"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Colin Adams <colin@colina.demon.co.uk>"
	copyright: "Copyright (c) 2005 Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_SOAP_UPGRADE

inherit

	GOA_SOAP_HEADER_BLOCK
		redefine
			is_encoding_style_permitted, validate
		end

create

	make_last, construct


feature {NONE} -- Initialisation

	construct (a_parent: GOA_SOAP_HEADER)
			-- Establish invariant.
		require
			parent_not_void: a_parent /= Void
		local
			a_namespace: XM_NAMESPACE
			a_supported_envelope: GOA_SOAP_SUPPORTED_ENVELOPE
			a_qname: STRING
		do
			create a_namespace.make (Ns_prefix_env, Ns_name_env)
			make_last (a_parent, Upgrade_element_name, a_namespace)
			a_qname := STRING_.concat (Ns_prefix_env, Prefix_separator)
			a_qname := STRING_.appended_string (a_qname, Envelope_element_name)
			create a_supported_envelope.construct (Current, a_qname)
		end

feature -- Status report

	is_encoding_style_permitted: BOOLEAN
			-- Is `encoding_style' permitted to be non-Void?
		do
			Result := False
		end

feature -- Status setting

	
	validate (an_identity: UT_URI)
			-- Validate `Current'.
		local
			child_elements: DS_LIST [XM_ELEMENT]
			a_cursor: DS_LIST_CURSOR [XM_ELEMENT]
		do
			Precursor (an_identity); validation_complete := False
			child_elements := elements
			if child_elements.count = 0 then
				set_validation_fault (Sender_fault, "Env:Upgrade must have a env:SupportedEnvelope element child", an_identity)
			else
				from a_cursor := child_elements.new_cursor; a_cursor.start until a_cursor.after loop
					if not is_valid_element (a_cursor.item, Supported_envelope_element_name) then
						set_validation_fault (Sender_fault, "Env:Upgrade may only have env:SupportedEnvelope children", an_identity)
						a_cursor.go_after
					else
						a_cursor.forth
					end
				end
			end
			validation_complete := True			
		end
			
invariant

	correct_name: is_valid_element (Current, Upgrade_element_name)

end -- class GOA_SOAP_UPGRADE
