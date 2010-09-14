note
	description: "Objects that represent a value in the SOAP Data Model."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Colin Adams <colin-adams@users.sourceforge.net>"
	copyright: "Copyright (c) 2005 Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

deferred class	GOA_SOAP_SCALAR_VALUE

inherit

	GOA_SOAP_VALUE
		redefine
			is_scalar, as_scalar
		end

feature -- Access

	is_scalar: BOOLEAN
			-- Is `Current' a scalar value?
		do
			Result := True
		end
	
feature -- Conversion

	as_scalar: GOA_SOAP_SCALAR_VALUE
			-- `Current' as a scalar value
		do
			Reuslt := Current
		end

invariant


end -- class GOA_SOAP_SCALAR_VALUE
