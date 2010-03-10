indexing
	description: "Page sequences implementing a branching behavior"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/11"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class
	BRANCHING_PAGE_SEQUENCE

inherit
	ANY
		PAGE_SEQUENCE

feature -- Implement deferred features
		
	page : PAGE is
		do
			result := current_element.page
		end

	start is
		do
			page_sequence.start
			find_next_element
			if not done then
				current_element.start
			end
			recreate_dirty_page
		end

	forth is
		do
			current_element.forth
			if current_element.done then
				from
				until 
					done or not current_element.done
				loop
					page_sequence.forth
					find_next_element
					if not done then
						current_element.start
					end
				end
			end
			recreate_dirty_page
		end

	done : BOOLEAN is
		do
			result := page_sequence.after
		end

	active_chain  : LINKED_LIST [ELEMENT_CONTAINER] is
		do
			result := current_element.active_chain
			result.put_front (page_sequence.item)
		end

	restore_chain (chain : LINKED_LIST [ELEMENT_CONTAINER]) is
		local
			new_chain : LINKED_LIST [ELEMENT_CONTAINER]
		do
			new_chain := clone(chain)
			new_chain.start
			page_sequence.start
			from
			until
				page_sequence.item = new_chain.item
			loop
				page_sequence.forth
			end
			if not page_sequence.after then
				new_chain.start
				new_chain.remove
				current_element.restore_chain (new_chain)
			end
			recreate_dirty_page
		end

	context : STRING is
		do
			if current_element = Void then
				result := title
			else
				if current_element.context.is_empty then
					result := title
				else
					if title.is_empty then
						result := current_element.context
					else
						result := title + " : " + current_element.context
					end
				end
			end
		end

feature {EXPOSURE}

	page_sequence : LINKED_LIST [ELEMENT_CONTAINER]
		-- A sequence of pages

feature {NONE} -- Implementation

	recreate_dirty_page is
		-- Recreates (calls the function) for a page that is dirty (has already been built)
		do
			if not done then
				if current_element.page_is_dirty then
					current_function.call([])
				end
			end
		end


	current_element : PAGE_SEQUENCE_ELEMENT is
			-- The current page_sequence_element in the page_sequence
		local
			a_page : PAGE
		do
			if done then
				result := void
			else
				if current_function.last_result = void then
					current_function.call([])
				end
				result := current_function.last_result
			end
		end

	always_true : BOOLEAN is
		do
			result := True
		ensure
			result_true : result
		end

	always_false : BOOLEAN is
		do
			result := not True
		ensure
			result_false : not result
		end

	find_next_element is
		-- Find the next valid element in sequence
		local
		do
			if not force_evaluation then
				from
				until
					page_sequence.after or page_sequence.item.branch_condition
				loop
					page_sequence.forth
				end
			end
		end

	current_function : FUNCTION[SEQUENCE_ELEMENT_FACTORY,TUPLE,PAGE_SEQUENCE_ELEMENT] is
		require
			not_done : not done
		do
			result := page_sequence.item.element
		end

	add_element_container (new_condition : FUNCTION [PAGE_SEQUENCE_ELEMENT, TUPLE, BOOLEAN] ; new_description : STRING; new_element : FUNCTION[SEQUENCE_ELEMENT_FACTORY,TUPLE,PAGE_SEQUENCE_ELEMENT]) is
		-- Adds a new element_container to the end of sequence
		require
			valid_new_condition : new_condition /= Void
			valid_new_description : new_description /= void
			valid_new_element : new_element /= Void
		local
			new_container : ELEMENT_CONTAINER
		do
			if page_sequence = Void then
				create page_sequence.make
			end
			create new_container.make (new_condition, new_description, new_element)
			page_sequence.force (new_container)
		end

	force_evaluation : BOOLEAN

invariant

	valid_page_sequence : page_sequence /= Void

end -- class BRANCHING_PAGE_SEQUENCE
