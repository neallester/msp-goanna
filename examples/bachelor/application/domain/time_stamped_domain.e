indexing
	description: "Implement domains time stamping"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/06/13"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class
	TIME_STAMPED_DOMAIN

inherit
	DOMAIN
	DT_SHARED_SYSTEM_CLOCK

feature

	time_last_modified: DT_DATE_TIME

	initialize is
		do
			time_last_modified := system_clock.date_time_now
			time_initialized := true
		end

	update is
		do
			time_last_modified := system_clock.date_time_now
		ensure then
			time_last_modified_updated: time_last_modified /= old time_last_modified
		end

feature {NONE} -- Implementation

	domain_initialized : BOOLEAN
			-- Has the time_last_modified been initialized

	update_time_last_modified (new_time_last_modified: DT_DATE_TIME) is
		do
			time_last_modified := new_time_last_modified
		end

	time_initialized: BOOLEAN
		-- Has time_last_modified been initialized

	initialized: BOOLEAN is
		do
			result := time_initialized
		end

invariant

	valid_time_last_modified: time_last_modified /= Void
	initialized_implies_time_initialized: initialized implies time_initialized	

end -- class TIME_STAMPED_DOMAIN
