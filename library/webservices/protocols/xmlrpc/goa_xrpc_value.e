note
	description: "Objects that represent an XML-RPC call and response parameter values."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "XML-RPC"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

deferred class GOA_XRPC_VALUE

inherit
	
	GOA_XRPC_ELEMENT
	
feature -- Access

	type: STRING
			-- Type of parameter (used as the tag value)

feature -- Conversion

	as_object: ANY
			-- Return value as an object. ie, extract the actual 
			-- object value from the XRPC_VALUE.
		deferred
		end
		
invariant
	
	type_exists: unmarshall_ok implies type /= Void
		
end -- class GOA_XRPC_VALUE
