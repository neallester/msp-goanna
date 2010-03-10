indexing
	description: "Parameters that may be displayed as html input elements"
	author: "Neal L Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	copyright: "(c) Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

deferred class
	GOA_INPUT_PARAMETER

inherit
	
	GOA_REQUEST_PARAMETER
	GOA_SCHEMA_FACILITIES
	
feature
	
	size: INTEGER is
			-- The size of the input element
		deferred
		end
		
	maxlength: INTEGER is 
			-- The maxlength for the input element
		once
			Result := 0
		end
	
	type: STRING is
			-- Type of the input
		once
			Result := text_input_type
		end
		
	add_to_document (xml: GOA_COMMON_XML_DOCUMENT_EXTENDED; processing_result: REQUEST_PROCESSING_RESULT; suffix: INTEGER) is
		do
			xml.add_input_element (input_class (processing_result, suffix), full_parameter_name (name, suffix), type, yes_no_string_for_boolean (is_disabled (processing_result, suffix)), maxlength_string_for_integer (maxlength), size.out, display_value (processing_result, suffix))
		end
		
	ok_to_add (xml: GOA_COMMON_XML_DOCUMENT_EXTENDED): BOOLEAN is
		do
			Result := xml.ok_to_add_element_or_text (xml.input_element_code)
		end

feature -- Input Types

	text_input_type: STRING is "text"
	
	password_input_type: STRING is "password"
		
	valid_input_types: DS_LINKED_LIST [STRING] is
			-- Valid input types for a PAGE_XML_DOCUMENT input_element
		once
			create Result.make_equal
			Result.force_last (text_input_type)
			Result.force_last (password_input_type)
		end
		
	is_valid_input_type (new_type: STRING): BOOLEAN is
			-- Is new_type a valid_input_type
		require
			valid_new_type: new_type /= Void
		do
			Result := valid_input_types.has (new_type)
		end

invariant
	
	valid_type: is_valid_input_type (type)

end -- class GOA_INPUT_PARAMETER
