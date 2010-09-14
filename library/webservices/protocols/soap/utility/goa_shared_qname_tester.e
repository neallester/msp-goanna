note
	description: "Objects that provide shared access to a qname tester."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Colin Adams <colin@colina.demon.co.uk>"
	copyright: "Copyright (c) 2005 Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_SHARED_QNAME_TESTER

	
feature -- Access

	qname_tester: GOA_QNAME_TESTER
			-- QName tester
		once
			create Result
		ensure
			qname_tester_not_void: Result /= Void
		end

end -- class GOA_SHARED_QNAME_TESTER
