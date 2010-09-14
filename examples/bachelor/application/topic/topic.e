note
	description: "A topic in the application"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/14"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class
	TOPIC

inherit

	USER_RELATED
	INITIALIZEABLE

feature {PAGE, PAGE_FACTORY, TOPIC, PAGE_SEQUENCE_ELEMENT, SUBDOMAIN_ITERATOR, FORM, FORM_ELEMENT} -- Attributes

	page_sequencer : PAGE_SEQUENCER
		-- Current page_sequencer for user
		do
			result := user.page_sequencer
		end

	undo
		-- Return this topic to the state before last change
		deferred
		end

	title : STRING
		-- The plain text title
		deferred
		end

	text: TEXT_LIST
			-- The current list of all text used in the application for this user
		do
			result := user.preference.language
		end

invariant

	user_exists: user /= void
	text_exists: text /= void
	page_sequence_exists: page_sequencer /= Void

end -- class TOPIC
