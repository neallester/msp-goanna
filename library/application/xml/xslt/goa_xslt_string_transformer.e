indexing
	description: "An XSLT Transformer that can process xml presented as strings"
	author: "Neal L. Lester <neallester@users.sourceforge.net"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	copyright: "(c) 2005 Neal L. Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

class
	GOA_XSLT_STRING_TRANSFORMER

inherit
	
	XM_SHARED_CATALOG_MANAGER
	KL_IMPORTED_STRING_ROUTINES

creation
	
	make
	
feature -- Transformation
	
	transform_string_to_string (the_string: STRING): STRING is
			-- transform the_string, returning the result as a string
		require
			-- XM_STRING_URI_RESOLVER is registered in
			-- shared_catalog_manager.bootstrap_resolver.uri_scheme_resolver
			-- Can't find a query to express this requirement
			valid_executable: valid_executable
			not_is_error: not is_error
		local
			a_destination: XM_OUTPUT
			a_result: XM_XSLT_TRANSFORMATION_RESULT
			document_source: XM_XSLT_URI_SOURCE
		do
--			if always_clear_document_pool then
				transformer.clear_document_pool
--			else
--				transformer.remove_document (input_uri)
--			end
			create a_destination
			a_destination.set_output_to_string
			create a_result.make (a_destination, output_uri)
			create document_source.make (input_uri)
			shared_catalog_manager.bootstrap_resolver.well_known_system_ids.force (STRING_.cloned_string (the_string), input_uri)
			transformer.transform (document_source, a_result)
			Result := a_destination.last_output
		end
		
feature -- Configuration
		
	set_string_parameter (a_parameter_value, a_parameter_name: STRING) is
			-- Set a global string-valued parameter on the stylesheet.
		require
			parameter_name_not_void: a_parameter_name /= Void and then is_valid_expanded_name (a_parameter_name)
			parameter_value_not_void: a_parameter_value /= Void
		do
			transformer.set_string_parameter (a_parameter_value, a_parameter_name)
		end
		
	set_always_clear_document_pool (true_or_false: BOOLEAN) is
			-- Set clear_document_pool to true_or_false
		do
			always_clear_document_pool := true_or_false
		end
		
		
feature -- Status Report
		
	valid_executable: BOOLEAN is
			-- Has the stylesheet been compiled into a valid executable?
		do
			Result := transformer.executable /= Void
		end
		
	is_error: BOOLEAN is
			-- Has an error occurred in the transformer?
		do
			Result := transformer.is_error
		end
		
	is_valid_expanded_name (a_parameter_name: STRING): BOOLEAN is
			-- Is a_parameter_name valid when expanded?
		do
			Result := transformer.is_valid_expanded_name (a_parameter_name)
		end
		
	always_clear_document_pool: BOOLEAN
			-- Should we clear the document pool before each transform
			-- Required if transform contains doc() or document()
			-- Otherwise, impacts performance and is probably unecessary
		
feature {NONE} -- Implementation
		
	output_uri: STRING is "string:output"
	input_uri: STRING is "string:input"
			-- URIs for input and output strings
			
	transformer: XM_XSLT_TRANSFORMER

feature {NONE} -- Creation
			
	make (new_transformer: XM_XSLT_TRANSFORMER) is
		require
			valid_new_transformer: new_transformer /= Void
		do
			transformer := new_transformer
		ensure
			transformer_updated: transformer = new_transformer
		end
		
invariant
	
	valid_transformer: transformer /= Void

end -- class GOA_XSLT_STRING_TRANSFORMER
