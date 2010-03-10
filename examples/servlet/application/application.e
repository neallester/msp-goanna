indexing
	description: "Example servlet application."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "examples"
	date: "$Date: 2006-04-16 23:42:40 -0700 (Sun, 16 Apr 2006) $"
	revision: "$Revision: 491 $"
	author: "Glenn Maughan <glennmaughan@users.sourceforge.net>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum License v2 (see forum.txt)."

class	APPLICATION
	
inherit

	GS_SERVLET_APPLICATION
		redefine
			default_create
		end
	
create

	default_create

feature {NONE} -- Initialisation

	default_create is
			-- Initialise
		do
			create queue
			Precursor
		end
		
feature {NONE} -- Implementation

	register_servlets is
			-- Register all servlets for this application
		local
			servlet: GOA_HTTP_SERVLET
			config: GOA_SERVLET_CONFIG
		do
			create config
			create {GOA_SNOOP_SERVLET} servlet.init (config)
			manager.registry.register_servlet (servlet, "snoop")
		end
		
	register_security is
			-- Register all security realms
		do
		end
		
	register_producers is
			-- Register all producers
		local
			producer: GS_REQUEST_PRODUCER
			--fast_cgi: GOA_FAST_CGI_CONNECTOR
			standalone: GOA_STANDALONE_CONNECTOR
		do			
			-- FastCGI connector on 9090
--			create fast_cgi.make (9090, 5)
--			create producer.make (Current, fast_cgi, queue)
--			processor.add_producer (producer)
			
			-- Standalone connector on 9080
			create standalone.make (9000, 5, "d:\temp", "")
			create producer.make ("producer-1", Current, standalone, queue)
			processor.add_producer (producer)
		end
		
	register_consumers is
			-- Register all consumers
		local
			c: INTEGER
			consumer: GS_REQUEST_CONSUMER
		do
			from
				c := 1
			until
				c > 1
			loop
				create consumer.make ("consumer-" + c.out, Current, queue)
				processor.add_consumer (consumer)
				c := c + 1
			end
		end

feature {NONE} -- Implementation

	queue: THREAD_SAFE_QUEUE [GS_QUEUED_REQUEST]
			-- Request queue
			
end -- class APPLICATION

