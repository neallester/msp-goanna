indexing
	description: "Objects that manage the sequence of pages during a session"
	author: "Neal L. Lester"
	date: "$Date: 2006-10-01 13:33:03 -0700 (Sun, 01 Oct 2006) $"
	revision: "$Revision: 513 $"

class
	PAGE_SEQUENCER

inherit

	SYSTEM_CONSTANTS
	SHARED_APPLICATION_SESSION_MANAGER
	ACTIVE_URL_LIST
	USER_ANCHOR

create
	make

feature {PAGE_SEQUENCE_ELEMENT, PAGE_FACTORY, USER, APPLICATION_SESSION_MANAGER} -- User

	backable : BOOLEAN is
		-- Is there a previous page to display if requested by the user?
		do
			Result := not history.is_empty
		end

	user : like user_anchor
		-- The type of user processed by the application

feature {APPLICATION_SERVLET} -- communication with GOANNA Application

	process_dynamic_url (dynamic_url_to_process : DYNAMIC_URL) is
		-- process an incoming dynamic_url from the servlet
		require
			valid_dynamic_url_to_process : dynamic_url_to_process /= Void
			dynamic_url_from_this_sequencer : dynamic_url_to_process.page.page_sequencer = Current
			valid_active_page : active_page /= Void
			valid_current_request : current_request /= Void
			valid_current_response : current_response /= Void
		do
			debug
				io.putstring ("Processing URL: " + dynamic_url_to_process.query_string + "%N")
			end
			if dynamic_url_to_process.page = active_page then
				if not dynamic_url_to_process.back_up then
					debug
						io.putstring ("Processing Active Page%N")
					end
					process_active_page (dynamic_url_to_process)
					increment_page
				else
					if not history.is_empty then
						restore_history_item
					end
				end
			else
				if history.has (dynamic_url_to_process.page) then
					from
					until
						history.item = dynamic_url_to_process.page
					loop
						user.set_active_page (history.item)
						active_page.undo
						history.remove
					end
					restore_history_item	
					process_active_page (dynamic_url_to_process)
					increment_page
				else				-- User Has Entered a URL from a page that was previously undone
					if not history.is_empty then -- user chose 'back' Roll-back history item
						restore_history_item
					end
				end
			end
		end

	set_new_request (new_request : GOA_HTTP_SERVLET_REQUEST; new_response : GOA_HTTP_SERVLET_RESPONSE) is
		-- Set new request & response for the session to process
		require
			valid_new_request : new_request /= Void
			valid_new_response : new_response /= Void
		do
			current_request := new_request
			current_response := new_response
		ensure
			current_request_updated : current_request = new_request
			current_response_updated : current_response = new_response
		end

	build_response is
		-- Instruct active page to build a response to the current request
		require
			not_active_page_void : active_page /= Void
		do
			active_page.build
			user.store
		ensure
			valid_response : active_page.response /= Void
		end

feature -- {DYNAMIC_URL, PAGE}  -- Current request/response related attributes

	active_page : PAGE is
		-- The currently active page
		do
			result := user.active_page
		end

	active_sequence : PAGE_SEQUENCE_ELEMENT is
		-- The currently active page_sequence
		do
			result := user.active_sequence
		end


	current_request : GOA_HTTP_SERVLET_REQUEST

	current_response : GOA_HTTP_SERVLET_RESPONSE

feature {LOGIN_SEQUENCE} -- Set User

	set_user (new_user : like user_anchor) is
		-- Set a new user for the session
		require
			valid_new_user : new_user /= Void
		do
			user := new_user
			user.set_page_sequencer (current)
			if (not user.anonymous) and (not session_manager.user_is_active (user.user_file_name)) then
				session_manager.add_user (session, user.user_file_name)
			end
		ensure
			user_updated : user = new_user
			user_sequencer_updated : user.page_sequencer = current
			user_not_anonymous_implies_registered_with_session_manager : (not user.anonymous) implies session_manager.user_is_active (user.user_file_name)
		end

feature {NONE} -- implementation 

	current_sequence_element_chain : LINKED_LIST [ELEMENT_CONTAINER]
		-- The chain of page_sequence_elements within active_sequence linking the active_sequence to the page
		-- To do; hide this from SESSION; it is an implementation detail of a particular type of page_sequence

	process_active_page (dynamic_url : DYNAMIC_URL) is
		-- Process the selected dynamic URL as part of the active page
		require
			valid_active_page : active_page /= Void
			valid_dynamic_url : dynamic_url /= Void
			valid_current_request : current_request /= Void
			dynamic_url_in_active_page : dynamic_url.page = active_page
		local
			new_page : PAGE
		do
			active_page.set_web_request (current_request)
			dynamic_url.process
		end

	restore_history_item is
		-- restore the current item in history as the active page
		require
			history_not_empty : not history.is_empty
			history_master_sequence_valid : history.item.master_sequence /= Void
		do
			user.set_active_page (history.item)
			active_page.undo
			user.replace_active_sequence (active_page.master_sequence)
			active_page.reset_sequence
			history.remove
		ensure
			active_page_restored : active_page = old history.item
			active_page_removed : active_page /= history.item
		end	

	history:	ARRAYED_STACK [PAGE] is
		-- Pages previously processed for this user
		do
			result := user.history
		end

	set_active_page is
		-- Set active_page to next page in sequence
		do
			user.set_active_page (active_sequence.page)
			active_page.set_master_sequence (active_sequence)
		ensure
			active_page_updated : active_page = active_sequence.page
			master_sequence_updated : active_page.master_sequence = active_sequence
		end

	increment_page is
		-- Replace active page with the next page in the page sequence
		do
			if active_page.historical then
				debug
					io.putstring ("Adding active page to history%N")
				end
				history.force (active_page)
			end
			debug
				io.putstring ("Calling active_sequence.forth%N")
			end
			active_sequence.forth
			if active_sequence.done then
				debug
					io.putstring ("Incrementing Active Sequence if Done%N")
				end
				user.next_page_sequence
			end
			debug
				io.putstring ("Setting Active_page%N")
			end
			user.set_active_page (active_sequence.page)
			active_page.set_master_sequence (active_sequence)
		ensure
			history_updated : old active_page.historical implies history.item = old active_page
		end

feature -- session

	session : GOA_HTTP_SESSION
		-- The session associated with this sequencer

feature {LOGIN_SEQUENCE, APPLICATION_SERVLET}

	set_session (new_session : GOA_HTTP_SESSION) is
		-- set session to new_session
		require
			valid_new_session : new_session /= Void
		do
			session := new_session
		ensure
			session_updated : session = new_session
		end

feature {NONE} -- Creation

	make (new_session : GOA_HTTP_SESSION) is
		require
			valid_new_session : new_session /= Void
		do
			session := new_session
			session.set_attribute ("page_sequencer", current)
			session.set_max_inactive_interval (session_timeout_interval)
			create active_url_list.make (100)
			create user.make (current)
			if user.login_required then
				user.set_up_login
			else
				user.replace_active_sequence (user.default_page_sequence)
			end
			active_sequence.start
			set_active_page
		ensure
			user.login_required implies user.login_sequence /= Void
			user.login_required implies user.login_sequence = user.active_sequence
		end

invariant

	valid_session : session /= Void
	registered_in_session : session.get_attribute ("page_sequencer") = Current
	valid_history : history /= Void
	valid_user : user /= Void
	registered_with_user : session.validated implies user.page_sequencer = current
	user_on_manager_active_list : (not user.anonymous) implies session_manager.user_is_active (user.user_file_name)
end -- class PAGE_SEQUENCER
