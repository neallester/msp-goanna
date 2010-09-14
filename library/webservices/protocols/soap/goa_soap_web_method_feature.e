note
	description: "SOAP Web Method feature "
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Colin Adams <colin@colina.demon.co.uk>"
	copyright: "Copyright (c) 2005 Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class	GOA_SOAP_WEB_METHOD_FEATURE

create

	make

feature {NONE} -- Initialization

	make (a_method: STRING)
		require
			valid_method: a_method /= Void and then is_valid_method (a_method)
		local
			a_name: UT_URI
		do
			create a_name.make (Web_method_feature_name)
			init (a_name)
			create a_name.make (Web_method_feature_property_name)
			create method.make (a_name, a_method, Void)
		end

feature -- Access

	method: GOA_SOAP_PROPERTY
			-- Web method in use

	is_valid_method (a_method: STRING): BOOLEAN
			--		 Is `a_method' a valid method name?
		require
			method_exists: a_method /= Void
		do
			Result := STRING_.same_string (a_method, Get_method)
				or else STRING_.same_string (a_method, Post_method)
				or else STRING_.same_string (a_method, Put_method)
				or else STRING_.same_string (a_method, Delete_method)
		end

invariant

	method_exists: method /= Void
	valid_method: is_valid_method (method.value)

end -- class GOA_SOAP_WEB_METHOD_FEATURE

