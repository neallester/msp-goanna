indexing
	description: "Objects that represent a SOAP header block"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class GOA_SOAP_HEADER_BLOCK

inherit

	GOA_SOAP_ELEMENT
		redefine
			validate
		end

create

	make_last
	
feature -- Access
			
	role: UT_URI
			-- Role for this header (i.e. nodes at which this header is targetted). Void if unspecified 
			-- (ie.implicitly targeted at the ultimate SOAP receiver)
			
	must_understand: BOOLEAN
			-- Must understand flag

	relay:  BOOLEAN
			-- Relay flag

feature -- Status setting

	validate (an_identity: UT_URI) is
			-- Validate `Current'.
		do
			scan_attributes (an_identity, False)
			check_encoding_style_attribute (an_identity)
			check_role_attribute (an_identity)
			check_must_understand_attribute (an_identity)
			check_relay_attribute (an_identity)
			validation_complete := True			
		end
			
	set_role (a_role: like role) is
			-- Set `role' to `a_role'
		require
			role_exists: a_role /= Void
		local
			a_uri: STRING
			a_namespace: XM_NAMESPACE
		do
			role := a_role
			if has_attribute_by_qualified_name (Ns_name_env, Role_attr) then
				remove_attribute_by_qualified_name (Ns_name_env, Role_attr)
			end
			a_uri := a_role.full_reference
			if not STRING_.same_string (a_uri, Role_ultimate_receiver) then
				create a_namespace.make (Ns_prefix_env, Ns_name_env)
				add_attribute (Role_attr, a_namespace, a_uri)
			end
		ensure
			role_set: role = a_role
		end
	
	set_must_understand (a_flag: BOOLEAN) is
			-- Set `must_understand' to value of `a_flag'.
			-- Do not call this method to leave unspecified.
		local
			a_namespace: XM_NAMESPACE
		do
			must_understand := a_flag
			if has_attribute_by_qualified_name (Ns_name_env, Must_understand_attr) then
				remove_attribute_by_qualified_name (Ns_name_env, Must_understand_attr)
			end
			if must_understand then
				create a_namespace.make (Ns_prefix_env, Ns_name_env)
				add_attribute (Must_understand_attr, a_namespace, "true")
			end
		end

	set_relay (a_flag: BOOLEAN) is
			-- Set `relay' to value of `a_flag'.
			-- Do not call this method to leave unspecified.
		local
			a_namespace: XM_NAMESPACE
		do
			relay := a_flag
			if has_attribute_by_qualified_name (Ns_name_env, Relay_attr) then
				remove_attribute_by_qualified_name (Ns_name_env, Relay_attr)
			end
			if relay then
				create a_namespace.make (Ns_prefix_env, Ns_name_env)
				add_attribute (Relay_attr, a_namespace, "true")
			end
		end
		
feature {NONE} -- Implementation

	check_role_attribute (an_identifying_uri: UT_URI) is
			-- Search for optional role attribute, unmarshall and set`role' if found. 
			-- Notify of unmarshalling error by setting `validated'.
			--| role attribute is explicitly encoded as an XMLSchema anyURI.
		require
			node_uri_not_void: an_identifying_uri /= Void
		local
			a_str: STRING
			a_uri: UT_URI
		do
			if has_attribute_by_qualified_name (Ns_name_env, Role_attr) then
				a_str := attribute_by_qualified_name (Ns_name_env, Role_attr).value
				if a_str /= Void and then not a_str.is_empty and then not Url_encoding.has_excluded_characters (a_str) then
					create a_uri.make (a_str)
					set_role (a_uri)
				else
					set_validation_fault (Sender_fault, "Env:role is not an xs:anyURI", an_identifying_uri)
				end			
			end
		end

	check_must_understand_attribute (an_identifying_uri: UT_URI) is
			-- Search for optional mustUnderstand attribute, unmarshall and set `must_understand' if found.
			-- Notify of unmarshalling error by setting `validated'.
			--| mustUnderstand attribute is explicitly encoded as an XMLSchema boolean.
		require
			node_uri_not_void: an_identifying_uri /= Void
		local
			a_str: STRING
		do
			if has_attribute_by_qualified_name (Ns_name_env, Must_understand_attr) then
				a_str := attribute_by_qualified_name (Ns_name_env, Must_understand_attr).value
				if is_boolean (a_str) then
					set_must_understand (to_boolean (a_str))
				else
					set_validation_fault (Sender_fault, "Env:mustUnderstand is not an xs:boolean", an_identifying_uri)
				end
			end
		end
		
	check_relay_attribute (an_identifying_uri: UT_URI) is
			-- Search for optional relay attribute, unmarshall and set `relay' if found.
			-- Notify of unmarshalling error by setting `validated'.
			--| relay attribute is explicitly encoded as an XMLSchema boolean.
		require
			node_uri_not_void: an_identifying_uri /= Void
		local
			a_str: STRING
		do
			if has_attribute_by_qualified_name (Ns_name_env, Relay_attr) then
				a_str := attribute_by_qualified_name (Ns_name_env, Relay_attr).value
				if is_boolean (a_str) then
					set_relay (to_boolean (a_str))
				else
					set_validation_fault (Sender_fault, "Env:relay is not an xs:boolean", an_identifying_uri)
				end
			end
		end

	is_boolean (a_str: STRING): BOOLEAN is
			-- Is `a_str' an xs:boolean?
		require
			string_not_void: a_str /= Void
		do
			Result := STRING_.same_string (a_str, "1")
				or else  STRING_.same_string (a_str, "0")
				or else  STRING_.same_string (a_str, "true")
				or else  STRING_.same_string (a_str, "false")
		end

	to_boolean (a_str: STRING): BOOLEAN is
			-- Boolean value of `a_str'
		require
			string_not_void: a_str /= Void
			boolean_string: is_boolean (a_str)
		do
			if STRING_.same_string (a_str, "true") then
				Result := True
			elseif STRING_.same_string (a_str, "1") then
				Result := True
			end
		end
	
end -- class GOA_SOAP_HEADER_BLOCK
