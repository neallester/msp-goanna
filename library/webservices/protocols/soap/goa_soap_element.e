indexing
	description: "Abstract objects that represent general SOAP element."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_SOAP_ELEMENT

inherit

	XM_ELEMENT
		export
			{ANY}  all -- TODO: review
		end
	
	GOA_SOAP_CONSTANTS
		export
			{NONE} all
		undefine
			copy, is_equal
		end
	
	GOA_SOAP_FAULTS
		undefine
			copy, is_equal
		end

	GOA_XML_SCHEMA_CONSTANTS
		export
			{NONE} all
		undefine
			copy, is_equal
		end

	UT_SHARED_URL_ENCODING
		export
			{NONE} all
		undefine
			copy, is_equal
		end

	KL_IMPORTED_STRING_ROUTINES
		export
			{GOA_SOAP_ELEMENT} all
		undefine
			copy, is_equal
		end

	GOA_SHARED_ENCODING_REGISTRY
		undefine
			copy, is_equal
		end

	XM_XPATH_NAME_UTILITIES
		undefine
			copy, is_equal
		end

create

	make_last, construct

feature {NONE} -- Initialization

	construct (a_parent: GOA_SOAP_ELEMENT; a_namespace, a_name: STRING) is
			-- Initialise new element.
		require
			parent_validated: a_parent /= Void and then a_parent.validation_complete and then a_parent.validated
			name_not_empty: a_name /= Void and then not a_name.is_empty
		local
			a_namespace: XM_NAMESPACE
		do
			if a_namespace /= Void then
				create a_namespace.make (Void, a_namespace)
			else
				create a_namespace.make (Void, Default_namespace)
			end
			make_last (a_parent, a_name, a_namespace)
		end	

feature -- Access

	envelope: GOA_SOAP_ENVELOPE is
			-- Document element
		require
			validation_complete: validation_complete
		do
			Result ?= root_node.root_element
		ensure
			envelope_not_void: Result /= Void
		end

	element_name: STRING is
			-- Qualified name of `Current'
		do
			create Result.make (100)
			if has_prefix then
				Result.append (ns_prefix)
				Result.append (Prefix_separator)
			end
			Result.append (name)
		ensure
			element_name_not_empty: Result /= Void and then Result.is_empty
		end

	block_name: STRING is
			-- Expanded name of `Current'
		local
			a_namespace: XM_NAMESPACE
		do
			create Result.make (100)
			if has_namespace then
				if namespace.has_prefix then
					Result.append (namespace.ns_prefix)
					Result.append (Prefix_separator)
				else
					Result.append (Ns_opening_brace)
					Result.append (namespace.uri)
					Result.append (Ns_closing_brace)
				end
			end
			Result.append (name)
		ensure
			block_name_not_void: Result /= Void
			expanded_name: is_valid_expanded_name (Result)
		end

	encoding_style: UT_URI is
			-- Encoding style in scope
		local
			a_parent: GOA_SOAP_ELEMENT
		do
			if local_encoding_style = Void then
				from
					a_parent ?= parent
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

	type_name: GOA_EXPANDED_QNAME is
			-- Type name
		local
			a_lexical_qname: STRING
			a_parent: GOA_SOAP_ELEMENT
		do
			if has_attribute_by_qualified_name (Ns_name_xsi, Type_attr) then
				a_lexical_qname := attribute_by_qualified_name (Ns_name_xsi, Type_attr).value
			else
				a_parent ?= parent
				if a_parent /= Void and then a_parent.has_attribute_by_qualified_name (Ns_name_enc, Item_type_attr) then
					a_lexical_qname := a_parent.attribute_by_qualified_name (Ns_name_enc, Item_type_attr).value
				end
			end
			if a_lexical_qname /= Void then
				create Result.make_from_qname (qname_to_expanded_name (a_lexical_qname))
			end
		ensure
			may_be_unspecified: True
		end

	is_encoding_style_permitted: BOOLEAN is
			-- Is `encoding_style' permitted to be non-Void?
		local
			a_parent: GOA_SOAP_ELEMENT
			finished: BOOLEAN
		do
			from
				a_parent ?= parent
			until
				a_parent = Void or else finished
			loop
				if a_parent.has_namespace and then STRING_.same_string (a_parent.namespace.uri, Ns_name_env) then
					if STRING_.same_string (a_parent.name, Body_element_name) then
						Result := True; finished := True -- N.B. we redefine `is_encoding_style_permitted' for Faults
					elseif STRING_.same_string (a_parent.name, Header_element_name) then
						Result := True; finished := True
					elseif STRING_.same_string (a_parent.name, Fault_detail_element_name) then
						Result := True; finished := True			
					elseif STRING_.same_string (a_parent.name, Upgrade_element_name) then
						Result := False; finished := True
					elseif STRING_.same_string (a_parent.name, Not_understood_element_name) then
						Result := False; finished := True					
					end
				end
				a_parent ?= a_parent.parent
			end
		end

feature -- Status report

	validation_fault: GOA_SOAP_FAULT_INTENT
			-- Fault generated by validation error;
			-- Available if not `validated'.

	validated: BOOLEAN
			-- Did `validate' succeed?

	validation_complete: BOOLEAN
			-- Has `validate' completed?

feature -- Status setting

	set_validation_fault (a_code: INTEGER; a_text: STRING; a_node_uri: UT_URI) is
			-- Set `validation_fault'.
		require
			text_not_empty: a_text /= Void and then not a_text.is_empty
			valid_code: is_valid_fault_code (a_code)
			node_uri_not_void: a_node_uri /= Void
		do
			validated := False
			validation_fault := new_validation_fault (a_code, a_text, a_node_uri)
		ensure
			validation_failed: not validated
		end

	validate (an_identity: UT_URI) is
			-- Validate `Current'.
		require
			identity_not_void: an_identity /= Void
		local
			child_elements: DS_LIST [XM_ELEMENT]
			a_cursor: DS_LIST_CURSOR [XM_ELEMENT]
			an_element: GOA_SOAP_ELEMENT
		do
			scan_attributes (an_identity, False)
			check_encoding_style_attribute (an_identity)
			from
				a_cursor := elements.new_cursor; a_cursor.start
			until
				a_cursor.after
			loop
				an_element ?= a_cursor.item
				an_element.validate (an_identity); validated := an_element.validated
				if validated then
					a_cursor.forth
				else
					validation_fault := an_element.validation_fault
					a_cursor.go_after
				end
			end
			if encoding_style /= Void then validate_encoding (an_identity) end
			validation_complete := True
		end

	validate_encoding (an_identity: UT_URI) is
			-- Perform additional validation by `encoding_style'.
		require
			identity_not_void: an_identity /= Void
			encoding_style_not_void: encoding_style /= Void
		local
			an_encoding: GOA_SOAP_ENCODING
		do
			an_encoding := encodings.get (encoding_style.full_reference)
			an_encoding.validate_encoding_information (Current, envelope.unique_identifiers, an_identity)
			if not an_encoding.was_valid then
				validated := False; validation_fault := an_encoding.validation_fault
			end
		end

	set_encoding_style (an_encoding_style: like encoding_style) is
			-- Set 'local_encoding_style' to 'an_encoding_style'
		require
			new_encoding_style_exists: an_encoding_style /= Void
			encoding_style_permitted: is_encoding_style_permitted
		local
			a_namespace: XM_NAMESPACE
		do
			local_encoding_style := an_encoding_style
			if has_attribute_by_qualified_name (Ns_name_env, Encoding_style_attr) then
				remove_attribute_by_qualified_name (Ns_name_env, Encoding_style_attr)
			end
			create a_namespace.make (Ns_prefix_env, Ns_name_env)
			add_attribute (Encoding_style_attr, a_namespace, an_encoding_style.full_reference)
		ensure
			encoding_style_set: local_encoding_style = an_encoding_style
		end

feature {GOA_SOAP_ELEMENT} -- Implementation

	prefix_for_namespace (a_namespace_uri: STRING): STRING is
			-- Bound prefix for `a_namespace_uri'
		require
			namespace_not_void: a_namespace_uri /= Void
		local
			a_list: DS_LINKED_LIST [XM_NAMESPACE]
			a_cursor: DS_LINKED_LIST_CURSOR [XM_NAMESPACE]
			a_parent: GOA_SOAP_ELEMENT
			a_namespace: XM_NAMESPACE
		do
			from
				a_parent := Current
			until
				Result /= Void or else a_parent = Void
			loop
				a_list := a_parent.namespace_declarations
				from
					a_cursor := a_list.new_cursor; a_cursor.start
				until
					a_cursor.after
				loop
					a_namespace := a_cursor.item
					if STRING_.same_string (a_namespace.uri, a_namespace_uri) then
						Result := a_namespace.ns_prefix
						a_cursor.go_after
					else
						a_cursor.forth
					end
				end
				if Result = Void then a_parent ?= a_parent.parent end
			end
		ensure
			result_may_be_void: True
		end
	
feature {NONE} -- Implementation

	local_encoding_style: UT_URI
			-- Encoding style present on `Current'

	namespaces: DS_LINKED_LIST [XM_NAMESPACE]
			-- Namespace declarations on `Current'

	named_element (a_parent: XM_ELEMENT; a_name, a_namespace: STRING): XM_ELEMENT is
			-- First element with 'a_name' and 'a_namespace'
		require
			parent_exists: a_parent /= Void
			name_exists: a_name /= Void
		local
			a_child_node_cursor: DS_BILINEAR_CURSOR [XM_NODE]
			a_child: XM_ELEMENT
			found: BOOLEAN
		do
			if not a_parent.is_empty then
				from
					a_child_node_cursor := a_parent.new_cursor
					a_child_node_cursor.start
				until		
					a_child_node_cursor.off or found
				loop
					a_child ?= a_child_node_cursor.item
					if a_child /= Void then
						if STRING_.same_string (a_child.name, a_name) then
							if (a_namespace = Void and then not a_child.has_namespace) or else
								(a_namespace /= Void and then a_child.has_namespace 
								 and then STRING_.same_string (a_child.namespace.uri, a_namespace)) then
								Result := a_child
								found := True
							end
						end
					end
					a_child_node_cursor.forth			
				end
			end
		ensure
			void_if_not_found: True
		end

	is_valid_element (an_element: XM_ELEMENT; a_name: STRING): BOOLEAN is
			-- Is `an_element' named by `a_name', in the soap-envelope namespace?
		require
			element_exists: an_element /= Void
			name_not_empty: a_name /= Void and then not a_name.is_empty
		do
			Result := an_element.has_namespace and then STRING_.same_string (an_element.namespace.uri, Ns_name_env)
				and then  STRING_.same_string (an_element.name, a_name)
		end

	check_encoding_style_attribute (an_identifying_uri: UT_URI) is
			-- Search for optional encodingStyle attribute, unmarshall and set `local_encoding_style' if found.
			-- Notify of unmarshalling error by setting `validated'.
			--| encoding style attribute is explicitly encoded as an XMLSchema anyURI.
		local
			a_str: STRING
			a_uri: UT_URI
		do
			if has_attribute_by_qualified_name (Ns_name_env, Encoding_style_attr) then
				if is_encoding_style_permitted then
					a_str := attribute_by_qualified_name (Ns_name_env, Encoding_style_attr).value
					if a_str /= Void and then not a_str.is_empty and then not Url_encoding.has_excluded_characters (a_str) then
						create a_uri.make (a_str)
						set_encoding_style (a_uri)
						if encodings.has (a_uri.full_reference) then
							if not envelope.encoding_styles.has (a_uri.full_reference) then
								envelope.encoding_styles.force_new (a_uri.full_reference)
							end
						else
							set_validation_fault (Data_encoding_unknown_fault, STRING_.concat (a_uri.full_reference, " is not known"), an_identifying_uri)
						end
					else
						set_validation_fault (Sender_fault, "Env:encodingStyle is not an xs:anyURI", an_identifying_uri)
					end
				else
					set_validation_fault (Sender_fault, STRING_.concat ("Env:encodingStyle is not permitted on ", block_name), an_identifying_uri)
				end
			end
		end
	
	scan_attributes (an_identity: UT_URI; must_be_namespace_qualified: BOOLEAN) is
			-- Scan attributes and namespace declarations of `Current'.
		require
			identity_not_void: an_identity /= Void
		local
			a_cursor: DS_LINEAR_CURSOR [XM_NODE]
			a_typer: XM_NODE_TYPER
			an_attr: XM_ATTRIBUTE
		do
			create namespaces.make_default
			create a_typer
			a_cursor := new_cursor
			validated := True
			from a_cursor.start until not validated or else a_cursor.after loop
				a_cursor.item.process (a_typer)
				if a_typer.is_attribute then
						an_attr := a_typer.xml_attribute					
					if an_attr.is_namespace_declaration then
						namespaces.force_last (an_attr.namespace_declaration)
						--if an_attr.has_namespace then
						--	remove_attribute_by_qualified_name (an_attr.namespace.uri, an_attr.name)
						--else
						--	remove_attribute_by_name (an_attr.name)
						--end
					else
						if must_be_namespace_qualified and then not an_attr.has_namespace then
							set_validation_fault (Sender_fault, STRING_.concat ("Unqualified attributes are not permitted on ", element_name), an_identity)
						end
					end
				end
				a_cursor.forth
			end
		end
	
	prefix_to_namespace (a_prefix: STRING): STRING is
			-- Namespace URI for `a_prefix'
		require
			prefix_not_void: a_prefix /= Void
		local
			a_list: DS_LINKED_LIST [XM_NAMESPACE]
			a_cursor: DS_LINKED_LIST_CURSOR [XM_NAMESPACE]
			a_parent: GOA_SOAP_ELEMENT
			a_namespace: XM_NAMESPACE
		do
			from
				a_parent := Current
			until
				Result /= Void or else a_parent = Void
			loop
				a_list := a_parent.namespace_declarations
				from
					a_cursor := a_list.new_cursor; a_cursor.start
				until
					a_cursor.after
				loop
					a_namespace := a_cursor.item
					if STRING_.same_string (a_namespace.ns_prefix, a_prefix) then
						Result := a_namespace.uri
						a_cursor.go_after
					else
						a_cursor.forth
					end
				end
				if Result = Void then a_parent ?= a_parent.parent end
			end
		ensure
			result_may_be_void: True
		end

	expanded_name_to_qname (an_expanded_name: STRING): STRING is
			-- QName from `an_expanded_name, if prefix is in scope
		require
			expanded_name_not_empty: an_expanded_name /= Void and then not an_expanded_name.is_empty
		local
			a_namespace_uri, a_prefix, a_local_name: STRING
			an_index: INTEGER
		do
			if an_expanded_name.item (1).is_equal (Ns_opening_brace.item (1)) then
				an_index := an_expanded_name.index_of (Ns_closing_brace.item (1), 2)
				check
					closing_brace_found: an_index > 1
					local_name_present: an_expanded_name.count > an_index
					-- definition of expanded name
				end
				a_local_name := an_expanded_name.substring (an_index + 1, an_expanded_name.count)
				a_namespace_uri := an_expanded_name.substring (2, an_index - 1)
				a_prefix := prefix_for_namespace (a_namespace_uri)
				if a_prefix /= Void then
					create Result.make_from_string (a_prefix)
					if not Result.is_empty then Result.append (Prefix_separator) end
					Result.append (a_local_name)
				else
					Result := an_expanded_name
				end
			end
		ensure
			result_not_void: Result /= Void
		end
	
	qname_to_expanded_name (a_qname: STRING): STRING is
			-- QName from `an_expanded_name, if prefix is in scope
		require
			is_qname: a_qname /= Void and then not a_qname.is_empty and then is_qname (a_qname)
		local
			qname_parts: DS_LIST [ STRING]
			a_splitter: ST_SPLITTER
		do
			create a_splitter.make
			a_splitter.set_separators (Prefix_separator)
			qname_parts := a_splitter.split (a_qname)
			if qname_parts.count = 1 then
				Result := qname_parts.item (1)
			else
				Result := STRING_.concat (Ns_opening_brace, prefix_to_namespace (qname_parts.item (1)))
				Result := STRING_.appended_string (Result, Ns_closing_brace)
				Result := STRING_.appended_string (Result, qname_parts.item (2))
			end
			
		ensure
			result_not_void: Result /= Void
			expanded_name: is_valid_expanded_name (Result)
		end
	
invariant

	encoding_style_not_permitted: not is_encoding_style_permitted implies local_encoding_style = Void
	validate: validated implies validation_fault = Void
	validation_fault: validation_complete and then not validated implies validation_fault /= Void

end -- class GOA_SOAP_ELEMENT
