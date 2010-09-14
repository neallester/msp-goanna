note
	description: "SOAP features (including MEPs) "
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Colin Adams <colin@colina.demon.co.uk>"
	copyright: "Copyright (c) 2005 Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

deferred class	GOA_SOAP_FEATURE

feature {NONE} -- Initialization

	init (a_name: like name)
			--	Establish invariant (to be called from `make'.
		require
			name_exists: a_name /= Void
		do
			name := a_name
		ensure
			name_set: name = a_name
		end
	
feature -- Access

	name: UT_URI
			-- Name of feature

invariant

	name_exists: name /= Void

end -- class GOA_SOAP_FEATURE

