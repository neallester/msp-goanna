note
	description: "SOAP XML encoding corresponds to http://www.w3.org/2003/05/soap-encoding"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_SOAP_XML_ENCODING

inherit
	
	GOA_SOAP_ENCODING
	
	GOA_XML_SCHEMA_CONSTANTS
		export
			{NONE} all
		end

	GOAP_SOAP_FAULTS


feature -- Access

	declared_id (an_element: GOA_SOAP_ELEMENT): STRING
			-- Value of enc:id
		require
			element_exists: an_element /= Void
		do
			if an_element.has_attribute_by_qualified_name (Ns_name_enc, Id_attr) then
				Result := an_element.attribute_by_qualified_name (Ns_name_enc, Id_attr).value
			end
		ensure
			may_not_be_present: True
		end

	referenced_id (an_element: GOA_SOAP_ELEMENT): STRING
			-- Value of enc:ref
		require
			element_exists: an_element /= Void
		do
			if an_element.has_attribute_by_qualified_name (Ns_name_enc, Ref_attr) then
				Result := an_element.attribute_by_qualified_name (Ns_name_enc, Ref_attr).value
			end
		ensure
			may_not_be_present: True
		end

feature -- Status report

	is_valid_type (a_type: STRING): BOOLEAN
			-- Is `a_type' a known data type in this encoding scheme?
		do
			Result := is_valid_type_constant (a_type) -- what about compound values?
			-- or does this only apply to simple values?
		end

feature -- Subcodes

	Duplicate_id: STRING
		once
			Result := "DuplicateID"
		end

	Missing_id: STRING
		once
			Result := "MissingID"
		end

	Untyped_value: STRING
		once
			Result := "UntypedValue"
		end

feature -- Validation

	validate_references (an_element: GOA_SOAP_ELEMENT; unique_identifiers: DS_HASH_TABLE [GOA_SOAP_ELEMENT, STRING]; an_identity: UT_URI)
			-- Validate references from `an_element' and set `was_valid'.
		local
			a_reference: STRING
		do
			was_valid := True; validation_fault := Void
			a_reference := referenced_id (an_element)
			if a_reference /= Void and then not unique_identifiers.has (a_reference) then
				set_validation_fault (Sender_fault, sub_code_qname (an_element, Missing_id), a_message, an_identity)
			end
		end

	validate_encoding_information (an_element: GOA_SOAP_ELEMENT; unique_identifiers: DS_HASH_TABLE [GOA_SOAP_ELEMENT, STRING]; an_identity: UT_URI)
			-- Validate `an_element' in isolation and set `was_valid'.
		local
			an_id, a_message: STRING
		do
			was_valid := True; validation_fault := Void
			an_id := declared_id (an_element)
			if an_id /= Void then
				if unique_identifiers.has (an_id) then
					a_message := STRING_.concat ("Element ", an_element.element_name)
					a_message := STRING_.appended_string (a_message, " has the same enc:id as ")
					a_message := STRING_.appended_string (a_message, unique_identifiers.item (an_id).element_name)
					set_validation_fault (Sender_fault, sub_code_qname (an_element, Duplicate_id), a_message, an_identity)
				else
					unique_identifiers.item .force (an_element, an_id)
				end
			end
			if referenced_id (an_element) and then an_id /= Void then
				a_message := STRING_.concat ("Element ", an_element.element_name)
				a_message := STRING_.appended_string (a_message, " has both an enc:id and an enc:ref attribute")
				set_validation_fault (Sender_fault, Void, a_message, an_identity)
			end
		end

feature -- Unmarshalling

	unmarshall (type, value: STRING): SOAP_VALUE
			-- Unmarshall 'value' according to 'type' using this 
			-- encoding scheme.
		local
			real: REAL_REF
			double: DOUBLE_REF
			qname: Q_NAME
			xsd_type: STRING
		do
			create qname.make_from_qname (type)
			xsd_type := qname.local_name
			if xsd_type.is_equal (Xsd_string) then
				-- xsd:string
				Result := value
			elseif xsd_type.is_equal (Xsd_int) or xsd_type.is_equal (Xsd_short) then
				-- xsd:int / xsd:short
				Result := unmarshall_int (value)
			elseif xsd_type.is_equal (Xsd_float) or xsd_type.is_equal (Xsd_decimal) then
				-- xsd:float / xsd:decimal
				Result := unmarshall_float (value)
			elseif xsd_type.is_equal (Xsd_double) then
				-- xsd:double
				Result := unmarshall_double (value)
			elseif xsd_type.is_equal (Xsd_boolean) then
				-- xsd:boolean
				Result := unmarshall_boolean (value)
			end	
		end

feature {NONE} -- Implementation

	unmarshall_int (value: STRING): ANY
			-- Unmarshall int XML Schema value
		require
			value_exists: value /= Void
		local
			int: INTEGER_REF
		do
			create int
			if value.is_integer then
				int.set_item (value.to_integer)
			else
				int.set_item (0)
			end
			Result := int
		end
		
	unmarshall_boolean (value: STRING): ANY
			-- Unmarshall boolean XML Schema value
		require
			value_exists: value /= Void
		local
			bool: BOOLEAN_REF
		do
			create bool
			if value.is_boolean then
				bool.set_item (value.to_boolean)
			elseif value.is_equal ("1") then
				bool.set_item (True)
			elseif value.is_equal ("0") then	
				bool.set_item (False)
			else
				bool.set_item (False)		
			end
			Result := bool
		end
	
	unmarshall_float (value: STRING): ANY
			-- Unmarshall float XML Schema value
		require
			value_exists: value /= Void
		local
			float: REAL_REF
		do
			create float
			if value.is_real then
				float.set_item (value.to_real)
			else
				float.set_item (0.0)
			end
			Result := float
		end
	
	unmarshall_double (value: STRING): ANY
			-- Unmarshall double XML Schema value
		require
			value_exists: value /= Void
		local
			double: DOUBLE_REF
		do		
			create double
			if value.is_double then
				double.set_item (value.to_double)
			else
				double.set_item (0.0)
			end
			Result := double
		end

feature {NONE} -- Implementation


	sub_code_qname (an_element: GOA_SOAP_ELEMENT; a_sub_code: STRING): STRING
			--	QName for `a_sub_code'
		require
			element_not_void: an_element /= Void
			sub_code_not_empty a_sub_code /= Void and then not a_sub_code.is_empty
		do
			Result := STRING_.concat (an_element.prefix_for_namespace (Ns_name_enc), Prefix_separator)
			Result := STRING_.appended_string (Result, a_sub_code)
		ensure
			result_not_empty: Result /= Void and then not Result.is_empty
		end

	set_validation_fault (a_fault_code: INTEGER; a_sub_code, a_text: STRING; a_node_uri: UT_URI)
			-- Set `validation_fault'.
		require
			text_not_empty: a_text /= Void and then not a_text.is_empty
			valid_code: is_valid_fault_code (a_code)
			node_uri_not_void: a_node_uri /= Void
		do
			validation_fault	:= new_validation_fault (a_fault_code, a_text, a_node_uri)
			was_valid := False
			if a_sub_code /= Void then
				validation_fault.set_sub_code (a_sub_code)
			end
		ensure
			not_valid: not was_valid
		end
		
end -- class GOA_SOAP_XML_ENCODING
