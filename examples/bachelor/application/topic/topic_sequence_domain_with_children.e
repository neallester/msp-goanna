note
	description: "Topics that are page sequences and domain_with_children"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/06/13"
	revision: "$Revision: 513 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class
	TOPIC_SEQUENCE_DOMAIN_WITH_CHILDREN

inherit
	TOPIC
	DOMAIN
	TIME_STAMPED_DOMAIN
		redefine
			update, initialize, initialized
		end
	DOMAIN_WITH_CHILDREN
		redefine
			initialize, initialized
		end
	BRANCHING_PAGE_SEQUENCE
		redefine
			initialize, initialized
		end 

feature

	initialize
		do
			precursor {TIME_STAMPED_DOMAIN} 
			precursor {DOMAIN_WITH_CHILDREN} 
			precursor {BRANCHING_PAGE_SEQUENCE} 
		end

	update
		do
			precursor {TIME_STAMPED_DOMAIN} 
		end

	initialized: BOOLEAN
		do
			result := precursor {TIME_STAMPED_DOMAIN}  and precursor {DOMAIN_WITH_CHILDREN} and precursor {BRANCHING_PAGE_SEQUENCE} 
		end

end -- class TOPIC_SEQUENCE_DOMAIN_WITH_CHILDREN
