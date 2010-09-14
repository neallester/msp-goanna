note
	description: "HTTP status code constants from RFC 2068."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "HTTP Servlet API"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class GOA_HTTP_STATUS_CODES

feature -- Access

	Sc_continue: INTEGER = 100
			-- Client can continue.
			
	Sc_switching_protocols: INTEGER = 101
			-- The server is switching protocols according to Upgrade header.
			
	Sc_ok: INTEGER = 200
			-- Request succeeded normally.
			
	Sc_created: INTEGER = 201
			-- Request succeeded and created a new resource on the server.
	
	Sc_accepted: INTEGER = 202
			-- Request accepted, but processing not completed.
	
	Sc_non_authoritative_information: INTEGER = 203
			-- Metainformation in header not definitive.
	
	Sc_no_content: INTEGER = 204
			-- Request succeeded but no content is returned.
	
	Sc_reset_content: INTEGER = 205
			-- Resquest succeeded. User agent should clear document.
	
	Sc_partial_content: INTEGER = 206
			-- Partial GET request fulfilled.
	
	Sc_multiple_choices: INTEGER = 300
			-- Requested resource has multiple presentations.

	Sc_moved_permanently: INTEGER = 301
			-- Requested resource assigned new permanent URI.

	Sc_found: INTEGER = 302
			-- Resource has been moved temporarily.

	Sc_moved_temporarily: INTEGER = 302
			-- Resource has been moved temporarily. (Name kept for compatibility)

	Sc_see_other: INTEGER = 303
			-- Response to request can be found under a different URI, and
			--  SHOULD be retrieved using a GET method on that resource.

	Sc_not_modified: INTEGER = 304
			-- No body, as resource not modified.

	Sc_use_proxy: INTEGER = 305
			-- Requested resource MUST be accessed through proxy given by Location field. 

	Sc_temporary_redirect: INTEGER = 307
			-- Requested resource resides temporarily under a different URI.
	
	Sc_bad_request: INTEGER = 400
			-- The request could not be understood by the server due to malformed syntax.
			-- The client SHOULD NOT repeat the request without modifications.
			
	Sc_unauthorized: INTEGER = 401
			-- Request requires user authentication.
			
	Sc_payment_required: INTEGER = 402
			-- Reserved for future use.
			
	Sc_forbidden: INTEGER = 403
			-- Server understood request, but is refusing to fulfill it.
			
	Sc_not_found: INTEGER = 404
			-- Resource could not be found.
			
	Sc_method_not_allowed: INTEGER = 405
			-- Method in Request-Line not allowed for resource identified by Request-URI.
			
	Sc_not_acceptable: INTEGER = 406
			-- Resource identified by request is only capable of generating
			--  response entities which have content characteristics not acceptable
			--  according to accept headers sent in request.
			
	Sc_proxy_authentication_required: INTEGER = 407
			-- Client must first authenticate itself with the proxy.
			
	Sc_request_time_out: INTEGER = 408
			-- Cient did not produce a request within time server prepared to wait.
			
	Sc_conflict: INTEGER = 409
			-- Request could not be completed due to a conflict with current
			--  state of the resource.
			
	Sc_gone: INTEGER = 410
			-- Requested resource no longer available at server and no
			--  forwarding address is known.
			
	Sc_length_requied: INTEGER = 411
			-- Server refuses to accept request without a defined Content-Length.
			
	Sc_precondition_failed: INTEGER = 412
			-- Precondition given in one or more of request-header fields
			--  evaluated to false when it was tested on server.
			
	Sc_request_entity_too_large: INTEGER = 413
			-- Server is refusing to process a request because request
			--  entity is larger than server is willing or able to process.
			
	Sc_request_uri_too_large: INTEGER = 414
			-- Server is refusing to service request because Request-URI
			--  is longer than server is willing to interpret.
			
	Sc_unsupported_media_type: INTEGER = 415
			-- Unsupported media-type

	Sc_range_not_satisfiable: INTEGER = 416
			-- Range request-header conditions could not be satisfied.
			
	Sc_expectation_failed: INTEGER = 417
			-- Expectation given in Expect request-header field could not be met.
			

	Sc_internal_server_error: INTEGER = 500
			-- Internal server failure.
			
	Sc_not_implemented: INTEGER = 501
			-- Server does not support functionality required to service request.

	Sc_bad_gateway: INTEGER = 502
			-- Server received an invalid response from upstream server
	
	Sc_service_unavailable: INTEGER = 503
			-- Server is currently unable to handle request due to
			--  temporary overloading or maintenance of server.
	
	Sc_gateway_timeout: INTEGER = 504
			-- Server did not receive timely response from upstream server 
	
	Sc_http_version_not_supported: INTEGER = 505
			-- Server does not support HTTP protocol
			--  version that was used in the request message. 
	
	status_code_message (sc: INTEGER): STRING
			-- Return textual description for 'sc'
		local
			code_set, set_idx: INTEGER
		do
			code_set := sc // 100
			set_idx := sc - (code_set * 100) + 1
			if code_set <= 0 or code_set > status_messages.count then
				Result := "Invalid status code"
			else
				if set_idx > status_messages.item (code_set).count then
					set_idx := status_messages.item (code_set).count
				end
				Result := status_messages.item (code_set).item (set_idx)
			end
		end
	
feature {NONE} -- Implementation

	status_messages: ARRAY [ARRAY [STRING]]
			-- Default status descriptive messages
		local
			temp: ARRAY [STRING]
		once
			create Result.make (1, 5)
			-- informational messages
			temp := << 
				"Continue", -- 100
            	"Switching Protocols", -- 101
      			"Informational" -- 1xx
			>>
			Result.put (temp, 1)
			-- success messages
			temp := <<          
           		"OK", -- 200
				"Created", -- 201
				"Accepted", -- 202
				"Non-Authoritative Information", -- 203
				"No Content", -- 204
				"Reset Content", -- 205
				"Partial Content", -- 206
				"Success" -- 2xx
			>>
			Result.put (temp, 2)
			-- redirection messages
			temp := <<
				"Multiple Choices", -- 300
				"Moved Permanently", -- 301
				"found", -- 302
				"See Other", -- 303
				"Not Modified", -- 304
				"Use Proxy", -- 305
				"(Unused)", -- 306
				"Temporary Redirect", -- 307
				"Redirection" -- 3xx
			>>
			Result.put (temp, 3)
			-- client error messages
			temp := <<
				"Bad Request", -- 400
				"Unauthorized", -- 401
				"Payment Required", -- 402
				"Forbidden", -- 403
				"Not Found", -- 404
				"Method Not Allowed", -- 405
				"Not Acceptable", -- 406
				"Proxy Authentication Required", -- 407
				"Request Time-out", -- 408
				"Conflict", -- 409
				"Gone", -- 410
				"Length Required", -- 411
				"Precondition Failed", -- 412
				"Request Entity Too Large", -- 413
				"Request-URI Too Large", -- 414
				"Unsupported Media Type", -- 415
				"Requested Range Not Satisfiable", -- 416
				"Expectation Failed", -- 417
				"Client Error" -- 4xx
  			>>
			Result.put (temp, 4)
  			-- server error
			temp := <<
				"Internal Server Error", -- 500
				"Not Implemented", -- 501
				"Bad Gateway", -- 502
				"Service Unavailable", -- 503
				"Gateway Time-out", -- 504
				"HTTP Version not supported", -- 505
				"Server Error" -- 5xx
			>>
			Result.put (temp, 5)
		end
	
end -- class GOA_HTTP_STATUS_CODES
