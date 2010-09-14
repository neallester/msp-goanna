note
	description: "A single page, or one interaction with the user"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/14"
	revision: "$Revision: 513 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	PAGE

inherit

	ACTIVE_URL_LIST
	SYSTEM_CONSTANTS
	PAGE_SEQUENCE_ELEMENT

create

	make

feature -- Implement Deferred Features

	text: TEXT_LIST
		do
			result := user.preference.language
		end

	page : PAGE
		do
			result := current
		end

	start
		do
			done := false
		end

	forth
		do
			done := true
		end

	done : BOOLEAN

	active_chain : LINKED_LIST [ELEMENT_CONTAINER] 
		-- Add current to the chain of active elements
		do
			create result.make
		end

	context : STRING
		-- Clear text contribution to text describing the sequence of page_sequence_elements that has generated this page
		do
			if display_topic_title then
				result := topic.title
			else
				result := ""
			end
		end

feature -- {PAGE_SEQUENCER, WEB_SERVER_PROXY, DYNAMIC_URL, PAGE_FACTORY}

	page_sequencer : PAGE_SEQUENCER
		-- The page_sequencer associated with this page

	user : like user_anchor
		do
			result := page_sequencer.user
		end

	topic : TOPIC

feature {PAGE_SEQUENCER} -- Access by page_sequencer

	undo
		-- Undo any changes made by this page
		require
			page_is_active : current = page_sequencer.active_page
		do
			topic.undo
			done := false
		ensure then
			done_false : done = false
		end

	reset_sequence
		-- Sets the active_sequence to state when current page was generated
		require
			valid_master_sequence : master_sequence /= Void
		local
			a_chain : LINKED_LIST [ELEMENT_CONTAINER]

		do
			create a_chain.make
			sequence_element_chain.start
			from
			until
				sequence_element_chain.after
			loop
				a_chain.force (sequence_element_chain.item)
				sequence_element_chain.forth
			end
			master_sequence.restore_chain (a_chain)
		ensure
			master_sequence_active_sequence_matches_chain : master_sequence_active_sequence_matches_chain
		end

	add_to_response (content_to_add : CONTENT_CONTAINER)
		-- Add content_to_add to response
		require
			valid_content_to_add : content_to_add /= Void
			valid_response : response /= Void
		do
			page_sequencer.user.preference.client.set_code (content_to_add)
			response.send (content_to_add.code)
		end

	build
		-- prepare to display the page
		require
			valid_master_sequence : master_sequence /= Void
			buildable : buildable
			current_is_active : current = page_sequencer.active_page

		do
			page_is_dirty := True
			sequence_element_chain := clone (master_sequence.active_chain)
-- Add Code header
			create code_header.make
			code_header.set_text (title)
			add_to_response (code_header)
-- Add page header
			user.set_up_page_header
			if user.page_header /= Void then
				add_to_response (user.page_header)
			end
-- Add Content_List
			from
				content_list.start
			until
				content_list.after
			loop
				add_to_response (content_list.item)
				content_list.forth
			end
-- Add page footer
			user.set_up_page_footer
			if user.page_footer /= Void then
				add_to_response (user.page_footer)				
			end
-- Add code footer
			create code_footer.make
			add_to_response (code_footer)
		ensure
			page_is_dirty : page_is_dirty
			valid_response : response /= Void
			master_sequence_active_sequence_matches_chain  : 	master_sequence_active_sequence_matches_chain
		end

	response : GOA_HTTP_SERVLET_RESPONSE
		-- The web response associated with the page
		do
			result := page_sequencer.current_response
		end

	sequence_element_chain : LINKED_LIST [ELEMENT_CONTAINER]
		-- The chain of page_sequence_elements that generated this page

	master_sequence : PAGE_SEQUENCE_ELEMENT
		-- The page_sequence_element in page_sequencer that has generated this page

	set_master_sequence (new_master_sequence : PAGE_SEQUENCE_ELEMENT)
		-- Set master_sequence
		require
			valid_new_master_sequence : new_master_sequence /= Void
		do
			master_sequence := new_master_sequence
		ensure
			master_sequence_updated : master_sequence = new_master_sequence
		end

	set_web_request (new_web_request : GOA_HTTP_SERVLET_REQUEST)
		-- Set the web request received in response to this page
		require
			valid_new_web_request : new_web_request /= Void
		do
			web_request := new_web_request
		ensure
			web_request_updated : web_request = new_web_request
		end

	buildable : BOOLEAN
		-- Does the page contain any content to use for building a response
		do
			result := not content_list.is_empty
		end

	historical : BOOLEAN
		-- Add this page page to history (if true); if false, page_sequencer won't add to history

feature {DYNAMIC_URL} -- Page Processing

	process (processing_code : PROCEDURE [PROCESSOR_HOST, TUPLE])
		-- do post display processing
		require
			valid_processing_code : processing_code /= Void
		do
			processing_code.call ([])
		end

feature {FORM, FORM_ELEMENT, PAGE_SEQUENCER}

	web_request : GOA_HTTP_SERVLET_REQUEST
		-- The web request that this page is responding to

feature {NONE} -- Implementation

	code_footer : CODE_FOOTER
		-- Programming code added to the end of each page

	code_header : CODE_HEADER
		-- Programming code added to the beginning of each page
		
	content_list : LINKED_LIST [CONTENT_CONTAINER]
		-- The content of the page to be displayed

	title : STRING
		-- The clear text title of this page
		do
			Result := text.application_title + " : " + page_sequencer.active_sequence.context
		end

	restore_chain (chain : LINKED_LIST [ELEMENT_CONTAINER])
		-- The caller is restoring a previously executed chain of page_sequence_elements that generated this page
		-- This page is the terminal element of this chain.
		do
			done := false
		end

	master_sequence_active_sequence_matches_chain : BOOLEAN
		-- Does sequence_element_chain match active_sequence.active_chain?
		require
			valid_master_sequence : master_sequence /= Void
		local
			master_chain : LINKED_LIST[ ELEMENT_CONTAINER]
		do
			master_chain := clone (master_sequence.active_chain)
			result := false
			if (not master_chain.is_empty) and (not sequence_element_chain.is_empty) then
				master_chain.start
				sequence_element_chain.start
				if master_chain.item = sequence_element_chain.item then
					result := true
				end
				from
				until
					master_chain.after or sequence_element_chain.after or (master_chain.item /= sequence_element_chain.item)
				loop
					master_chain.forth
					sequence_element_chain.forth
					if master_chain.item /= sequence_element_chain.item then
						result := false
					end
				end
				if not (master_chain.after and sequence_element_chain.after) then
					result := false
				end
			else
				if master_chain.is_empty and sequence_element_chain.is_empty then
					result := true
				else
					result := false
				end
			end
		end
			
feature {PAGE_FACTORY} --

	display_topic_title : BOOLEAN
		-- Display the topic title in context string
		-- Usefull if topic is not a page sequence in the context

	set_display_topic_title
		-- Set display_topic_title true
		do
			display_topic_title := true
		ensure
			display_topic_title : display_topic_title
		end

	add_content (new_content : CONTENT_CONTAINER)
		-- add new_content to content_list
		require
			valid_new_content : new_content /= Void
		do
			content_list.force (new_content)
		ensure
			new_content_added : content_list.has (new_content)
		end

	set_not_historical
		-- This page should not be added to page history
		do
			historical := false
		ensure
			not_historical : not historical
		end

	set_topic (new_topic : TOPIC)
		-- Set a new topic for the page
		require
			valid_new_topic : new_topic /= Void
		do
			topic := new_topic
		ensure
			topic_updated : topic = new_topic
		end
		
feature {NONE} -- creation

	make (new_page_sequencer : PAGE_SEQUENCER ; new_topic : TOPIC)
		require 
			valid_new_page_sequencer : new_page_sequencer /= Void
		do
			create active_url_list.make (10)
			create content_list.make
			page_sequencer := new_page_sequencer
			topic := new_topic
			historical := true
		ensure
			historical : historical
		end

invariant

	valid_page_sequencer : page_sequencer /= Void
	valid_content_list : content_list /= Void
	valid_context : context /= Void
	valid_topic : topic /= Void

end -- class PAGE
