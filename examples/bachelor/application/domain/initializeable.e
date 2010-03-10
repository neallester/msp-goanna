indexing
	description: "The abstract notion of objects that require initialization"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/06/13"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class
	INITIALIZEABLE

feature

	initialize is
		deferred
		end

	initialized: BOOLEAN is
			-- Has the domain been initialized
		deferred
		end

invariant

	initialized: initialized


end -- class INITIALIZEABLE
