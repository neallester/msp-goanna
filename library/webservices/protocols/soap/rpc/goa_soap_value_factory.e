indexing
	description: "Factory that correctly unmarshalls SOAP value objects depending on encoding styles."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class	GOA_SOAP_VALUE_FACTORY

inherit
	
	GOA_SOAP_CONSTANTS
		export
			{NONE} all
		end

	GOA_SOAP_FAULTS

	GOA_SHARED_ENCODING_REGISTRY

	UC_SHARED_STRING_EQUALITY_TESTER

		-- TODO: - needs lot's of work
		-- can't be used yet - part of the SOAP Encoding adjunct

create
	
	make
	
feature -- Initialisation

	make (a_node_uri, a_role_uri: UT_URI) is
			-- Establish invariant.
		require
			node_uri_not_void: a_role_uri /= Void and then not STRING_.same_string (a_role_uri.full_reference, Role_ultimate_receiver) implies a_node_uri /= Void
		do
			unmarshalled := True
			unmarshalling_fault := Void
			last_value := Void
			node_uri := a_node_uri
			role_uri := a_role_uri
		ensure
			no_error: unmarshalled
			node_set: node_uri = a_node_uri
			role_set: role_uri = a_role_uri
		end

feature -- Access

	node_uri: UT_URI
			-- Identity of processing node
	
	role_uri: UT_URI
			-- Role played by `node_uri'

feature -- Status report

	last_value: GOA_SOAP_VALUE
			-- Last value unmarshalled.
			
	unmarshalled: BOOLEAN
			-- Was unmarshalling/building performed successfully?
			
	unmarshalling_fault: GOA_SOAP_FAULT_INTENT
			-- Fault intent representing unmarshalling/building error.

	is_valid_scalar_type (a_value: ANY): BOOLEAN is
			-- Is `a_value' a valid scalar type?
		require
			value_exists: a_value /= Void
		do
			Result := scalar_types.has (a_value.generating_type)
			-- TODO: Is this OK?  conforming types won't match. That might be correct,
			--        as they can't be round-tripped
		end
		
	is_valid_array_type (a_value: ANY): BOOLEAN is
			-- Is `a_value' a valid array type?
			-- A valid array type is an 'ARRAY [ANY]' or conforming
			-- object.
		require
			value_exists: a_value /= Void
		local
			an_array: ARRAY [ANY]
		do
			an_array ?= a_value
			Reault := an_array /= Void
		end
		
	is_valid_struct_type (a_value: ANY): BOOLEAN is
			-- Is `a_value' a valid struct type?
		require
			value_exists: a_value /= Void
		local
			a_type: STRING
			a_struct: DS_HASH_TABLE [ANY, STRING]
		do
			create a_struct.make_default
			Result := a_value.conforms_to (a_struct)
		end

feature -- Factory

	unmarshall_value (a_value: STRING; an_encoding_style, a_type: STRING) is
			-- Unmarshall `a_value' according to `a_type' as defined in `an_encoding_style'. Make
			-- result available in last_value'.
		require
			value_exists: a_value /= Void
			type_not_empty: a_type /= Void and then not a_type.is_empty
			encoding_style_not_empty: an_encoding_style /= Void and then not an_encoding_style.is_empty
		local
			an_encoding: GOA_SOAP_ENCODING
		do
			if encodings.has (an_encoding_style) then
				an_encoding := encodings.get (an_encoding_style)
				if an_encoding.is_valid_type (a_type) then
					last_value := an_encoding.unmarshalled_value (a_type, a_value)
				else
					create unmarshalling_fault.make (Receiver_fault, STRING_.concat (a_type, " is not known to the encoding"), "en", node_uri, role_uri); unmarshalled := False
				end
			else
				create unmarshalling_fault.make (Data_encoding_unknown_fault, STRING_.concat (an_encoding_style, " is not recognized"), "en", node_uri, role_uri); unmarshalled := False
			end
		end
		
	build (a_value: ANY) is
			-- Build a new SOAP value from `a_value'.
		require
			value_exists: value /= Void
		local
			a_boolean: BOOLEAN
			a_character: CHARACTER
		do
			unmarshalled := True; unmarshalling_fault := Void
			if is_valid_scalar_type (a_value) then
				create {GOA_SOAP_SCALAR_VALUE} last_value.make (a_value)
			elseif is_valid_array_type (a_value) then
				create {GOA_SOAP_ARRAY_VALUE} last_value.make (a_value)
			elseif is_valid_struct_type (a_value) then
				create {GOA_SOAP_STRUCT_VALUE} last_value.make (a_value)
			else
				create unmarshalling_fault.make (Receiver_fault, "Web service returned invalid value", "en", node_uri, role_uri); unmarshalled := False
			end
		end

feature {NONE} -- Implementation

	scalar_types: DS_HASH_SET [STRING] is
			-- Valid scalar types
		once
			create Result.make (16)
			Result.set_equality_tester (string_equality_tester)
			Result.put_new ("BOOLEAN")
			Result.put_new ("CHARACTER")
			Result.put_new ("STRING")
			Result.put_new ("INTEGER")
			Result.put_new ("INTEGER_8")
			Result.put_new ("INTEGER_16")
			Result.put_new ("INTEGER_32")
			Result.put_new ("INTEGER_64")
			Result.put_new ("DOUBLE")
			Result.put_new ("REAL")
			Result.put_new ("MA_DECIMAL")
			Result.put_new ("DT_DATE_TIME")
			Result.put_new ("DT_TIME")
			Result.put_new ("DT_DATE")
			Result.put_new ("UT_URI")
			Result.put_new ("GOA_EXPANDED_QNAME")
			-- TODO Representations for gYearMonth, gYear, gMonthDay, gDay, gMonth, hexBinary, base64Binary
		end

invariant
	
	unmarshalling_error: last_value = Void implies unmarshalling_fault /= Void
	marshalling_ok: unmarshalled implies unmarshalling_fault = Void
	node_uri_not_void: role_uri /= Void and then not STRING_.same_string (role_uri.full_reference, Role_ultimate_receiver) implies node_uri /= Void

end -- class GOA_SOAP_VALUE_FACTORY
