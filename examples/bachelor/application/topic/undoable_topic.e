indexing
	description: "Topics that can be undone"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/14"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class
	UNDOABLE_TOPIC

inherit
	TOPIC
		redefine
			update, initialize, undo
		end

feature -- Undoing

	undo is
		-- Undo the last change to the domain
		do
			if history.count <= 1 then
					-- nothing
			else
				history.start
				history.remove
				copy (history.first)
			end				
		ensure then
			history_copied : equal(history.first,current)
			history_first_is_not_current : history.first /= current
		end


feature {NONE} -- Implementation

	history : LINKED_LIST [like CURRENT]
		-- Previous values of the current topic

	initialize (proposed_user : like user_anchor) is
		do
			precursor (proposed_user)
			create history.make
			initialized := true
			history.put_front (clone(current))
		ensure then
			history.count = 1
		end

	update is
		do
			precursor
			history.put_front(clone(current))
		end

invariant
	valid_history : history /= Void and (not history.empty)

end -- class UNDOABLE_TOPIC
