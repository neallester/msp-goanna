note

	description: "Test SOAP Faults"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "test SOAP"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Colin Adams <colin@colina.demon.co.uk>"
	copyright: "Copyright (c) 2005 Colin Adams and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

	
deferred class SOAP_TEST_FAULT

inherit

	TS_TEST_CASE

	GOA_SOAP_MESSAGE_FACTORY

	KL_SHARED_STANDARD_FILES

feature -- Test

	test_parse_with_detail
			-- Test parse of test1.xml.
		local
			a_node: UT_URI
			a_processor: GOA_SOAP_TEST_PROCESSOR
		do
			create a_node.make ("http://goanna.sourceforge.net/test")
			create a_processor.make (a_node)
			a_processor.set_ultimate_receiver (True)
			a_processor.process (fault_message, base_uri) 
			assert ("Parse sucessful", a_processor.is_build_sucessful)
			assert ("Validation sucessful", a_processor.is_valid)
		end

	test_new_envelope
			-- Test construct a SOAP message.
		local
			an_envelope: GOA_SOAP_ENVELOPE
			a_body: GOA_SOAP_BODY
			a_node: UT_URI
			a_formatter: GOA_SOAP_NODE_FORMATTER
		do
			create a_node.make ("http://goanna.sourceforge.net/test")
			an_envelope := new_envelope
			a_body := new_body (an_envelope, a_node)
			assert ("Valid envelope", an_envelope.validated)
			--create a_formatter.make
			--a_formatter.set_output (std.output)
			--a_formatter.process_document (an_envelope.root_node)
		end

	test_bad_header
			-- Test generation of Fault for a bad header.
		local
			a_node: UT_URI
			a_processor: GOA_SOAP_TEST_PROCESSOR
		do
			create a_node.make ("http://goanna.sourceforge.net/test")
			create a_processor.make (a_node)
			a_processor.set_ultimate_receiver (True)
			a_processor.process (faulty_message_one, base_uri) 
			assert ("Parse sucessful", a_processor.is_build_sucessful)
		end

	test_version_mismatch
			-- Test construction of a VersionMismatch fault, with upgrade header
		local
			a_node: UT_URI
			a_processor: GOA_SOAP_TEST_PROCESSOR
		do
			create a_node.make ("http://goanna.sourceforge.net/test")
			create a_processor.make (a_node)
			a_processor.set_ultimate_receiver (True)
			a_processor.process (faulty_message_two, base_uri) 
			assert ("Parse error", not a_processor.is_build_sucessful)
		end

	test_not_understood
			-- Test construction of a MustUnderstand fault, with NotUnderstood headers.
		local
			a_node: UT_URI
			a_processor: GOA_SOAP_TEST_PROCESSOR
		do
			create a_node.make ("http://goanna.sourceforge.net/test")
			create a_processor.make (a_node)
			a_processor.set_ultimate_receiver (True)
			a_processor.process (faulty_message_three, base_uri) 
			assert ("No parse error", a_processor.is_build_sucessful)
		end

feature -- Access

	base_uri: UT_URI
			-- Base URI for all requests
		do
			create Result.make ("dummy:request-uri")
		end

feature -- Messages

	fault_message: STRING
			-- Example env:Fault
		once
			Result := "[
<?xml version="1.0" encoding="UTF-8" ?>
<env:Envelope xmlns:env="http://www.w3.org/2003/05/soap-envelope"
              xmlns:m="http://www.example.org/timeouts"
              xmlns:xml="http://www.w3.org/XML/1998/namespace">
<!-- Taken from: SOAP Version 1.2 Part 1: Messaging Framework, example 4 -->
 <env:Body>
  <env:Fault>
   <env:Code>
     <env:Value>env:Sender</env:Value>
     <env:Subcode>
      <env:Value>m:MessageTimeout</env:Value>
     </env:Subcode>
   </env:Code>
   <env:Reason>
     <env:Text xml:lang="en">Sender Timeout</env:Text>
   </env:Reason>
   <env:Detail>
     <m:MaxTime>P5M</m:MaxTime>
   </env:Detail>    
  </env:Fault>
 </env:Body>
</env:Envelope>

						   ]"
		end

	faulty_message_one: STRING
			-- Header has wrong namespace
		once
			Result := "[
<?xml version="1.0" encoding="UTF-8" ?>
<env:Envelope xmlns:env="http://www.w3.org/2003/05/soap-envelope"
              xmlns:m="http://www.example.org/timeouts"
              xmlns:xml="http://www.w3.org/XML/1998/namespace">
 <Header/>
 <env:Body>
 </env:Body>
</env:Envelope>
						   ]"
		end

	faulty_message_two: STRING
			-- Envelope has wrong namespace
		once
			Result := "[
<?xml version="1.0" encoding="UTF-8" ?>
<env:Envelope xmlns:env="http://www.w3.org/2001/03/soap-envelope">
 <env:Body>
 </env:Body>
</env:Envelope>
						   ]"
		end

	faulty_message_three: STRING
			-- Headers not understood
		once
			Result := "[
<?xml version="1.0" encoding="UTF-8" ?>
<env:Envelope xmlns:env="http://www.w3.org/2003/05/soap-envelope"
              xmlns:m="http://www.example.org/timeouts"
              xmlns:xml="http://www.w3.org/XML/1998/namespace">
				  <env:Header>
				  <unknown-header-one env:mustUnderstand="true" />
				  <unknown-header-two xmlns="http://www.example.org/unknown" env:mustUnderstand="true"/>
				  <optional-header-one />
				  <u:unknown-header-three xmlns:u="http://www.example.org/unknown-3" env:mustUnderstand="1" />
				  <optional-header-two  xmlns="http://www.example.org/unknown"/>
				  <u:unknown-header-three-next xmlns:u="http://www.example.org/unknown-3" env:role="http://www.w3.org/2003/05/soap-envelope/role/next" env:mustUnderstand="1" />
				  <u:non-targeted-header xmlns:u="http://www.example.org/unknown-3" env:role="http://www.w3.org/2003/05/soap-envelope/role/none" env:mustUnderstand="1" />
				  </env:Header>
				  <env:Body>
				  <fred />
				  <jim />
 </env:Body>
</env:Envelope>

						   ]"
		end

end -- class SOAP_TEST_FAULT
