indexing
	description: "Objects that represent a value in the SOAP Data Model."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Colin Adams <colin-adams@users.sourceforge.net>"
	copyright: "Copyright (c) 2005 Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

deferred class	GOA_SOAP_VALUE

inherit

	KL_IMPORTED_ANY_ROUTINES

feature -- Access

	is_scalar: BOOLEAN is
			-- Is `Current' a scalar value?
		do
			Result := False
		end

	is_array: BOOLEAN is
			-- Is `Current' an array value?
		do
			Result := False
		end

	is_struct: BOOLEAN is
			-- Is `Current' a struct value?
		do
			Result := False
		end

feature -- Conversion

	as_scalar: GOA_SOAP_SCALAR_VALUE is
			-- `Current' as a scalar value
		require
			scalar_value: is_scalar
		do
		ensure
			same_object: ANY_.same_objects (Result, Current)
		end

	as_array: GOA_SOAP_ARRAY_VALUE is
			-- `Current' as an array value
		require
			array_value: is_array
		do
		ensure
			same_object: ANY_.same_objects (Result, Current)
		end

	as_struct: GOA_SOAP_STRUCT_VALUE is
			-- `Current' as a struct value
		require
			struct_value: is_struct
		do
		ensure
			same_object: ANY_.same_objects (Result, Current)
		end

invariant

	scalar_or_array: is_scalar xor is_array
	scalar_or_struct: is_scalar xor is_struct
	array_or_struct: is_array xor is_struct

end -- class GOA_SOAP_VALUE
