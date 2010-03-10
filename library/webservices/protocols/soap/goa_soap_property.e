indexing
	description: "SOAP properties"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Colin Adams <colin@colina.demon.co.uk>"
	copyright: "Copyright (c) 2005 Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class	GOA_SOAP_PROPERTY

create

	make

feature {NONE} -- Initialization

	make (a_name: like name; a_value: like value; a_schema_type: like schema_type) is
			--	Establish invariant.
		require
			name_exists: a_name /= Void
			value_exists: a_value /= Void
		do
			name := a_name
			value := a_value
			schema_type := a_schema_type
		ensure
			name_set: name = a_name
			value_set: value = a_value
			schema_type_set: schema_type = a_schema_type
		end

feature -- Access

	name: UT_URI
			-- Name of module

	value: STRING
			-- Value

	schema_type: GOA_SOAP_EXPANDED_NAME
			-- Schema type of `value' (optional)
	
invariant

	name_exists: name /= Void
	value_exists: value /= Void

end -- class GOA_SOAP_PROPERTY

