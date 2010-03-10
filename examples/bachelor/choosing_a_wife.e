indexing
	description: "Advice on choosing a wife"
	author: "Neal L. Lester (neal@3dsafety.com)"
	date: "$ May 11, 2001: $"
	revision: "$version 1.0$"

class
	CHOOSING_A_WIFE

inherit

	TOPIC_SEQUENCE_DOMAIN_WITH_CHILDREN
	USER_RELATED

create
	make_with_user

feature -- Attributes

	compatibility : COMPATIBILITY

	he_drinks : HE_DRINKS

	compatibility_sequence : PAGE_SEQUENCE is
		do
			result := compatibility
		end

feature -- Implement deferred features

	create_children is
		do
			create compatibility.make_with_user_and_parent (current, user)
			create he_drinks.make_with_user_and_parent (current, user)
			child_list.force_last (compatibility)
			child_list.force_last (he_drinks)
		end

	title : STRING is
		do
			if user.personal_information.name.is_empty then
				result := text.choosing_a_wife
			else
				result := text.choosing_a_wife_for + user.personal_information.name
			end
		end

	create_sequence is
		do
			add_element_container (~always_true, "True", ~compatibility_sequence)
			add_element_container (~ask_he_drinks, "Not Pregnant", page_factory~yes_no (he_drinks))
			add_element_container (~always_true, "True", page_factory~advice (current))
		end

	ask_he_drinks : BOOLEAN is
		do
			result := compatibility.she_is_pregnant.no
		end

	undo is
		do
		end

invariant

	valid_compatibility : compatibility /= Void
	child_list_has_compatibility: child_list.has (compatibility)
	child_list_has_he_drinks: child_list.has (he_drinks)
	valid_he_drinks : he_drinks /= Void

end -- class CHOOSING_A_WIFE
