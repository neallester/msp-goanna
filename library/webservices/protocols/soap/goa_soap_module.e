note
	description: "SOAP modules"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Colin Adams <colin@colina.demon.co.uk>"
	copyright: "Copyright (c) 2005 Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

deferred class	GOA_SOAP_MODULE

feature {NONE} -- Initialization

	make
			-- Establish invariant.
		deferred
		end

	init (a_name: like name; a_value: like value; a_schema_type: like schema_type)
			--	Establish invariant (to be called from `make')..
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

	provided_features: DS_SET [UT_URI]
			-- Names of provided features
		deferred
		end

	header_names: DS_SET [GOA_EXPANDED_QNAME]
			-- Header blocks which implement `Current'
		deferred
		end

	property_names: DS_SET [STRING]
			-- Names of properties used
		deferred
		end
	
invariant

	name_exists: name /= Void
	provided_features_exist: provided_features /= Void
	header_names_exist: header_names /= Void
	property_names_exist: property_names /= Void

end -- class	GOA_SOAP_MODULE

