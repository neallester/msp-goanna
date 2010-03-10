	description: "SOAP Remote Procedure Calls using SOAP XML encoding"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Colin Adams <colin-adams@users.sourceforge.net>"
	copyright: "Copyright (c) 2005 Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

deferred class	GOA_SOAP_ENCODED_RPC

inherit

	GOA_SOAP_RPC

	GOA_SOAP_MESSAGE_FACTORY
		export
			{NONE} all
		end
			
	GOA_SHARED_ENCODING_REGISTRY
		export
			{NONE} all
		end

	GOA_SOAP_FAULTS
		export
			{NONE} all
		end
		
feature {NONE} -- Implementation

	rpc_response (a_service_name, a_method_name: STRING; a_result_value: ANY; some_parameters: TUPLE; a_node_identity: UT_URI; a_role: UT_URI): GOA_SOAP_ENVELOPE is
			-- SOAP response Envelope.
		local
			a_fault_intent: GOA_SOAP_FAULT_INTENT
			a_body: GOA_SOAP_BODY
			an_encoding_style: UT_URI
			a_result_struct, a_result_element, a_return_element: GOA_SOAP_ELEMENT
			a_text_item: XM_CHARACTER_DATA
			a_value: GOA_SOAP_VALUE
			a_cell: DS_CELL [GOA_SOAP_VALUE, BOOLEAN]
			a_value_factory: GOA_SOAP_VALUE_FACTORY
		do
			if encodings.has (Ns_name_enc) then
				a_soap_encoding := encodings.item (Ns_name_enc)
				Result := new_rpc_soap_envelope
				a_body := new_body (Result, a_node_identity)
				create an_encoding_style.make (Ns_name_enc)
				create a_result_struct.construct (a_body, a_service_name, a_method_name)
				a_result_struct.validate (a_node_identity)
				a_body.set_encoding_style (an_encoding_style)
				a_value ?= a_result_value
				if a_value /= Void then
					create a_result_element.construct (a_result_struct, Ns_name_rpc, Rpc_result_name)
					create a_text_item.make_last (a_result_element, return_qname)
					a_result_element.validate (a_node_identity)
					????create a_value_factory.make (a_node_identity, a_role)
					a_value_factory.build (a_value)
					if a_value_factory.marshalled then
						a_value := a_value_factory.last_value
						a_return_element := a_soap_encoding.encoded_element (a_result_element, return_qname, a_value)
						a_return_element.validate (a_node_identity)
						if not a_return_element.validated then
							create a_fault_intent.make (Receiver_fault, "Server failed to correctly generate the return value in SOAP XML encoding", "en", a_node_uri, a_role)
							Result := new_fault_message (a_fault_intent)
						end
					else
						Result := new_fault_message (a_value_factory.unmarshalling_fault)
					end
				end
			else
				create a_fault_intent.make (Receiver_fault, "SOAP XML encoding not available to server", "en", a_node_uri, a_role)
				Result := new_fault_message (a_fault_intent)
			end
		end

	return_qname: STRING is "return"
			-- Element name for return value

end


