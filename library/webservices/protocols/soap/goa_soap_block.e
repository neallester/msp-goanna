indexing
	description: "Objects that represent general SOAP blocks."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Colin Adams <colin@colina.demon.co.uk>"
	copyright: "Copyright (c) 2005 Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class

	GOA_SOAP_BLOCK

inherit
	
	GOA_SOAP_ELEMENT
		redefine
			check_encoding_style_attribute
		end

	UT_SHARED_URL_ENCODING
		export
			{NONE} all
		undefine
			copy, is_equal
		end

create

	make_last
	
feature -- Access

	encoding_style: UT_URI is
			-- Encoding style in scope
		local
			a_parent: XM_ELEMENT
		do
			if local_encoding_style = Void then
				from
					a_parent ?= node.parent
				until
					a_parent = Void or else Result /= Void
				loop
					if a_parent.has_attribute_by_qualified_name (Ns_name_env, Encoding_style_attr) then
						create Result.make (a_parent.attribute_by_qualified_name (Ns_name_env, Encoding_style_attr).value)
					else
						a_parent ?= a_parent.parent
					end
				end
			else
				Result := local_encoding_style
			end
		ensure
			style_may_be_unknown: True
		end

	is_encoding_style_permitted: BOOLEAN is
			-- Is `encoding_style' permitted to be non-Void?
		local
			a_parent: XM_ELEMENT
		do
			from
				a_parent ?= node.parent
			until
				a_parent = Void or else Result
			loop
				if a_parent.has_namespace and then STRING_.same_string (a_parent.namespace.uri, Ns_name_env) then
					if STRING_.same_string (a_parent.name, Body_element_name) then
						Result := True -- N.B. we redefine `is_encoding_style_permitted' for Faults
					elseif STRING_.same_string (a_parent.name, Header_element_name) then
						Result := True
					elseif STRING_.same_string (a_parent.name, Fault_detail_element_name) then
						Result := True					
					end
					a_parent ?= a_parent.parent
				end
			end
		end

	node: XM_ELEMENT
			-- The XML element of this block

	block_name: STRING is
			-- Qualified name of `node'
		local
			a_namespace: XM_NAMESPACE
		do
			create Result.make (100)
			if node.has_namespace then
				a_namespace := node.namespace
				if a_namespace.has_prefix then
					Result.append (a_namespace.ns_prefix)
					Result.append (Prefix_separator)
				else
					Result.append (Ns_openening_brace)
					Result.append (a_namespace.uri)
					Result.append (Ns_closing_brace)
				end
			end
			Result.append (node.name)
		ensure
			block_name_not_void: Result /= Void
		end

feature -- Status setting

	set_encoding_style (an_encoding_style: like encoding_style) is
			-- Set 'encoding_style' to 'an_encoding_style'
		require
			new_encoding_style_exists: an_encoding_style /= Void
			encoding_style_permitted: is_encoding_style_permitted
		local
			a_namespace: XM_NAMESPACE
		do
			local_encoding_style := an_encoding_style
			if node.has_attribute_by_qualified_name (Ns_name_env, Encoding_style_attr) then
				node.remove_attribute_by_qualified_name (Ns_name_env, Encoding_style_attr)
			end
			create a_namespace.make (Ns_prefix_env, Ns_name_env)
			node.add_attribute (Encoding_style_attr, a_namespace, an_encoding_style.full_reference)
		ensure
			encoding_style_set: local_encoding_style = an_encoding_style
		end

	-- TODO: Do we need this next routine ??

	set_node (a_node: like node) is
			-- Set `node' to `a_node'
		require
			new_node_exists: a_node /= Void
		do
			node := a_node
		ensure
			node_set: node = a_node
		end

feature {GOA_SOAP_NODE_FORMATTER} -- Implementation

	encoding_style_attribute: STRING is
			-- Encoding style attribute for insertion in marshall strings;
			-- Created string is prefixed with a single space.
		do
			create Result.make (40)
			if local_encoding_style /= Void then
				Result.append_string (Space_s)
				Result.append_string (Ns_prefix_env)
				Result.append_string (Prefix_separator)
				Result.append_string (Encoding_style_attr)
				Result.append (Eq_s)
				Result.append (Quot_s)
				Result.append (encoding_style.full_reference)
				Result.append (Quot_s)
			end
		ensure
			Result_not_void: Result /= Void
		end
		
feature -- Marshalling

	marshalled: STRING is
			-- Serialized to XML format
		local
			a_stream: KL_STRING_OUTPUT_STREAM
		do
			create a_stream.make_empty
			formatter.set_output (a_stream)
			formatter.wipe_out
			formatter.format (node, Current)
			Result := a_stream.string
		end
	
feature {NONE} -- Implementation

	local_encoding_style: UT_URI
			-- Encoding style

	formatter: GOA_SOAP_NODE_FORMATTER is
			-- XML node formatter
		once
			create Result.make
		end

	check_encoding_style_attribute (an_identifying_uri, a_role_uri: UT_URI) is
			-- Search for optional encodingStyle attribute, unmarshall and set
			-- encoding style if found. Notify of unmarshalling error by setting
			-- 'unmarshall_ok'.
			--| encoding style attribute is explicitly encoded as an XMLSchema anyURI.
		local
			a_str: STRING
			an_attr: XM_ATTRIBUTE
			a_uri: UT_URI
		do
			if has_attribute_by_qualified_name (Ns_name_env, Encoding_style_attr) then
				if is_encoding_style_permitted then
					an_attr := attribute_by_qualified_name (Ns_name_env, Encoding_style_attr)
					value_factory.unmarshall_value (an_attr.value, Ns_name_xs, Xsd_anyuri)
					if not value_factory.validated then
						validated := False; validation_fault := value_factory.validation_fault
					else
						a_str ?= value_factory.last_value.as_object
						if a_str /= Void and then not a_str.is_empty and then not Url_encoding.has_excluded_characters (a_str) then
							create a_uri.make (a_str)
							set_encoding_style (a_uri)
						else
							set_validation_fault (Sender_fault, "Env:encodingStyle is not an xs:anyURI", an_identifying_uri, a_role_uri)
						end
					end
				else
					set_validation_fault (Sender_fault, STRING_.concat ("Env:encodingStyle is not permitted on ", block_name), an_identifying_uri, a_role_uri)
				end
			end
		end
	
invariant

	encoding_style_not_permitted: not is_encoding_style_permitted implies local_encoding_style = Void

end -- class GOA_SOAP_BLOCK
