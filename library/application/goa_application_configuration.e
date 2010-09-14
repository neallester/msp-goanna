note
	description: "Configuration information required for GOA_APPLICATION_SERVER"
	author: "Neal L Lester <neallester@users.sourceforge.net>"
	date: "$Date: 2009-12-23 16:16:29 -0800 (Wed, 23 Dec 2009) $"
	revision: "$Revision: 623 $"
	copyright: "(c) Neal L Lester"
	License: "Eiffel Forum License Version 2 (see forum.txt)"

deferred class
	GOA_APPLICATION_CONFIGURATION

inherit

	GOA_TRANSACTION_MANAGEMENT
	KL_SHARED_EXECUTION_ENVIRONMENT
	KL_SHARED_FILE_SYSTEM
	SHARED_SERVLETS

feature -- Page Sequencing

	next_page (processing_result: REQUEST_PROCESSING_RESULT): GOA_DISPLAYABLE_SERVLET
			-- What is the next page to display to the user?
		require
			valid_processing_result: processing_result /= Void and then processing_result.was_processed
			ok_to_write_data: implements_transaction_and_version_access implies ok_to_write_data (processing_result)
		deferred
		ensure
			valid_result: Result /= Void
			result_ok_to_display: Result.ok_to_display (processing_result)
			ok_to_write_data: implements_transaction_and_version_access implies ok_to_write_data (processing_result)
--			not_ok_to_read_write_data: implements_transaction_and_version_access implies not (ok_to_read_data (processing_result) or ok_to_write_data (processing_result))
		end

	log_directory: STRING
			-- Interpreted version of internal_log_directory
		once
			Result := execution_environment.interpreted_string (internal_log_directory)
		end

	temp_directory: STRING
			-- Interpreted version of internal_temp_directory
		once
			Result := execution_environment.interpreted_string (internal_temp_directory)
		end

	xslt_directory: STRING
			-- Interpreted version of internal_xslt_directory
		once
			Result := execution_environment.interpreted_string (internal_xslt_directory)
		end

	document_root: STRING
			-- Interpreted version of internal_document_root
		once
			Result := execution_environment.interpreted_string (internal_document_root)
		end

feature -- Deferred Features

	internal_data_directory: STRING
			-- Directory where the log files will be written to; e.g. must exist and be writable
			-- Include trailing directory separator
		obsolete
			"Use instead the following: internal_log_directory, internal_temp_directory, internal_xslt_directory"
		deferred
		end

	internal_log_directory: STRING
			-- Directory where the log files will be written to; e.g. must exist and be writable
			-- Include trailing directory separator
		do
			Result := internal_data_directory
		end

	internal_temp_directory: STRING
			-- Directory where the temp files will be written to; e.g. must exist and be writable
			-- Include trailing directory separator
		do
			Result := internal_data_directory
		end

	internal_xslt_directory: STRING
			-- Directory where the xslt translation files are located
			-- e.g. must exist and contain 'goa_page.xsl' and 'goa_page.frng'
			-- Include trailing directory separator
		do
			Result := internal_data_directory
		end

	internal_document_root: STRING
			-- The document root directory where stand alone server looks for documents
			-- Not sure what this is used for in a fastcgi application (use an arbitrary string).
		deferred
		end

	internal_test_mode: BOOLEAN
			-- This configuration should run in "test mode"
			-- In test mode, page xml data is written to file
			-- In test mode, the application does not run as a daemon
		deferred
		end

	host: STRING
			-- Host name for server to listen on
			-- Use 'localhost' to listen only to requests from local machine (domain socket)
			-- Use IP Address of host running the GOA_APPLICATION_SERVER server if
			-- application must accept requests from other machines
		once
			Result := "localhost"
		end


	port: INTEGER
			-- Server connection port
		deferred
		end

	default_virtual_host_lookup_string: STRING
			-- The default virtual host name to use, if the actual host name
			-- does not correspond to an existing VIRTUAL_DOMAIN_HOST
		deferred
		end

	bring_down_server_servlet_name: STRING
			-- Name of the servlet that will shut down the application server
			-- Make it long and random for security purposes
			-- I was having trouble getting Interupt handling to work reliably
			-- This is a clean way of getting the application shut down
			-- with the (small) risk of a DOS attack
		deferred
		end

feature -- Attributes

	over_ride_test_mode: BOOLEAN
			-- Run in test mode, even if internal test mode is False

	use_saxon: BOOLEAN
			-- Use Saxon as the XSLT processor

	servlet_configuration: GOA_SERVLET_CONFIG
			-- Goanna configuration
		once
			create Result
			Result.set_server_port (port)
			Result.set_document_root (document_root)
		end

	test_mode: BOOLEAN
			-- Run in test mode
		do
			Result := internal_test_mode or over_ride_test_mode
		end

	bring_down_server_exception_description: STRING = "Shut Down Server"
			-- Description of developer exception thrown to bring down the application

	bring_down_server: BOOLEAN
			-- Should we bring down the application?

	validate_email_domain: BOOLEAN
			-- Should we validate the domain of emails submitted by the user
			-- Program 'dig' must be available in the execution path of the system
		deferred
		end

	install_snoop_servlet: BOOLEAN
			-- Should we install snoop_servlet?  This servlet echos the contents of
			-- A web request back to the user.  Sometimes useful in debugging.
			-- Descendents may redefine to True
		once
			Result := False
		end

feature -- Configuration Setting

	set_use_saxon
			-- Set configuration to use saxon as the XSLT processor
		do
			use_saxon := True
		end

	set_over_ride_test_mode
			-- Set configuration to run credit cards in test mode
		do
			over_ride_test_mode := True
		end

	set_bring_down_server
			-- Set bring_down_server to True
			-- Will result in shut down of application
		do
			bring_down_server := True
		end

feature -- Constants

	session_status_attribute_name: STRING = "SESSION_STATUS"

	parameter_separator: CHARACTER = ':'

feature -- File Names

--	temp_saxon_input_file_name (suffix: STRING): STRING is
			-- Name of temporary input file for transformations by Saxon
			-- Suffix should uniquely identify the file
--		require
--			valid_suffix: suffix /= Void and then not suffix.is_empty
--		do
--			Result := temp_directory + "saxon_input_" + suffix + ".xml"
--		end

--	temp_saxon_output_file_name (suffix: STRING): STRING is
			-- Name of temporary output fiel for transformations by Saxon
			-- Suffix should uniquely identify the file
--		require
--			valid_suffix: suffix /= Void and then not suffix.is_empty
--		do
--			Result := temp_directory + "saxon_output_" + suffix + ".xml"
--		end

feature -- Transformation

	java_binary_location: STRING
			-- file name of the java VM; include full path if not in execution path (e.g. /usr/java/j2re1.5.2_04/bin/java)
		once
			Result := execution_environment.interpreted_string ("$JAVA")
		end

	saxon_jar_file_location: STRING
			-- Full path and file name to the saxon XSLT transformation jar file (.e.g. /opt/saxon/saxon8.jar)
		once
			Result := "/opt/saxon/saxon8.jar"
		end

	validate_xml: BOOLEAN
			-- Should we validate xml generated by GOA_XML_DOCUMENT objects
			-- If yes, jing ( http://www.thaiopensource.com/relaxng.jing.html ) must
			-- be installed and jing_invocation set
		once
			Result := False
		end

	jing_invocation: STRING
			-- Invocation string on this system, e.g.
			-- Result := "$JAVA_HOME/bin/java -jar /usr/local/share/jing/jing.jar"
			-- Or, if jing is in the execution path, simply
			-- Result := "jing"
		once
			-- Nothing by default
		end

feature -- Logging

	log_file_name: STRING
			-- Name of file used to log servlet activity
		once
			Result := log_directory + "application.log"
		end

	illegal_requests_file_name: STRING
			-- Name of file used to log full text of illegal requests
		once
			Result := log_directory + "illegal_requests.log"
		end

feature -- Servlet Names

	snoop_servlet_name: STRING = "snoop.htm"

feature -- Servlet Names

	fast_cgi_directory: STRING
			-- The directory configured to serve fast_cgi requests
			-- Must include two directory names with leading and
			-- Trailing slashes, e.g.
			-- /dir1/dir2/
			-- for Apache, dir1 must match the alias
			-- for the fast-cgi directory
		deferred
		end

feature -- Logging

	application_log_category: STRING = "app"

	application_error_log_category: STRING = "error"

	application_security_log_category: STRING = "security"

invariant

	log_directory_is_readable: file_system.directory_exists (log_directory) and then file_system.is_directory_readable (log_directory)
	temp_directory_is_readable: file_system.directory_exists (temp_directory) and then file_system.is_directory_readable (temp_directory)
	xslt_directory_is_readable: file_system.directory_exists (xslt_directory) and then file_system.is_directory_readable (xslt_directory)
	use_saxon_implies_valid_java_binary_location: use_saxon implies file_system.file_exists (java_binary_location)
	use_saxon_implies_valid_saxon_jar_file_location: use_saxon implies file_system.file_exists (saxon_jar_file_location)
	validate_xml_implies_valid_jing_invocation: validate_xml implies jing_invocation /= Void

end -- class GOA_APPLICATION_CONFIGURATION
