note
	description: "Does the user a girlfriend?"
	author: "Neal L. Lester (neal@3dsafety.com)"
	date: "$ May 14, 2001: $"
	revision: "$version 1.0$"

class
	HAS_A_GIRLFRIEND

inherit
	YES_NO

create
	make_with_user_and_parent

feature

	question : STRING
		do
			result := text.has_a_girlfriend
		end

	title : STRING = ""

end -- class HAS_A_GIRLFRIEND
