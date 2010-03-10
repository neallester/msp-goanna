indexing
	description: "User related domains that also have children"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/06/13"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class
	USER_RELATED_DOMAIN_WITH_CHILDREN

inherit
	USER_RELATED
	DOMAIN_WITH_CHILDREN
		redefine
			receive_child_notification,
			child_list,
			process_child_notification
		end

feature

	receive_child_notification (child: USER_RELATED_DOMAIN_WITH_PARENT) is
		do
			precursor (child)
		end
	
	child_list: DS_LINKED_LIST [USER_RELATED_DOMAIN_WITH_PARENT]

	process_child_notification (child: USER_RELATED_DOMAIN_WITH_PARENT) is
		do
			precursor (child)
		end

end -- class USER_RELATED_DOMAIN_WITH_CHILDREN
