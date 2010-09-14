note
	description: "Proxy for calculator"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Colin Adams <colin-adams@users.sourceforge.net>"
	copyright: "Copyright (c) 2005 Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)."
	
class	CALCULATOR_SERVICE_PROXY

inherit

	GOA_SERVICE_PROXY

create

	make

feature -- Creation

	new_tuple (a_name: STRING): TUPLE
			--	Tuple of default-valued arguments to pass to call `a_name'.
		local
			two_doubles: TUPLE [DOUBLE_REF, DOUBLE_REF]
		do
			create two_doubles; Result := two_doubles
		end

end -- class CALCULATOR_SERVICE_PROXY
