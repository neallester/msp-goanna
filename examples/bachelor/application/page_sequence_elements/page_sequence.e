indexing
	description: "A sequence of pages"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/11"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class
	PAGE_SEQUENCE

 inherit
	PAGE_SEQUENCE_ELEMENT
	SEQUENCE_ELEMENT_FACTORY
	INITIALIZEABLE

feature -- Implement Deferred Features

	create_sequence is
		-- Create the page sequence
		deferred
		end

	initialize is
		do
			if not sequence_initialized then
				create_sequence
				sequence_initialized := true
			end
		end

	initialized: BOOLEAN is
		do
			result := sequence_initialized
		end

	sequence_initialized: BOOLEAN

invariant

	initialized_implies_sequence_initialized: initialized implies sequence_initialized

end -- class PAGE_SEQUENCE