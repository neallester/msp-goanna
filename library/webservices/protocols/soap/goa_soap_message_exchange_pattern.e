note
	description: "SOAP MEPs"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Colin Adams <colin@colina.demon.co.uk>"
	copyright: "Copyright (c) 2005 Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

deferred class	GOA_SOAP_MESSAGE_EXCHANGE_PATTERN

inherit

	GOA_SOAP_CONSTANTS

	GOA_XML_SCHEMA_CONSTANTS

feature {NONE} -- Initialization

	make (a_role: UT_URI)
			-- Establish invariant.
		require
			role_exists: a_role /= Void
		deferred
		end

	init (a_name: UT_URI; a_role: UT_URI)
			--	Establish invariant (to be called from `make')..
		require
			name_exists: a_name /= Void
			role_exists: a_role /= Void
		local
			a_uri: UT_URI
			an_any_uri_name: GOA_SOAP_EXPANDED_NAME
		do
			create an_any_uri_name.make (Ns_name_xs, Xsd_anyuri)

			create a_uri.make (Mep_name_property_name)
			create name.make (a_uri, a_name.full_reference, an_any_uri_name)

			create a_uri.make (Mep_failure_reason_property_name)
			create failure_reason.make (a_uri, Mep_no_failure, an_any_uri_name)

			create a_uri.make (Mep_role_property_name)
			create role.make (a_uri, a_role, an_any_uri_name)

			create a_uri.make (Mep_state_property_name)
			create state.make (a_uri, Mep_state_init, an_any_uri_name)
		end

feature -- Access

	name: GOA_SOAP_PROPERTY
			-- Name

	failure_reason: GOA_SOAP_PROPERTY
			-- Reason for failure relative to `name.value'

	role: GOA_SOAP_PROPERTY
			-- Role of SOAP node relative to `name.value'

	state: GOA_SOAP_PROPERTY
			-- State of exchange

invariant

	name_exists: name /= Void
	failure_reason_exists: failure_reason /= Void
	role_exists: role /= Void
	state_exists: state /= Void
	
end -- class GOA_SOAP_MESSAGE_EXCHANGE_PATTERN

