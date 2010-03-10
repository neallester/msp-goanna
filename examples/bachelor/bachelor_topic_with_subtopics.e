indexing
	description: "Topics for bachelor advisor application with subtopics"
	author: "Neal L. Lester (neal@3dsafety.com)"
	date: "$ May 11, 2001: $"
	revision: "$version 1.0$"

deferred class
	BACHELOR_TOPIC_WITH_SUBTOPICS

inherit
	BACHELOR_TOPIC
	TOPIC_WITH_SUBTOPICS_BRANCHING_SEQUENCE
		redefine
			undo, subtopic_list
		end

feature

	subtopic_list : LINKED_LIST [BACHELOR_TOPIC]

	undo is
		do
			from
				subtopic_list.start
			until
				subtopic_list.after
			loop
				subtopic_list.item.undo
				subtopic_list.forth
			end	
		end

	reset is
		do
			from
				subtopic_list.start
			until
				subtopic_list.after
			loop
				subtopic_list.item.reset
				subtopic_list.forth
			end	
		end

end -- class BACHELOR_TOPIC_WITH_SUBTOPICS