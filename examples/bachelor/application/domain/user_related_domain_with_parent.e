indexing
	description: "Domains that are related to a user and also have parent"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/06/13"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class
	USER_RELATED_DOMAIN_WITH_PARENT

inherit
	USER_RELATED
	DOMAIN_WITH_PARENT
		redefine
			parent, make_with_parent
		end

feature -- Creation

	parent: USER_RELATED_DOMAIN_WITH_CHILDREN

	make_with_parent (new_parent: USER_RELATED_DOMAIN_WITH_CHILDREN) is
		do
			set_user (new_parent.user)
			precursor (new_parent)
		end

end -- class USER_RELATED_DOMAIN_WITH_PARENT
