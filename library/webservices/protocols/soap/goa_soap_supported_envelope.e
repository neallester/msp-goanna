indexing
	description: "Objects that represent a SOAP SupportedEnvelope."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Colin Adams <colin@colina.demon.co.uk>"
	copyright: "Copyright (c) 2005 Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_SOAP_SUPPORTED_ENVELOPE

inherit
	
	GOA_SOAP_ELEMENT
		redefine
			validate
		end

	XM_UNICODE_CHARACTERS_1_0
		undefine
			copy, is_equal
		end
	
create

	make_last, construct

feature {NONE} -- Initialisation

	construct (a_parent: GOA_SOAP_UPGRADE; a_qname: STRING) is
			-- Establish invariant.
		require
			parent_not_void: a_parent /= Void
			qname_attribute: a_qname /= Void and then is_qname (a_qname)
		local
			a_namespace: XM_NAMESPACE
			an_attribute: XM_ATTRIBUTE
		do
			create a_namespace.make (Ns_prefix_env, Ns_name_env)
			make_last (a_parent, Supported_envelope_element_name, a_namespace)
			create a_namespace.make_default
			create an_attribute.make_last (Qname_attr, a_namespace, a_qname, Current)
		end
		
feature -- Status setting

	validate (an_identity: UT_URI) is
			-- Validate `Current'.
		do
			if elements.count > 0 then
				set_validation_fault (Sender_fault, "No element children are allowed for env:SupportedEnvelope", an_identity)
			elseif not has_attribute_by_name (Qname_attr) then
				set_validation_fault (Sender_fault, "Missing qname attribute from env:SupportedEnvelope", an_identity)
			else
				Precursor (an_identity)
			end
		end

invariant
	
	correct_name: is_valid_element (Current, Supported_envelope_element_name)

end -- class GOA_SOAP_SUPPORTED_ENVELOPE
