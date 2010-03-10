indexing
	description: "Objects that create SOAP messages."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Colin Adams <colin@aolina.demon.co.uk>"
	copyright: "Copyright (c) 2005 Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class	GOA_SOAP_MESSAGE_FACTORY

inherit

	GOA_SOAP_NODE_FACTORY

feature -- Creation

	new_envelope: GOA_SOAP_ENVELOPE is
			-- New SOAP message
		local
			a_document: XM_DOCUMENT
			a_namespace: XM_NAMESPACE
			an_attribute: XM_ATTRIBUTE
		do
			create a_document.make
			Result := new_document_element (a_document, Ns_prefix_env)
			create a_namespace.make (Xmlns, Xmlns_namespace)
			create an_attribute.make_last (Ns_prefix_env, a_namespace, Ns_name_env, Result)
		ensure
			envelope_created: Result /= Void
		end	

	new_rpc_envelope: GOA_SOAP_ENVELOPE is
			-- New SOAP rpc invocation or response
		local
			a_namespace: XM_NAMESPACE
			an_attribute: XM_ATTRIBUTE
		do
			Result := new_envelope
			create a_namespace.make (Xmlns, Xmlns_namespace)
			create an_attribute.make_last (Ns_prefix_rpc, a_namespace, Ns_name_rpc, Result)
		ensure
			envelope_created: Result /= Void
		end

	new_rpc_soap_envelope: GOA_SOAP_ENVELOPE is
			-- New SOAP rpc invocation or response with SOAP encoding
		local
			a_namespace: XM_NAMESPACE
			an_attribute: XM_ATTRIBUTE
		do
			Result := new_rpc_envelope
			create a_namespace.make (Xmlns, Xmlns_namespace)
			create an_attribute.make_last (Ns_prefix_enc, a_namespace, Ns_name_enc, Result)
		ensure
			envelope_created: Result /= Void
		end

	new_body (an_envelope: GOA_SOAP_ENVELOPE; an_identity: UT_URI): GOA_SOAP_BODY is
			-- New SOAP body
		require
			envelope_not_void: an_envelope /= Void
			no_body: an_envelope.body = Void
			identity_not_void: an_identity /= Void
		do
			Result ?= new_element (an_envelope, Body_element_name, Ns_name_env, Ns_prefix_env, False, False)
			an_envelope.validate (an_identity)
			check
				valid_envelope: an_envelope.validation_complete and an_envelope.validated
				valid_body: Result.validation_complete and Result.validated
			end

		ensure
			body_created: Result /= Void
		end

	new_header (an_envelope: GOA_SOAP_ENVELOPE; an_identity: UT_URI): GOA_SOAP_HEADER is
			-- New SOAP header
		require
			envelope_not_void: an_envelope /= Void
			no_header: an_envelope.header = Void
			identity_not_void: an_identity /= Void
		do
			Result ?= new_element (an_envelope, Header_element_name, Ns_name_env, Ns_prefix_env, False, False)
		ensure
			header_created: Result /= Void
		end

end
	
