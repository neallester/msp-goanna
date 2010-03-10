indexing
	description: "User Preferences"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/10"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	USER_PREFERENCE

create
	make

feature -- Access

	language : TEXT_LIST is
		-- A list of all text used as content by the system
		-- To do; provide mechanism for changing the list for multi-language support
		once
			Create Result.make
		end

	client : CLIENT is
		-- The client (e.g. browser) used by the user
		-- To do; provide support for multiple client types; allowing browser specific code, etc.
		local
			new_client : HTML_CLIENT
		once
			create new_client.make
			result := new_client
		end

	image_location : STRING is "600_800"
		-- The subdirectory where images are served from.
		-- To do; provide support for multiple image directories to support selecting different images
		-- Based on user's monitor size and/or bandwidth

feature {NONE} -- Initialization

	make is
		do
		end

invariant

	valid_language : language /= Void
	valid_client : client /= Void
	valid_image_location : image_location /= Void

end -- class USER_PREFERENCE
