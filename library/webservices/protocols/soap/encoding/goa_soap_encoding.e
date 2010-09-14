note
	description: "Abstract SOAP XML encoding scheme"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class GOA_SOAP_ENCODING

feature -- Status checking

	is_valid_type (a_type: STRING): BOOLEAN
			-- Is `a_type' a known data type in this encoding scheme?
		require
			type_not_empty: a_type /= Void and then not a_type.is_empty
		deferred
		end

	was_valid: BOOLEAN
			-- Was a validation error detected?

	validation_fault: GOA_SOAP_FAULT_INTENT
			-- Fault generated when not `was_valid'.

feature -- Validation

	validate_references (an_element: GOA_SOAP_ELEMENT; unique_identifiers: DS_HASH_TABLE [GOA_SOAP_ELEMENT, STRING]; an_identity: UT_URI)
			-- Validate references from `an_element' and set `was_valid'.
		require
			element_not_void: an_element /= Void
			unique_identifiers_not_void: unique_identifiers /= Void
			identity_not_void: an_identity /= Void
		deferred
		end

	validate_encoding_information (an_element: GOA_SOAP_ELEMENT; unique_identifiers: DS_HASH_TABLE [GOA_SOAP_ELEMENT, STRING]; an_identity: UT_URI)
			-- Validate `an_element' in isolation and set `was_valid'.
		require
			element_not_void: an_element /= Void
			unique_identifiers_not_void: unique_identifiers /= Void
			identity_not_void: an_identity /= Void
		deferred
		end

feature -- Unmarshalling

	unmarshalled_value (a_type, a_value: STRING): GOA_SOAP_VALUE
			-- Unmarshall `a_value' according to `a_type' using the 
			-- current encoding scheme.
		require
			type_not_empty: a_type /= Void and then not a_type.is_empty
			value_exists: a_value /= Void
		deferred
		ensure
			value_unmarshalled: Result /= Void
		end

feature -- Marshalling
		
invariant
	
	validate: was_valid implies validation_fault = Void
	
end -- class GOA_SOAP_ENCODING
