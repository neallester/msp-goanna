note
	description: "The client used by the user"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/10"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class
	CLIENT

feature -- Initialization

	make
		do
		end

feature {PAGE} -- Access

	set_code (content : CONTENT_CONTAINER)
		-- Set "code" in content
		deferred
		ensure
			valid_code : content.code /= Void
		end

end -- class CLIENT
