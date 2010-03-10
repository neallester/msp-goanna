indexing
	description: "Compatibility between user and girl friend"
	author: "Neal L. Lester (neal@3dsafety.com)"
	date: "$ May 11, 2001: $"
	revision: "$version 1.0$"

class
	COMPATIBILITY

inherit
	TOPIC_SEQUENCE_DOMAIN_WITH_CHILDREN
		redefine
			initialize, update
		end
	DOMAIN_WITH_PARENT
		redefine
			update
		end
	USER_RELATED

create
	make_with_user_and_parent

feature -- Attributes

	she_is_pregnant : SHE_IS_PREGNANT

	has_a_girlfriend : HAS_A_GIRLFRIEND

	she_drinks : SHE_DRINKS

feature -- Implement deferred features

	create_children is
		do
			create she_is_pregnant.make_with_user_and_parent (current, user)
			create has_a_girlfriend.make_with_user_and_parent (current, user)
			create she_drinks.make_with_user_and_parent (current, user)
			child_list.force_last (she_is_pregnant)
			child_list.force_last (has_a_girlfriend)
			child_list.force_last (she_drinks)
		end

	title : STRING is
		do
			result := text.compatibility
		end

	create_sequence is
		do
			add_element_container (~always_true, "True", page_factory~yes_no (she_is_pregnant))
			add_element_container (~ask_has_a_girlfriend, "Not Pregnant", page_factory~yes_no (has_a_girlfriend))
			add_element_container (~ask_she_drinks, "Not Pregnant and Has a Girlfriend", page_factory~yes_no (she_drinks))	
		end

	ask_has_a_girlfriend : BOOLEAN is
		-- Should the sequence activate the has a girlfriend question
		do
			result := not she_is_pregnant.yes
		end

	ask_she_drinks : BOOLEAN is
		-- Should the sequence active the does she drink question
		do
			result := (not she_is_pregnant.yes) and (has_a_girlfriend.yes)
		end

feature

	initialize is
		do
			precursor {TOPIC_SEQUENCE_DOMAIN_WITH_CHILDREN} 
		end

	update is
		do
			precursor {DOMAIN_WITH_PARENT}
			precursor {TOPIC_SEQUENCE_DOMAIN_WITH_CHILDREN} 
		end

	undo is
		do
		end

	make_with_user_and_parent (new_parent: DOMAIN_WITH_CHILDREN; new_user: like user_anchor) is
		require
			new_user_exists: new_user /= Void
			new_parent_exists: new_parent /= Void
		do
			set_user (new_user)
			make_with_parent (new_parent)
		end

invariant

	valid_she_is_pregnant : she_is_pregnant /= Void
	valid_has_a_girlfriend : has_a_girlfriend /= Void
	valid_she_drinks : she_drinks /= Void
	child_list_has_she_is_pregnant: child_list.has (she_is_pregnant)
	child_list_has_has_a_girlfriend: child_list.has (has_a_girlfriend)
	child_list_has_she_drinks: child_list.has (she_drinks)

end -- class COMPATIBILITY
