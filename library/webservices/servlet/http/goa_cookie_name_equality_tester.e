note
	description: "Objects that compare cookie names for equality"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "HTTP Servlet API"
	date: "$Date: 2006-11-23 08:38:55 -0800 (Thu, 23 Nov 2006) $"
	revision: "$Revision: 518 $"
	author: "Glenn Maughan <glennmaughan@users>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_COOKIE_NAME_EQUALITY_TESTER

inherit

	KL_EQUALITY_TESTER [GOA_COOKIE]
		redefine
			test
		end

feature -- Status report

	test (v, u: GOA_COOKIE): BOOLEAN
			-- Do 'v' and 'u' have the same cookie name?
		do
			if v = void then
				Result := (u = void)
			elseif u = void then
				Result := False
			else
				Result := v.name.is_equal (u.name)
			end
		end

end -- class GOA_COOKIE_NAME_EQUALITY_TESTER
