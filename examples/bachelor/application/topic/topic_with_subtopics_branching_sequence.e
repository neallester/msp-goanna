indexing
	description: "Topics with subtopics that are also branching_page_sequences"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/11"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class
	TOPIC_WITH_SUBTOPICS_BRANCHING_SEQUENCE

inherit
	TOPIC_WITH_SUBTOPICS
		redefine
			initialize
		end

	BRANCHING_PAGE_SEQUENCE

feature

	initialize (proposed_user : like user_anchor) is
		do
			precursor (proposed_user)
			create_sequence
		end

end -- class TOPIC_WITH_SUBTOPICS_BRANCHING_SEQUENCE
