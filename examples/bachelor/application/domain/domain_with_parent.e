indexing
	description: "Domains that have parent domains"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/06/13"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class
	DOMAIN_WITH_PARENT

inherit
	DOMAIN

feature 

	parent : DOMAIN_WITH_CHILDREN
			-- The parent of this domain

	parent_initialized : BOOLEAN is
			-- Has the parent been initialized
		do
			result := parent.initialized
		end

	update is
		do
			parent.receive_child_notification (current)
		ensure then
			parent_time_last_modified_equals_time_last_modified: parent.time_last_modified = time_last_modified

		end

feature {NONE}

	make_with_parent (new_parent: DOMAIN_WITH_CHILDREN) is
		do
			parent := new_parent
			initialize
		end

invariant

	valid_parent: parent /= Void

end -- class DOMAIN_WITH_PARENT
