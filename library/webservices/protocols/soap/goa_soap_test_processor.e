note
	description: "Processor for testing SOAP Messaging Framework"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Colin Adams <colin@colina.demon.co.uk>"
	copyright: "Copyright (c) 2005 Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class	GOA_SOAP_TEST_PROCESSOR

inherit

	GOA_SOAP_PROCESSOR

create

	make

feature {NONE} -- Initialization

	make (an_identity: like node)
		require
			identity_not_void: an_identity /= Void
		do
			node := an_identity
			initialize_structures
		ensure
			identity_set: node = an_identity
		end

feature -- Template routines

	send_build_failure_message (a_message: STRING)
			-- Send a build-failure message.
		require
			message_not_empty: a_message /= Void and then not a_message.is_empty
		do
			print (a_message);print ("%N")
		end

	add_additional_known_roles
			-- Add non-standard roles.
		do
		end

	determine_active_roles
			-- Determine in which roles we will act.
		local
			a_cursor: DS_LINKED_LIST_CURSOR [GOA_SOAP_HEADER_BLOCK]
		do
			active_roles.wipe_out
			if envelope.header /= Void then
				a_cursor := envelope.header.header_blocks.new_cursor
				from a_cursor.start until a_cursor.after loop
					examine_header_for_roles (a_cursor.item)
					a_cursor.forth
				end
			end
			examine_body_for_active_roles
			if is_ultimate_receiver and then not active_roles.has (Role_ultimate_receiver) then
				active_roles.force_new (Role_ultimate_receiver)
			end
		end

	examine_header_for_roles (a_header: GOA_SOAP_HEADER_BLOCK)
			-- Examine `a_header' to determine roles in which `Current' will act.
		local
			a_candidate_role: STRING
		do
			if a_header.role /= Void then
				a_candidate_role := a_header.role.full_reference
				if known_roles.has (a_candidate_role) and then not active_roles.has (a_candidate_role) then
					active_roles.force_new (a_candidate_role)
				end
			end
		end

	examine_body_for_active_roles
			-- Examine message body to determine roles in which `Current' will act.
		do
		end

	process_headers
			-- Process all mandatory headers (and optionally, non-mandatory headers) targetted at `Current'.
		local
			a_cursor: DS_LINKED_LIST_CURSOR [GOA_SOAP_HEADER_BLOCK]
		do
			is_header_fault := False
			if envelope.header /= Void then
				a_cursor := envelope.header.header_blocks.new_cursor
				from a_cursor.start until a_cursor.after loop
					if is_mandatory_header (a_cursor.item) then
						process_header (a_cursor.item)
					elseif are_optional_headers_processed and then is_targetted_header (a_cursor.item) then
						process_header (a_cursor.item)
					end
					a_cursor.forth
				end
			end
		end

	process_header (a_header:  GOA_SOAP_HEADER_BLOCK)
			-- Process `_header'
		do
			is_header_fault := False
		end

	process_body
			-- Process message body.
		local
			a_formatter: GOA_SOAP_NODE_FORMATTER
		do

			-- Default implementation just serializes message to standard output

			if envelope.is_fault_message then
				print ("Received message was a SOAP Fault%N")
			end
			--create a_formatter.make
			--a_formatter.set_output (std.output)
			--a_formatter.process_document (envelope.root_node)
			print ("%N")
		end

	create_and_send_must_understand_fault
			-- Send a MustUnderstand fault.
		local
			a_fault_intent: GOA_SOAP_FAULT_INTENT
		do
			create a_fault_intent.make (Must_understand_fault, "At least one mandatory header was not understood", "en", node, Void)
			a_fault_intent.set_not_understood_headers (not_understood_headers)
			send_message (new_fault_message (a_fault_intent))
		end

	create_and_send_fault (a_fault_intent: GOA_SOAP_FAULT_INTENT)
			-- Create and send a fault_message.
		require
			fault_intent_not_void: a_fault_intent /= Void
		local
			an_envelope: GOA_SOAP_ENVELOPE
		do
			an_envelope := new_fault_message (a_fault_intent)
			send_message (an_envelope)
		end
	
	send_message (an_envelope: GOA_SOAP_ENVELOPE)
			-- Send a SOAP message.
		local
			a_formatter: GOA_SOAP_NODE_FORMATTER
		do

			-- Default implementation just serializes message to standard output

			create a_formatter.make
			a_formatter.set_output (std.output)
			a_formatter.process_document (an_envelope.root_node)
			print ("%N")
		end

	relay_message
			-- TODO
		do
		end


invariant

	node_not_void: node /= Void
	known_roles_not_void: known_roles /= Void
	active_roles_not_void: active_roles /= Void

end -- class GOA_SOAP_TEST_PROCESSOR
