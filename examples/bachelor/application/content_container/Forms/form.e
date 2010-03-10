indexing
	description: "Objects that implement HTML forms"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/05/10"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class
	FORM

inherit
	PROCESSOR_HOST
		undefine
			is_equal, copy
		end
	MULTI_CONTAINER
		rename
			make as multi_container_make
		export {NONE}
			all
		redefine
			html_begin_element, html_end_element
		end
	DYNAMIC_URL
		rename
			make as url_make
		export {FORM, FORM_ELEMENT}
			page
		undefine
			html_element, is_equal, copy
		redefine
			html_begin_element,
			html_end_element
		select
			container_make
		end

feature {FORM_ELEMENT} -- Set up elements

	register_element (new_element : FORM_ELEMENT) is
		-- register a new element in the form
		require
			valid_new_element : new_element /= Void
			not_already_registered : not element_registered (new_element)
		do
			form_elements.force (new_element)
		ensure
			element_registered : element_registered (new_element)
		end

	element_registered (element : FORM_ELEMENT) : BOOLEAN is
		-- Is new element registered (contained in form_elements list)
		do
			result := form_elements.has (element)
		end

feature {NONE} -- Implementation

	html_begin_element : STRING is
		do
			Result := "<FORM ACTION=%"" + web_server_url + "/" + web_form_name + "?" + query_string + "%" METHOD=%"POST%">" + new_line
--			Result := Result + "<INPUT TYPE=%"HIDDEN%" NAME=%"query_string%" VALUE=%"" + query_string + "%">" + new_line
--			This line was necessary under MS Personal Web Server as ASP didn't provide the query string for "POST" requests
--			So far, does not appear to be a problem with Apache
		end

	html_end_element : STRING is
		do
			result := "</FORM>" + new_line
		end

feature {NONE} -- Implementation

	form_elements : LINKED_LIST[FORM_ELEMENT]

	build_form is
		-- Build the form
		deferred
		ensure
			has_submit_button : has_submit_button
		end

	has_submit_button : BOOLEAN is
		-- Form has a submit button
		local
			submit_button : SUBMIT_BUTTON
		do
			result := false
			from
				form_elements.start
			until
				form_elements.after
			loop
				submit_button ?= form_elements.item
				if submit_button /= Void then
					result := true
					form_elements.finish
				end
				form_elements.forth
			end
		end

	form_handler is
		-- Code that executes when form input is received
		require
			form_elements_not_empty : not form_elements.is_empty
		do
			all_processed := true
			from
				form_elements.start
			until
				form_elements.after
			loop
				form_elements.item.process
					if not form_elements.item.processed then
						all_processed := false
					end
				form_elements.forth
			end
			process_form
		end

feature {NONE} -- Creation

	process_form is 
		-- any form specific processing
		deferred
		end

	all_processed : BOOLEAN
		-- All form elements were sucessfully processed

	make (client_page : PAGE) is
		do
			url_make (client_page, ~form_handler, "")
			create form_elements.make
			multi_container_make
			build_form
			from
				form_elements.start
			until
				form_elements.after
			loop
				form_elements.item.initialize
				form_elements.forth
			end
		ensure
			form_elements_initialized : form_elements_intialized
		end

	form_elements_intialized : BOOLEAN is
		-- Have all form_elements in form been initialized?
		do
			result := true
			from
				form_elements.start
			until
				form_elements.after
			loop
				if not form_elements.item.initialized then
					result := false
					form_elements.finish
				end
				form_elements.forth
			end
		end

invariant

	valid_page : page /= Void
	valid_form_elements : form_elements /= Void

end -- class FORM
