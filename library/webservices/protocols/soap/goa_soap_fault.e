note
	description: "Objects that represent a SOAP fault."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class	GOA_SOAP_FAULT

inherit

	GOA_SOAP_FAULTS
		undefine
			copy, is_equal
		end

	GOA_SOAP_ELEMENT
		redefine
			is_encoding_style_permitted, validate
		end

	UC_SHARED_STRING_EQUALITY_TESTER
		undefine
			copy, is_equal
		end

create

	make_last, construct

feature {NONE} -- Initialization

	construct (a_body: GOA_SOAP_BODY; a_fault_code: INTEGER; a_reason, a_language: STRING; a_node_uri, a_role_uri: UT_URI; a_sub_code: STRING)
			-- Initialise new fault.
		require
			body_validated: a_body /= Void and then a_body.validation_complete and then a_body.validated
			valid_fault_code: is_valid_fault_code (a_fault_code)
			reason_exists: a_reason /= Void
			language_exists: a_language /= Void
		local
			a_namespace: XM_NAMESPACE
		do
			create a_namespace.make (Ns_prefix_env, Ns_name_env)
			make (a_body, Fault_element_name, a_namespace)
			a_body.add_body_block (Current)
			create fault_code.construct (Current, a_fault_code, a_sub_code)
			create reason.construct (Current, a_reason, a_language)
			if a_node_uri /= Void then
				create node_uri.construct (Current, a_node_uri)
			end
			if a_role_uri /= Void then
				create role.construct (Current, a_role_uri)
			end
		end

feature -- Access

	fault_code: GOA_SOAP_FAULT_CODE
			-- Fault code

	reason: GOA_SOAP_FAULT_REASON
			-- Reason

	node_uri: GOA_SOAP_FAULT_NODE
			-- Node which generated `Current' (optional)

	role: GOA_SOAP_FAULT_ROLE
			-- Role in which `node_uri' was operating (optional)

	detail: GOA_SOAP_FAULT_DETAIL
			-- Details about `Current' (optional)

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
			an_element: GOA_SOAP_ELEMENT
			a_count, an_index: INTEGER
			node_seen, role_seen, detail_seen: BOOLEAN
		do
			scan_attributes (an_identity, False)
			check_encoding_style_attribute (an_identity)
			if validated then
				child_elements := elements
				a_count := child_elements.count
				if a_count < 2 then
					set_validation_fault (Sender_fault, "Missing mandatory child elements from env:Fault", an_identity)
				elseif  a_count > 5 then
					set_validation_fault (Sender_fault, "Too child elements on env:Fault", an_identity)
				else
					fault_code ?= child_elements.item (1)
					if fault_code = Void then
						set_validation_fault (Sender_fault, "Env:Fault does not contain env:Code as first child", an_identity)
					else
						fault_code.validate (an_identity); validated := fault_code.validated
						if not validated then
							validation_fault := fault_code.validation_fault
						else
							reason ?= child_elements.item (2)
							if reason = Void then
								set_validation_fault (Sender_fault, "Env:Fault does not contain env:Reason as second child", an_identity)
							else
								reason.validate (an_identity);  validated := reason.validated
								if not validated then
									validation_fault := reason.validation_fault
								else
									from
										an_index := 3
									until
										not validated or else an_index > a_count
									loop
										an_element ?= child_elements.item (an_index)
										if is_valid_element (an_element, Fault_node_element_name) then
											if node_seen then
												set_validation_fault (Sender_fault, "Env:Fault contains more than one env:Node element", an_identity)
											elseif role_seen or else detail_seen then
												set_validation_fault (Sender_fault, "Env:Fault contains more env:Node element out of order", an_identity)
											else
												node_uri ?= an_element; node_uri.validate (an_identity); validated := node_uri.validated
												if validated then node_seen := True else validation_fault := node_uri.validation_fault end
											end
										elseif is_valid_element (an_element, Fault_role_element_name) then
											node_seen := True
											if role_seen then
												set_validation_fault (Sender_fault, "Env:Fault contains more than one env:Role element", an_identity)
											elseif detail_seen then
												set_validation_fault (Sender_fault, "Env:Fault contains more env:Role element out of order", an_identity)
											else
												role ?= an_element; role.validate (an_identity); validated := role.validated
												if validated then role_seen := True  else validation_fault := role.validation_fault end
											end
										elseif is_valid_element (an_element, Fault_detail_element_name) then
											node_seen := True; role_seen := True
											if detail_seen then
												set_validation_fault (Sender_fault, "Env:Fault contains more than one env:Detail element", an_identity)
											else
												node_seen := True; role_seen := True; detail_seen := True
												detail ?= an_element; detail.validate (an_identity); validated := detail.validated
												if validated then detail_seen := True else validation_fault := detail.validation_fault
												end
											end
										end
										an_index := an_index + 1
									end
								end
							end
						end
					end
				end
			end
			validation_complete := True
		end

feature -- Element change

	add_detail
			-- Add a Detail node.
		require
			detail_is_void: detail = Void
		do
			create detail.construct (Current)
		ensure
			detail_not_void: detail /= Void
		end

invariant
	
	fault_code_not_void: validation_complete and then validated implies fault_code /= Void
	reasons_exist: validation_complete and then validated implies reason /= Void
	node_uri_not_void: validation_complete and then role /= Void and then not STRING_.same_string (role.role.full_reference, Role_ultimate_receiver) implies node_uri /= Void
	correct_name: is_valid_element (Current, Fault_element_name)

end -- class GOA_SOAP_FAULT
