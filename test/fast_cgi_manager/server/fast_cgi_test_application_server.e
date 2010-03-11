indexing
	description: "Application Server Used For Testing"
	author: "Neal Lester"
	date: "$Date$"
	revision: "$Revision$"

class

	FAST_CGI_TEST_APPLICATION_SERVER

inherit

	GOA_APPLICATION_SERVER
		select
			warn
		end
	GOA_FAST_CGI_SERVLET_APP
		rename
			warn as fcg_warn,
			meaning as exceptions_meaning,
			class_name as exceptions_class_name
		undefine
			initialise_logger, all_servlets_registered
		end

create

	make

feature

	command_line_ok: BOOLEAN is True

	register_servlets is
		do

		end





end
