indexing
	description: "Does the user's girlfriend drink?"
	author: "Neal L. Lester (neal@3dsafety.com)"
	date: "$ May 14, 2001: $"
	revision: "$version 1.0$"

class
	SHE_DRINKS

inherit
	YES_NO

create
	make_with_user_and_parent

feature

	question : STRING is
		do
			result := text.she_drinks
		end

	title : STRING is
		do
			result := text.her_habits
		end

end -- class SHE_DRINKS
