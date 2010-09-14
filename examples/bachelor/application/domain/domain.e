note
	description: "The fully deferred version of objects that represent a domain in the application model"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/06/13"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class
	DOMAIN

inherit
	PROCESSOR_HOST
	INITIALIZEABLE

feature -- Attributes

	time_last_modified: DT_DATE_TIME
			-- The date and time the domain was last modified
		deferred
		end

	evaluated: BOOLEAN
			-- This domain has been evaluated
		deferred
		end

feature -- Services

	update
			-- Notification that the domain state has changed
		deferred
		end

	reset
			-- Reset the domain to the default state
		deferred
		end

	update_time_last_modified (new_time_last_modified: DT_DATE_TIME)
		deferred
		ensure
			time_last_modified_updated: time_last_modified = new_time_last_modified
		end


end -- class DOMAIN
