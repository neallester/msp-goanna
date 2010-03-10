indexing
	description: "An element in a page sequence"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/11"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class

	PAGE_SEQUENCE_ELEMENT

inherit

	PROCESSOR_HOST
	USER_ANCHOR

feature {PAGE_SEQUENCE_ELEMENT, USER}

	page_factory : PAGE_FACTORY is
		-- Where pages come from
		once
			create result.make
		end
	
	page_is_dirty : BOOLEAN
		-- True if a page has already been displayed; false if not a page

	context : STRING is
		-- Plain text describing the context (the sequence of page_sequence_elements) that has generated the current page
		deferred
		end

feature {PAGE_SEQUENCE_ELEMENT, PAGE_FACTORY, CONTENT_CONTAINER, TO_DO}

	text : TEXT_LIST is
		-- Text used as content on the page
		deferred
		end

	title : STRING is
		-- Plain text title of the page_sequence_element
		deferred
		end

	user: like user_anchor is
		deferred
		end

feature {PAGE_SEQUENCE_ELEMENT, PAGE_SEQUENCER, USER}

	active_chain : LINKED_LIST [ELEMENT_CONTAINER] is
		-- The chain of page_sequence_elements linking session with active_page
		require
			not_done : not done
		deferred
		ensure
		end

	page : PAGE is
		-- The current page in the sequence
		require
			not_done : not done

		deferred
		ensure
			valid_result : result /= Void
		end

	start is
		-- Go to first (valid) page in the sequence
		deferred
		end

	forth is
		-- Go to the next (valid) page in the sequence
		require
			not_done : not done
		deferred
		end

	done : BOOLEAN is
		-- The last element in this sequence has been displayed
		deferred
		end

	restore_chain (chain : LINKED_LIST [ELEMENT_CONTAINER]) is
		-- Restore the current sequence_element to state given by chain
		require
			valid_chain : chain /= Void
		deferred
		end

feature {NONE} -- Implementation

	null_processor is
		-- do nothing
		do
		end

invariant

	valid_page_factory : page_factory /= Void
	valid_text : text /= Void
	page_is_dirty_implies_page : page_is_dirty implies current.conforms_to (page)

end -- class PAGE_SEQUENCE_ELEMENT