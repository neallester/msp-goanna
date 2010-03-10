indexing
	description: "Bachelors who use this system for advice"
	author: "Neal L. Lester (neal@3dsafety.com)"
	date: "$ May 11, 2001: $"
	revision: "$version 1.0$"

class
	BACHELOR_USER

inherit
	STORABLE_USER
		redefine
			make
		end

create
	make

feature -- implement deferred features

	login_required : BOOLEAN is
		do
			result := true
		end

	set_up_page_header is
		local
			text_paragraph : TEXT_PARAGRAPH
		do
			create text_paragraph.make
			text_paragraph.set_text (active_sequence.context)
			text_paragraph.set_left
			page_header := text_paragraph
		end

	set_up_page_footer is
		local
			text_paragraph : TEXT_PARAGRAPH
			container : MULTI_CONTAINER
			container_paragraph : CONTAINER_PARAGRAPH
			back_up_button : BACK_UP_BUTTON_FORM
		do
			create container.make
			if page_sequencer.backable then
				create back_up_button.make_back_up_button (active_page)
				create container_paragraph.make_with_container (back_up_button)
				container_paragraph.set_right
				container.force (container_paragraph)
			end
			create text_paragraph.make
			text_paragraph.set_text (preference.language.goanna_application)
			text_paragraph.set_center
			container.force (text_paragraph)
			page_footer := container
		end

	default_page_sequence : PAGE_SEQUENCE_ELEMENT is
		do
			result := choosing_a_wife
			result.start
		end

feature -- Attributes

	choosing_a_wife : CHOOSING_A_WIFE

feature -- Creation

	make (new_page_sequencer : PAGE_SEQUENCER) is
		do
			precursor (new_page_sequencer)
			create choosing_a_wife.make_with_user (current)
			create personal_information.make_with_user (current)
		end

invariant

	valid_choosing_a_wife : choosing_a_wife /= Void
	valid_personal_information : personal_information /= Void

end -- class BACHELOR_USER
