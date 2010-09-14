note
	description: "Objects that represent an XML-RPC multi call."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "XML-RPC"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_XRPC_MULTI_CALL

inherit

	GOA_XRPC_CALL
		rename
			make as call_make
		export
			{NONE} params, add_param
		redefine
			unmarshall, marshall
		end

create
	
	make, unmarshall

feature -- Initialisation

	make
			-- Initialise 
		do
			call_make (Multicall_method_name)
			create sub_calls.make_default
			unmarshall_ok := True
		end
		
	unmarshall (node: XM_ELEMENT)
			-- Initialise XML-RPC call from DOM element.
			-- NOTE: Does nothing. Should never be called. Unmarshalling
			-- occurs in execution of multiCall method.
		do
			unmarshall_ok := True
		end
	
feature -- Access
			
	sub_calls: DS_LINKED_LIST [GOA_XRPC_CALL]
			-- Sub-calls

feature -- Status setting

	add_call (new_call: GOA_XRPC_CALL)
			-- Add 'new_call' to the list of sub-calls to send
			-- with this call.
		require
			new_call_exists: new_call /= Void
		do
			sub_calls.force_last (new_call)
		end
	
feature -- Marshalling

	marshall: STRING
			-- Serialize this call to XML format
		local
			c: DS_LINKED_LIST_CURSOR [GOA_XRPC_CALL]
			p: DS_LINKED_LIST_CURSOR [GOA_XRPC_PARAM]
		do
			create Result.make (300)
			Result.append ("<?xml version=%"1.0%"?><methodCall><methodName>")
			Result.append (method_name.out)
			Result.append ("</methodName>")
			if not sub_calls.is_empty then
				Result.append ("<params><param><value><array><data>")
				from
					c := sub_calls.new_cursor
					c.start
				until
					c.off
				loop
					-- method name
					Result.append ("<value><struct><member><name>")
					Result.append (Method_name_id)
					Result.append ("</name><value>")
					Result.append (c.item.method_name.out)
					Result.append ("</value></member>")
					-- method params
					Result.append ("<member><name>")
					Result.append (Method_params_id)
					Result.append ("</name><value><array><data>")
					from
						p := c.item.params.new_cursor
						p.start
					until
						p.off
					loop
						Result.append (p.item.value.marshall)
						p.forth
					end
					Result.append ("</data></array></value></member></struct></value>")
					c.forth
				end
				Result.append ("</data></array></value></param></params>")
			end
			Result.append ("</methodCall>")
		end
	
	Multicall_method_name: STRING 
		once
			create Result.make_from_string ("system.multiCall")
		end
	
	Method_params_id: STRING = "params"
	
	Method_name_id: STRING = "methodName"
	
invariant
	
	calls_exists: unmarshall_ok implies sub_calls /= Void
	
end -- class GOA_XRPC_MULTI_CALL
