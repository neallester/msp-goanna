note
	description: "Topics that include one or more subtopics"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/11"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class
	TOPIC_WITH_SUBTOPICS

inherit

	TOPIC
		redefine
			initialize
		end


Feature {TOPIC} -- Implementation

	registered (subtopic : TOPIC) : BOOLEAN
		-- Is the subtopic registered in current
		require
			valid_subtopic : subtopic /= Void
		do
			result := subtopic_list.has(subtopic)
		end

feature {NONE} -- Implementation

	subtopic_list : LINKED_LIST [TOPIC]
		-- list of the subdomains in this exposure

	initialize (proposed_user : like user_anchor)
		do
			precursor (proposed_user)
			Create subtopic_list.make
			add_subtopics
		end

	add_subtopics
		-- Add subtopics to the sub_topic list
		deferred
		end

invariant
	
	valid_subtopic_list : subtopic_list /= Void

end -- class TOPIC_WITH_SUBTOPICS
