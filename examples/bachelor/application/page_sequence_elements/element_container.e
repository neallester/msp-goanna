indexing
	description: "Containers of page_sequence_elements for use in page_sequences"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/11"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	ELEMENT_CONTAINER

create
	make

feature -- Attributes

	branch_condition : BOOLEAN is
		-- If true, element is incorporated in sequence, if false, element is skipped
		do
			branch_function.call ([])
			result := branch_function.last_result
		end

	branch_function : FUNCTION [PAGE_SEQUENCE_ELEMENT, TUPLE, BOOLEAN]
		-- The function used to determine branch_condition

	condition_description : STRING
		-- A text representation of the branch condition

	element : FUNCTION[SEQUENCE_ELEMENT_FACTORY,TUPLE,PAGE_SEQUENCE_ELEMENT]
		-- A function that will return a page_sequence_element

feature {NONE} -- creation

	make (new_condition : FUNCTION [PAGE_SEQUENCE_ELEMENT, TUPLE, BOOLEAN]
; new_description : STRING ; new_element : FUNCTION[SEQUENCE_ELEMENT_FACTORY,TUPLE,PAGE_SEQUENCE_ELEMENT]) is
		require
			valid_new_condition : new_condition /= Void
			valid_new_description : new_description /= Void
			valid_new_element : new_element /= Void
		do
			branch_function := new_condition
			condition_description := new_description
			element := new_element
		end

invariant
	valid_branch_function : branch_function /= Void
	valid_condition_description : condition_description /= Void
	valid_element : element /= Void

end -- class ELEMENT_CONTAINER
