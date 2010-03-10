indexing
	description: "Undoable topics that are also branching_sequences"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/11"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class
	UNDOABLE_TOPIC_BRANCHING_SEQUENCE

inherit
	UNDOABLE_TOPIC
		redefine
			initialize
		end
	BRANCHING_PAGE_SEQUENCE

feature

	initialize (new_user : like user_anchor) is
		do
			create_sequence
			precursor (new_user)
		end

end -- class UNDOABLE_TOPIC_BRANCHING_SEQUENCE
