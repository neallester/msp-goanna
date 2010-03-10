indexing
	description: "A URL that can active specific actions within the application"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/10"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	DYNAMIC_URL

inherit

	SYSTEM_CONSTANTS
	TEXT_CONTAINER
		rename
			make as container_make
		undefine
			html_begin_element, html_end_element
		end

create
	make

feature -- Attribute

	query_string : STRING
		-- The text of the query_string portion of the URL; should never change

	initial_query_string : STRING
		-- The text of the initial URL assigned to the object
		-- Used by invariant to verify that url hasn't changed

	page : PAGE
		-- The page that generated the URL

	query_string_factory : UNIQUE_QUERY_STRING_FACTORY is
		-- where unique URL's come from
		once
			create Result.make
		end

	processor : PROCEDURE [PROCESSOR_HOST, TUPLE]
		-- The code that will run if the URL is selected by user

	process is
		-- The url was selected, activate the processor
		require
			url_in_active_page: page = page.page_sequencer.active_page
		local
		do
			page.process (processor)
		end

	back_up : BOOLEAN
		-- This dynamic URL is a back_up URL (will cause display of the previous page)
	
	html_begin_element : STRING is
		do
			Result := "<A HREF=%"" + web_server_url + "/" + web_file_name + "?" + query_string + "%">"
		end

	html_end_element : STRING is
		do
			Result := "</A>"
		end		
		
feature -- creation

	make (client_page : PAGE ; new_processor : PROCEDURE [PROCESSOR_HOST, TUPLE]; new_text : STRING) is
		require
			valid_client_page : client_page /= void
			valid_new_processor : new_processor /= Void
			valid_next_text : new_text /= Void
		do
			page := client_page
			processor := new_processor
			set_text (new_text)
			query_string_factory.forth
			query_string := clone (query_string_factory.unique_string)
			initial_query_string := query_string
			page.page_sequencer.register_dynamic_url (current)
		ensure
			initial_url_updated : initial_query_string = query_string
		end		
	
invariant

	valid_processor : processor /= Void
	registered_in_session : page.page_sequencer.url_registered (current)
	url_hasnt_changed : query_string = initial_query_string

end -- class DYNAMIC_URL
