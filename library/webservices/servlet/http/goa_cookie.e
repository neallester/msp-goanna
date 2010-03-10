indexing
	description: "Objects that represent a small amount of information sent %
		%by a servlet to a Web browser, saved by the browser, and later sent %
		%back to the server."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "HTTP Servlet API"
	date: "$Date: 2006-09-22 09:15:34 -0700 (Fri, 22 Sep 2006) $"
	revision: "$Revision: 511 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_COOKIE

inherit

	DT_SHARED_SYSTEM_CLOCK
		export
			{NONE} all
			{ANY} is_equal -- for SE 1.0
		end

create

	make

feature -- Initialization

	make (new_name, new_value: STRING) is
			-- Create a new cookie with 'new_name' and 'new_value'
		require
			name_not_reserved_word: not is_reserved_cookie_word (new_name)
		do
			name := new_name
			value := new_value
			set_max_age (-1)
			set_version (Default_version)
		end

feature -- Access

	name: STRING
			-- Name of this cookie

	value: STRING
			-- Value of this cookie

	comment: STRING
			-- Optional cookie comment

	domain: STRING
			-- Optional dDomain that will see cookie

	max_age: INTEGER
			-- Optional maximum age of this cookie, -1 if no expiry.

	path: STRING
			-- Optional URL that will see cookie

	secure: BOOLEAN
			-- Optional use SSL?

	version: INTEGER
			-- Version

feature -- Status setting

	set_comment (new_comment: like comment) is
			-- Set 'comment' to 'new_comment'
		require
			new_comment_exists: new_comment /= Void
		do
			comment := new_comment.twin
		end

	set_domain (new_domain: like domain) is
			-- Set 'domain' to 'new_domain'
		require
			new_domain_exists: new_domain /= Void
		do
			domain := new_domain.twin
		end

	set_max_age (new_max_age: like max_age) is
			-- Set 'max_age' to 'new_max_age'
		do
			max_age := new_max_age
		end

	set_path (new_path: like path) is
			-- Set 'path' to 'new_path'
		require
			new_path_exists: new_path /= Void
		do
			path := new_path.twin
		end

	set_secure (flag: like secure) is
			-- Set 'secure' to 'flag'
		do
			secure := flag
		end

	set_version (new_version: like version)	is
			-- Set 'version' to new_version
		do
			version := new_version
		end

feature -- Validation

	is_reserved_cookie_word (word: STRING): BOOLEAN is
			-- Is 'word' a reserved cookie word?
		require
			word_exists: word /= Void
		local
			lower_word: STRING
		do
			lower_word := word.twin
			lower_word.to_lower
			Result := lower_word.is_equal ("comment")
				or lower_word.is_equal ("discard")
				or lower_word.is_equal ("domain")
				or lower_word.is_equal ("expires")
				or lower_word.is_equal ("max-age")
				or lower_word.is_equal ("path")
				or lower_word.is_equal ("secure")
				or lower_word.is_equal ("version")
		end

feature -- Conversion

	header_string: STRING is
			-- Return string representation of this cookie suitable for
			-- a request header value. This routine formats the cookie using
			-- version 0 of the cookie spec (RFC 2109).
			-- See also http://www.netscape.com/newsref/std/cookie_spec.html
		do
			create Result.make (50)
			Result.append_string (name)
			Result.append_string (Name_value_separator)
			Result.append_string (value)
			-- version
			Result.append_string (Term_separator)
			Result.append_string (Version_label)
			Result.append_string (Name_value_separator)
			Result.append_string (version.out)
			-- optional comment
			if comment /= Void and then not comment.is_empty then
				Result.append_string (Term_separator)
				Result.append_string (Comment_label)
				Result.append_string (Name_value_separator)
				Result.append_string (comment)
			end
			-- optional expires (depends on version)
			if max_age >= 0 then
				Result.append_string (Term_separator)
				Result.append_string (Expires_label)
				Result.append_string (Name_value_separator)
				if max_age = 0 then
					Result.append_string (Expired_date)
				else
					Result.append_string (max_age_to_date (max_age))
				end
			end
			-- optional domain
			if domain /= Void and then not domain.is_empty then
				Result.append_string (Term_separator)
				Result.append_string (Domain_label)
				Result.append_string (Name_value_separator)
				Result.append_string (domain)
			end
			-- optional path
			if path /= Void and then not path.is_empty then
				Result.append_string (Term_separator)
				Result.append_string (Path_label)
				Result.append_string (Name_value_separator)
				Result.append_string (path)
			end
			-- optional secure, no value
			if secure then
				Result.append_string (Term_separator)
				Result.append_string (Secure_label)
			end
		end

	Comment_label: STRING is "Comment"
	Discard_label: STRING is "Discard"
	Domain_label: STRING is "Domain"
	Expires_label: STRING is "Expires"
	Max_age_label: STRING is "Max-Age"
	Path_label: STRING is "Path"
	Secure_label: STRING is "secure"
	Version_label: STRING is "Version"

	Name_value_separator: STRING is "="
	Term_separator: STRING is "; "

	Expired_date: STRING is "Tue, 01-Jan-1970 00:00:00 GMT"

	Default_version: INTEGER is 0

	max_age_to_date (age: INTEGER): STRING is
			-- Convert max_age to a date
		local
			date: DT_DATE_TIME
			formatter: GOA_DATE_FORMATTER
		do
			date := system_clock.date_time_now
			debug ("cookie_parsing")
				print ("Cookie expiry date today: " + date.out + "%R%N")
			end
			date.add_seconds (age)
			debug ("cookie_parsing")
				print ("Cookie expiry date max age: " + date.out + "%R%N")
			end
			create formatter
			Result := formatter.format_fixed_variant (date)
			debug ("cookie_parsing")
				print ("Cookie expiry date formatted: " + Result + "%R%N")
			end
		end

invariant

	name_exists: name /= Void
	value_exists: value /= Void

end -- class GOA_COOKIE
