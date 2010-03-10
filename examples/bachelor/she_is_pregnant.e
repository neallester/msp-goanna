indexing
	description : "Is the user's girlfriend pregnant?"
	author: "Neal L. Lester (neal@3dsafety.com)"
	date: "$ May 14, 2001: $"
	revision: "$version 1.0$"

class
	SHE_IS_PREGNANT

inherit
	YES_NO

create
	make_with_user_and_parent

feature

	question : STRING is
		do
			result := text.she_is_pregnant
		end

	title : STRING is ""

end -- class SHE_IS_PREGNANT
