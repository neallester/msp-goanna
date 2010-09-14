note
	description: "Objects that create pages"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/10"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	PAGE_FACTORY

inherit

	SYSTEM_CONSTANTS
	SEQUENCE_ELEMENT_FACTORY

create

	make

feature {PAGE_SEQUENCE_ELEMENT} -- Pages


-- Login

	login (login_sequence : LOGIN_SEQUENCE) : PAGE
		-- Page that provides for user login
			local
				form : LOGIN_FORM
		do
			create result.make (login_sequence.page_sequencer, login_sequence)
			result.set_not_historical
			create form.make_login_form (result, login_sequence)
			result.add_content (form)
		end


	new_user_login (login_sequence : LOGIN_SEQUENCE) : PAGE
		-- Page that allows new users to apply to system
		local
			form : NEW_USER_LOGIN_FORM
		do
			create result.make (login_sequence.page_sequencer, login_sequence)
			result.set_not_historical
			create form.make_login_form (result, login_sequence)
			result.add_content (form)
		end

	yes_no (new_topic : YES_NO) : PAGE
		-- A page that can display a yes_no_topic
		local
			button : BUTTON_FORM
			text_paragraph : TEXT_PARAGRAPH
			container : CONTAINER_PARAGRAPH
		do
			create result.make (new_topic.user.page_sequencer, new_topic)
			create text_paragraph.make
			text_paragraph.set_text (new_topic.question)
			text_paragraph.set_center
			result.add_content (text_paragraph)
			create button.make_button (result, new_topic~set_yes, new_topic.text.yes)
			create container.make
			container.set_center
			container.force (button)
			result.add_content (container)
			create button.make_button (result, new_topic~set_no, new_topic.text.no)
			create container.make
			container.set_center
			container.force (button)
			result.add_content (container)
		end	
			
	advice (topic : CHOOSING_A_WIFE) : PAGE
		local
			text_paragraph : TEXT_PARAGRAPH
			text : TEXT_LIST
			button : BUTTON_FORM
			container : CONTAINER_PARAGRAPH
		do
			text := topic.user.preference.language
			create result.make (topic.user.page_sequencer, topic)
			create text_paragraph.make
			text_paragraph.set_center
			if topic.compatibility.she_is_pregnant.yes then
				text_paragraph.set_text (text.too_late)
			elseif topic.compatibility.has_a_girlfriend.yes then
				if topic.compatibility.she_drinks.yes and topic.he_drinks.yes then
					text_paragraph.set_text (text.marry_at_pub)
				elseif topic.compatibility.she_drinks.no and topic.he_drinks.no then
					text_paragraph.set_text (text.marry_at_church)
				elseif topic.compatibility.she_drinks.yes then
					text_paragraph.set_text (text.your_a_saint)
				else
					text_paragraph.set_text (text.your_a_drunkard)
				end
			elseif topic.he_drinks.yes then
					text_paragraph.set_text (text.try_a_pub)
			else
				text_paragraph.set_text (text.try_a_church)
			end
			result.add_content (text_paragraph)
			create button.make_button (result, topic~reset, text.continue)
			create container.make
			container.set_center
			container.force (button)
			result.add_content (container)
		end

feature {NONE} -- Creation

	make
		do
		end

end -- class PAGE_FACTORY