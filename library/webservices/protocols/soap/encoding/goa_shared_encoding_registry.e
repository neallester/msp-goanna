note
	description: "Shared encoding registry"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class	GOA_SHARED_ENCODING_REGISTRY

feature -- Access

	encodings: REGISTRY [GOA_SOAP_ENCODING]
			-- Shared encoding registry
		once
			create Result.make
		end

end -- class GOA_SHARED_ENCODING_REGISTRY
