indexing
	description: "Factory that correctly unmarshalls value objects."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "XML-RPC"
	date: "$Date: 2007-01-07 08:29:59 -0800 (Sun, 07 Jan 2007) $"
	revision: "$Revision: 532 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_XRPC_VALUE_FACTORY

inherit

	GOA_XRPC_CONSTANTS
		export
			{NONE} all
		end

create

	make

feature -- Initialisation

	make is
			-- Initialise
		do
			unmarshall_ok := True
		end

feature -- Status report

	unmarshall_ok: BOOLEAN
			-- Was unmarshalling performed successfully?

	unmarshall_error_code: INTEGER
			-- Error code of unmarshalling error. Available if not
			-- 'unmarshall_ok'. See GOA_XRPC_CONSTANTS for error codes.

feature -- Factory

	unmarshall (node: XM_ELEMENT): GOA_XRPC_VALUE is
			-- Unmarshall value
		local
			type_elem: XM_ELEMENT
		do
			unmarshall_ok := True
			-- peek at value type to correctly unmarshall

			-- Samuele Lucchini <origo@muele.net> (03/01/2007)
			-- Check if node is not empty, this occurs for empty string values!
			if not node.is_empty then
				type_elem ?= node.first
			end

			if type_elem /= Void then
				if type_elem.name.is_equal (Array_element) then
					create {GOA_XRPC_ARRAY_VALUE} Result.unmarshall (type_elem)
				elseif type_elem.name.is_equal (Struct_element) then
					create {GOA_XRPC_STRUCT_VALUE} Result.unmarshall (type_elem)
				else
					create {GOA_XRPC_SCALAR_VALUE} Result.unmarshall (type_elem)
				end
				if not Result.unmarshall_ok then
					unmarshall_ok := False
					unmarshall_error_code := Result.unmarshall_error_code
				end
			else
				-- must be an untyped string, pass the value down
				create {GOA_XRPC_SCALAR_VALUE} Result.unmarshall (node)
				if not Result.unmarshall_ok then
					unmarshall_ok := False
					unmarshall_error_code := Result.unmarshall_error_code
				end
			end
		end

	build (value: ANY): GOA_XRPC_VALUE is
			-- Build a new XML-RPC value from 'value'. Return Void if 'value' is not
			-- a valid XML-RPC type.
		require
			value_exists: value /= Void
		local
			array: ARRAY [ANY]
			struct: DS_HASH_TABLE [ANY, STRING]
		do
			-- check type and create appropriate concrete value type
			-- if already a value then leave it
			Result ?= value
			if Result = Void then
				if valid_scalar_type (value) then
					create {GOA_XRPC_SCALAR_VALUE} Result.make (value)
				elseif valid_array_type (value) then
					array ?= value
					create {GOA_XRPC_ARRAY_VALUE} Result.make_from_array (array)
				elseif valid_struct_type (value) then
					struct ?= value
					if struct /= Void then
						create {GOA_XRPC_STRUCT_VALUE} Result.make_from_struct (struct)
					end

				end
			end
		ensure
			value_exists_if_valid_type: valid_scalar_type (value)
				or valid_array_type (value)
				or valid_struct_type (value)
				implies Result /= Void
		end

invariant

	unmarshall_error: not unmarshall_ok implies unmarshall_error_code > 0

end -- class GOA_XRPC_VALUE_FACTORY
