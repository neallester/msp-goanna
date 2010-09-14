note
	description: "SOAP Action feature "
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Colin Adams <colin@colina.demon.co.uk>"
	copyright: "Copyright (c) 2005 Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class	GOA_SOAP_ACTION_FEATURE

inherit

	GOA_SOAP_CONSTANTS
	
	GOA_XML_SCHEMA_CONSTANTS

create

	make

feature {NONE} -- Initialization

	make (a_value: UT_URI)
		require
			value_exists: a_value /= Void
		local
			a_name: UT_URI
			an_any_uri_name: GOA_SOAP_EXPANDED_NAME
		do
			create a_name.make (Action_feature_name)
			init (a_name)
			create a_name.make (Action_feature_property_name)
			create an_any_uri_name.make (Ns_name_xs, Xsd_anyuri)
			create action.make (a_name, a_value.full_reference, an_any_uri_name)
		end

feature -- Access

	action: GOA_SOAP_PROPERTY
			-- Action

invariant

	action_exists: action /= Void

end -- class GOA_SOAP_ACTION_FEATURE

