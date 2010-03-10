indexing
	description: "A factory for creating common XSLT transformers"
	author: ""
	date: "$Date: 2009-05-28 22:29:33 -0700 (Thu, 28 May 2009) $"
	revision: "$Revision: 621 $"
	copyright: ""

class
	GOA_XSLT_TRANSFORMER_FACTORY

inherit

	XM_SHARED_CATALOG_MANAGER
	XM_XPATH_SHARED_CONFORMANCE
	XM_XSLT_TRANSFORMER_FACTORY
	KL_SHARED_EXCEPTIONS
	UT_SHARED_FILE_URI_ROUTINES
	KL_SHARED_FILE_SYSTEM

creation

	make_without_configuration

feature

	new_string_transformer_from_file_name (new_file_name: STRING): GOA_XSLT_STRING_TRANSFORMER is
			-- Create a new transformer given the name of the file containing the stylesheet
			-- Call this from a once function to improve performance as the stylesheet is then
			-- Compiled only once (the first time it is called)
		require
			valid_new_file_name: new_file_name /= Void
			valid_new_file_name: True -- new_file_name represents an existing file containing a valid XSLT stylesheet
			file_exists: file_system.file_exists (new_file_name)
		local
			stylesheet: XM_XSLT_STYLESHEET_COMPILER
			a_cwd: KI_PATHNAME
			a_uri: UT_URI
			stylesheet_source: XM_XSLT_URI_SOURCE
			resolver_scheme: STRING
		do
--				io.put_string (new_file_name)
				a_cwd := file_system.string_to_pathname (file_system.current_working_directory)
				create a_uri.make_resolve_uri (file_uri.pathname_to_uri (a_cwd), file_uri.filename_to_uri (new_file_name))
				create stylesheet.make (configuration)
				create stylesheet_source.make (a_uri.full_reference)
--				stylesheet.prepare (stylesheet_source, a_uri)
				create_new_transformer (stylesheet_source, a_uri)
--				create_new_transformer (stylesheet_source)
				if was_error then
					io.put_string (new_file_name + ": " + last_error_message + "%N")
				end
				create Result.make (created_transformer)
				resolver_scheme := string_resolver.scheme
				-- Just to make sure the string_resolver is created and registered
		end

	string_resolver: XM_STRING_URI_RESOLVER is
			-- Resolver used to resolve strings
		once
			create Result.make
			shared_catalog_manager.bootstrap_resolver.uri_scheme_resolver.register_scheme (Result)
		end

feature {NONE} -- Creation

	make_without_configuration is
		local
			xslt_configuration: XM_XSLT_CONFIGURATION
		do
				create xslt_configuration.make_with_defaults
--				xslt_configuration.use_tiny_tree_model (True)
--				xslt_configuration.set_tiny_tree_estimates (50, 50, 4, 5000)
				make (xslt_configuration)
				conformance.set_basic_xslt_processor
				-- TODO Transition to Tiny Tree model
		end


end -- class GOA_XSLT_TRANSFORMER_FACTORY
