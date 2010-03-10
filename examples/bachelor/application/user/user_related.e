indexing
	description: "Objects that are related to a specific user"
	author: "Neal L. Lester"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"

deferred class
	USER_RELATED

inherit
	USER_ANCHOR
	INITIALIZEABLE

feature

	user: like user_anchor
			-- The user

	set_user (new_user: like user_anchor) is
			-- Set user
		require
			new_user_exists: new_user /= Void
		do
			user := new_user
		ensure
			user_updated: user = new_user
		end

feature {NONE} -- Creation

	make_with_user (new_user: like user_anchor) is
		require
			new_user_exists: new_user /= Void
		do
			set_user (new_user)
			initialize
		ensure
			user_updated: user = new_user
		end

end -- class USER_RELATED