note
	description: "Objects that test QNames for equality."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Colin Adams <colin@colina.demon.co.uk>"
	copyright: "Copyright (c) 2005 Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_QNAME_TESTER

inherit

	KL_EQUALITY_TESTER [GOA_EXPANDED_QNAME]
		redefine
			test
		end

feature -- Status report

	test (v, u: GOA_EXPANDED_QNAME): BOOLEAN
			-- Are `v' and `u' considered equal?
		do
			if v = u then
				Result := True
			elseif v = Void then
				Result := False
			elseif u = Void then
				Result := False
			else
				Result := v.same_qname (u)
			end
		end

end -- class GOA_QNAME_TESTER
