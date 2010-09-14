note
	description: "XSLT 2.0 servlet for serving HTTP requests to transform an XML file via XSLT"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "servlets"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Colin Adams <colin-adams@users.sourceforge.net>"
	copyright: "Copyright (c) 2005 Colin Adams and others"
	license: "Eiffel Forum Freeware License v2 (see forum.txt)."

class GOA_XSLT_SERVLET

inherit

	GOA_HTTP_SERVLET
		redefine
			init, do_get, do_post
		end

	UT_STRING_FORMATTER
		export
			{NONE} all
		end
	
	GOA_HTTP_STATUS_CODES
		export
			{NONE} all
		end
		
	KL_INPUT_STREAM_ROUTINES
		export
			{NONE} all
		end

	XM_XPATH_NAME_UTILITIES
		export
			{NONE} all
		end

create

	init

feature -- Initialization

	init (config: GOA_SERVLET_CONFIG)
			-- Called by the servlet manager to indicate that the servlet is being placed
			-- into service. The servlet manager calls 'init' exactly once after instantiating
			-- the object. The 'init' method must complete successfully before the servlet can
			-- receive any requests.
		local
			-- TODO : reinstate these comments when ePosix is used for socket support
--			an_http_resolver: EPX_HTTP_URI_RESOLVER
--			an_ftp_resolver: EPX_FTP_URI_RESOLVER
		do
			Precursor (config)
			servlet_info := "XSLT 2.0 servlet"
			if configuration = Void then
				create configuration.make_with_defaults
				configuration.output_resolver.security_manager.set_high_security (True)
			end
			create error_listener.make (configuration.recovery_policy)
			configuration.set_error_listener (error_listener)
	--		create an_http_resolver
	--		shared_catalog_manager.bootstrap_resolver.uri_scheme_resolver.register_scheme (an_http_resolver)
	--		create an_ftp_resolver
	--		shared_catalog_manager.bootstrap_resolver.uri_scheme_resolver.register_scheme (an_ftp_resolver)			
			create transformer_factory.make (configuration)
		ensure then
			configuration_not_void: configuration /= Void
			transformer_factory_not_void: transformer_factory /= Void
		end

feature -- Access

	configuration: XM_XSLT_CONFIGURATION
			-- Configuration

	transformer_factory: XM_XSLT_TRANSFORMER_FACTORY
			-- Transformer factory

	error_listener: XM_XSLT_STRING_ERROR_LISTENER
			-- Error listener


feature -- Basic operations

	do_get (a_req: GOA_HTTP_SERVLET_REQUEST; a_resp: GOA_HTTP_SERVLET_RESPONSE)
			-- Process GET request
		local
			a_transform_uri, a_source_uri, an_initial_template, an_initial_mode, a_title, a_medium: STRING
			a_clear_cache_request: BOOLEAN
		do
			if a_req.has_parameter (Help_parameter) then
				a_resp.set_content_length (Help_response.count)
				a_resp.send (Help_response)
			elseif not a_req.has_parameter (Transform_parameter) and then not a_req.has_parameter (Source_parameter) then
					a_resp.set_content_length (Help_response.count)
					a_resp.send (Help_response)
			elseif not a_req.has_parameter (Source_parameter) and then not a_req.has_parameter (Template_parameter) then
				a_resp.set_content_length (No_source_response.count)
				a_resp.send (No_source_response)
			else
				if a_req.has_parameter (Transform_parameter) then
					a_transform_uri := a_req.get_parameter (Transform_parameter)
				end
				if a_req.has_parameter (Source_parameter) then
					a_source_uri := a_req.get_parameter (Source_parameter)
				end
				if a_req.has_parameter (Mode_parameter) then
					an_initial_mode := a_req.get_parameter (Mode_parameter)
				end
				if a_req.has_parameter (Template_parameter) then
					an_initial_template := a_req.get_parameter (Template_parameter)
				end
				if a_req.has_parameter (Clear_cache_parameter) then
					if a_req.get_parameter (Clear_cache_parameter).is_equal ("yes") then
						a_clear_cache_request := True
					end
				end
				if a_req.has_parameter (Title_parameter) then
					a_title := a_req.get_parameter (Title_parameter)
				end
				if a_req.has_parameter (Medium_parameter) then
					a_medium := a_req.get_parameter (Medium_parameter)
					-- TODO: validate this (?)
				else
					a_medium := "screen"
				end
				apply_transform (a_transform_uri, an_initial_template, an_initial_mode, a_source_uri, a_medium, a_title, a_clear_cache_request, a_resp)
			end
		end
	
	do_post (a_req: GOA_HTTP_SERVLET_REQUEST; a_resp: GOA_HTTP_SERVLET_RESPONSE)
			-- Process GET request
		do
			do_get (a_req, a_resp)
		end

feature -- Setting

	set_output_resolver (an_output_resolver: XM_XSLT_OUTPUT_URI_RESOLVER)
			-- Set `output_resolver'.
		require
			output_resolver_not_void: an_output_resolver /= Void
			configuration_not_void: configuration /= Void
		do
			configuration.set_output_resolver (an_output_resolver)
		end

feature {NONE} -- Implementation

	Help_parameter: STRING = "help"
			-- Name of help request parameter

	Transform_parameter: STRING = "transform"
			-- Name of transform request parameter

	No_transform_response: STRING = "<html><body><div><p>The transform parameter must be supplied if the source parameter is missing</p></div></body></html>"
			-- Transform-parameter-not-present response

	Source_parameter: STRING = "source"
			-- Name of source request parameter

	Template_parameter: STRING = "template"
			-- Name of initial-template request parameter

	Mode_parameter: STRING = "mode"
			-- Name of initial-mode request parameter

	No_source_response: STRING = "<html><body><div><p>Either the source parameter or the template parameter must be supplied</p></div></body></html>"
			-- Source-parameter-not-present response

	Title_parameter: STRING = "title"
			-- Name of title request parameter

	Medium_parameter: STRING = "medium"
			-- Name of medium request parameter

	Clear_cache_parameter: STRING = "clear-cache"
			-- Name of clear-cache request parameter

	apply_transform (a_transform_uri, an_initial_template, an_initial_mode, a_source_uri, a_medium, a_title: STRING; a_clear_cache_request: BOOLEAN; a_resp: GOA_HTTP_SERVLET_RESPONSE)
			-- Apply `a_transform_uri' to `a_source_uri'.
		require
			transform_uri_not_void: a_transform_uri /= Void or else a_source_uri /= Void
			source_uri_or_initial_template_not_void: a_source_uri /= Void or else an_initial_template /= Void
			response_not_void: a_resp /= Void
			medium_not_empty: a_medium /= Void and then a_medium.count > 0
		local
			a_source: XM_XSLT_SOURCE
			a_transformer: XM_XSLT_TRANSFORMER
			a_response: STRING
			an_output: XM_OUTPUT
			a_destination: XM_XSLT_TRANSFORMATION_RESULT
			finished: BOOLEAN
			a_chooser: XM_XSLT_PI_CHOOSER
		do
			if a_clear_cache_request then
				transformer_factory.clear_stylesheet_cache
			end
			if a_transform_uri = Void then
				if a_title = Void then
					create {XM_XSLT_PREFERRED_PI_CHOOSER} a_chooser.make
				else
					create {XM_XSLT_PI_CHOOSER_BY_NAME} a_chooser.make (a_title)
				end
				a_source := transformer_factory.associated_stylesheet (a_source_uri, a_medium, a_chooser)
			else
				create {XM_XSLT_URI_SOURCE} a_source.make (a_transform_uri)
			end
			transformer_factory.create_new_transformer (a_source)
			if transformer_factory.was_error then
				a_response := STRING_.concat ("<html><head><title>Error creating transform</title></head><body><div><p>", error_listener.error_text)
				a_response := STRING_.appended_string (a_response, "</p></div></body></html>")
				a_resp.set_content_length (a_response.count)
				a_resp.send (a_response)
			else
				a_transformer := transformer_factory.created_transformer
				if a_clear_cache_request then
					a_transformer.clear_document_pool
				end
				if an_initial_mode /= Void then
					if is_valid_expanded_name (an_initial_mode) then
						a_transformer.set_initial_mode (an_initial_mode)
					else
						a_response := "<html><head><title>Invalid initial mode</title></head><body><div><p>The initial mode is not lexically valid</p></div></body></html>"
						a_resp.set_content_length (a_response.count)
						a_resp.send (a_response)
						finished := True
					end
				end
				if a_source_uri /= Void then create  {XM_XSLT_URI_SOURCE} a_source.make (a_source_uri) end
				if an_initial_template /= Void then
					a_transformer.set_initial_template (an_initial_template)
				end
				if not finished and then not a_transformer.is_error then
					create an_output
					an_output.set_output_to_string
					create a_destination.make (an_output, "string:")
					a_transformer.transform (a_source, a_destination)
				end
				if not finished then
					if a_transformer.is_error then
						a_response := STRING_.concat ("<html><head><title>Error transforming source</title></head><body><div><p>", error_listener.error_text)
						a_response := STRING_.appended_string (a_response, "</p></div></body></html>")
						a_resp.set_content_length (a_response.count)
						a_resp.send (a_response)
					else
						a_resp.set_content_length (an_output.last_output.count)
						a_resp.send (an_output.last_output)					
					end
				end
			end
		end

	Help_response: STRING
			-- Help response
		once
			Result :=  "[
							<html>
							<head><title>Help for XSLT 2.0 Servlet</title>
							<body>
							<div>
							<p>You need to specify a number of parameters in the query string
							in order to use the servlet. Some of these are themselves URI-valued,
							so you may need to escape characters. The parameters allowed are:
							</p>
							<p>
							<dl>
							<dt>help</dt><dd>This help page will be displayed</dd>
							<dt>clear-cache</dt>
							<dd>If this is set to yes, the transform (stylesheet) and document caches will be emptied.
							You will especially need to do this if you are relying on xml-stylesheet
							processing instructions, and you change the medium or title pseudo-attributes.
							</dd>
							<dt>template</dt>
							<dd>This specifies the initial template.
							You <em>must</em> specify this if you omit the source parameter.
								If this is omitted, then XSLT will locate the initial template
							according to the match attributes coded on xsl:template instructions,
							as is normal.
							</dd>
							<dt>mode</dt>
							<dd>The initial mode.
								If you omit this, then transformation starts in the default mode.
							<p>
							The syntax of a mode name is an expanded QNames - that is
		an NCName, optionally preceeded by a namespace-URI enclosed in curly braces.
		e.g. {urn:my-urn:an-arbitrary-namespace}my-local-name
							</p>
							</dd>
							<dt>transform</dt>
							<dd>The URI of the transform (or stylesheet) to be applied.
								If this is missing, then source <em>must</em> be supplied,
									and the servlet will search for xml-stylesheet
								proccessing instructions within the source document to determine the transform.
								</dd>
								<dt>source</dt>
								<dd>The URI of the source document to be transformed.
								If this is missing, then template <em>must</em> be supplied. 
							   </dd>
								<dt>medium</dt>
								<dd>The medium for which xml-stylesheet processing instructions will be considered.
								This defaults to screen.
								</dd>
								<dt>title</dt>
								<dd>the name of the alternate xml-stylesheet processing instruction to be selected, in addition
								to persistent xml-stylesheet processing instructions.
								If this is omitted, then only persistent and preferred xml-stylesheet processing instructions
									will be selected.
								</dd>
							</dl>
							</p>
							</div>
							</body>
							</html>
							]"
		end

end -- class GOA_XSLT_SERVLET
