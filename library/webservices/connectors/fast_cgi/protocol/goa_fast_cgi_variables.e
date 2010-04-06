indexing
	description: "Fast CGI variable constants"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI protocol"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v1 (see forum.txt)."

class GOA_FAST_CGI_VARIABLES

inherit

	GOA_CGI_VARIABLES

feature

	request_uri_var: STRING is "REQUEST_URI"

end -- class GOA_FAST_CGI_VARIABLES
