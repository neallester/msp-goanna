note
	description: "A user of a web based application"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/10"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class
	USER

inherit

	SYSTEM_CONSTANTS
		rename
			new_line as new_line_character
		end

feature -- attributes

	personal_information : PERSONAL_INFORMATION
		-- Information about the user.  If descendents want to use these features, they must create the attribute in their make routine
		-- The LOGIN_SEQUENCE uses this attribute.

feature {PAGE_SEQUENCER, LOGIN_SEQUENCE} --

	set_page_sequencer (new_page_sequencer : PAGE_SEQUENCER)
		-- Register a page_sequencer as active for this user
		require
			valid_page_sequencer : new_page_sequencer /= Void
		do
			page_sequencer := new_page_sequencer
		ensure
			page_sequencer_updated : page_sequencer = new_page_sequencer
		end

	default_page_sequence : PAGE_SEQUENCE_ELEMENT
		-- The page sequence to use when no other sequence is specified
		deferred
		ensure
			valid_result : result /= Void
		end

	history:	ARRAYED_STACK [PAGE]
		-- Pages previously processed for this user

	store
		-- Store this user in persistent media
		deferred
		end

feature {PAGE_SEQUENCER, LOGIN_SEQUENCE}

	active_page : PAGE
		-- The currently active page

	active_sequence : PAGE_SEQUENCE_ELEMENT
		-- The currently active page_sequence

	set_active_page (new_page : PAGE)
		-- Set new_page as the active page
		require
			valid_new_page : new_page /= void
		do
			active_page := new_page
		ensure
			active_page_updated : active_page = new_page
		end

	anonymous : BOOLEAN
		-- This is an anonymous user; the class will ignore requests to store this user.

	set_not_anonymous
		-- This user is not anonymous - store
		do
			anonymous := false
		ensure
			not anonymous
		end

	set_up_login
		-- Set up login_sequence as the active_sequence
		require
			login_required : login_required
			login_sequence_void : login_sequence = void
		do
			create login_sequence.make (page_sequencer)
			replace_active_sequence (login_sequence)
		ensure
			valid_login_sequence : login_sequence /= Void
			login_sequence_active : login_sequence = active_sequence
		end

	login_required : BOOLEAN
		-- When new user is created, LOGIN_SEQUENCE is made the active sequence
		deferred
		end

	login_sequence : LOGIN_SEQUENCE
		-- The page_sequence or page called if login is required

feature {PAGE_SEQUENCER, LOGIN_SEQUENCE, APPLICATION_SESSION_MANAGER}

	user_file_name : STRING
		-- the file name for this user excluding drive/directory & extension
		-- A unique system generated user identifier

feature {PAGE_SEQUENCER, TOPIC, PAGE_SEQUENCE_ELEMENT}-- Change active sequence is

	next_page_sequence
		-- Increment active sequence
		do
			if not pending_page_sequences.is_empty then
				debug
					io.putstring ("Setting active_sequence to pending_page_sequences.item%N")
				end
				active_sequence := pending_page_sequences.item
				debug
					io.putstring ("Removing active_sequence from pending_page_sequences%N")
				end
				pending_page_sequences.remove
			else
				debug
					io.putstring ("Setting active_sequence to default_page_sequence%N")
				end
				active_sequence := default_page_sequence
			end
		ensure
			valid_active_sequence : active_sequence /= Void
			pending_page_sequences_empty_implies_default_sequence : old pending_page_sequences.is_empty implies (active_sequence = default_page_sequence)
			pending_page_sequences_not_empty_implies_updated : not old pending_page_sequences.is_empty implies active_sequence = old pending_page_sequences.item
			pending_page_sequence_removed : (not old pending_page_sequences.is_empty) implies not (pending_page_sequences.item = old pending_page_sequences.item)
		end

	interupt_active_sequence (new_sequence : PAGE_SEQUENCE_ELEMENT)
		-- Interupt curernt page_sequence with new_sequence; continue current when new_sequence.done
		require
			valid_new_sequence : new_sequence /= Void
		do
			pending_page_sequences.force (active_sequence)
			active_sequence := new_sequence
		ensure
			active_sequence_updated : active_sequence = new_sequence
			active_sequence_pending : active_sequence = pending_page_sequences.item
		end

	replace_active_sequence (new_sequence : PAGE_SEQUENCE_ELEMENT)
		-- Replace active_sequence with new_sequence; discard active_sequence
		require
			valid_new_sequence : new_sequence /= Void
		do
			active_sequence := new_sequence
		ensure
			active_sequence_updated : active_sequence = new_sequence
		end	


feature {NONE} -- Initialization

	make (new_page_sequencer : PAGE_SEQUENCER)
		do
			create preference.make
			page_sequencer := new_page_sequencer
			create history.make (100)
			create pending_page_sequences.make (10)
			anonymous := true
		ensure
			anonymous : anonymous
			page_sequencer_updated : page_sequencer = new_page_sequencer
		end

feature {PAGE_SEQUENCE_ELEMENT, PAGE_FACTORY, CONTENT_CONTAINER, TOPIC, USER, PAGE_SEQUENCER} -- Attributes

	page_sequencer : PAGE_SEQUENCER
		-- The page_sequencer registered for this user

	preference : USER_PREFERENCE
		-- Preferences for this user

feature {PAGE} -- Page Headers & Footers

	page_header : CONTENT_CONTAINER
		-- Content to display at the top of each page

	page_footer : CONTENT_CONTAINER
		-- Content to display at the bottom of each page

	set_up_page_header
		-- Set up the page_header
		deferred
		end

	set_up_page_footer
		-- Set up the page_footer
		deferred
		end

feature {NONE} -- Implementation

	pending_page_sequences : ARRAYED_STACK [PAGE_SEQUENCE_ELEMENT]
		-- Sequences to be displayed once the active_sequence is done

invariant

	valid_preference : preference /= Void
	valid_history : history /= Void
	valid_pending_page_sequences : pending_page_sequences /= Void
	login_required_implies_valid_personal_information : login_required implies personal_information /= Void
	not_anonymous_implies_valid_user_file_name : not anonymous implies user_file_name /= void
	not_anonymous_implies_user_file_name_not_empty : not anonymous implies not user_file_name.is_empty

end -- class USER
