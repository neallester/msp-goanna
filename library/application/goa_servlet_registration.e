note
	description: "Objects that register application servlets"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class

	GOA_SERVLET_REGISTRATION

inherit

	SHARED_SERVLETS
	GOA_SHARED_SERVLET_MANAGER

feature

	register_servlet (servlet: GOA_APPLICATION_SERVLET)
			-- Register servlet
		require
			valid_servlet: servlet /= Void
			not_has_servlet: not servlet_manager.has_registered_servlet (servlet.name)
		do
			servlet_manager.register_servlet (servlet, servlet.name)
		end

	register_servlets
		do
			register_servlet (go_to_servlet)
			register_servlet (shut_down_server_servlet)
			register_servlet (secure_redirection_servlet)
			register_servlet (ping_servlet)
		end

	all_servlets_registered: BOOLEAN
		local
			has_this_servlet: BOOLEAN
		do
			Result := 	servlet_by_name.has (go_to_servlet.name_without_extension) and then
						servlet_manager.has_registered_servlet (go_to_servlet.name) and then
						servlet_by_name.has (secure_redirection_servlet.name_without_extension) and then
						servlet_manager.has_registered_servlet (secure_redirection_servlet.name) and then
						servlet_by_name.has (shut_down_server_servlet.name_without_extension) and then
						servlet_manager.has_registered_servlet (shut_down_server_servlet.name)
			if not Result then
				log_hierarchy.logger (configuration.application_log_category).error ("Missing A Standard Goanna Application Servlet (See GOA_APPLICATION_SERVER.all_servlets_registered)")
			end
			from
				servlet_by_name.start
			until
				servlet_by_name.after
			loop
				has_this_servlet := servlet_manager.has_registered_servlet (servlet_by_name.item_for_iteration.name)
				Result := Result and has_this_servlet
				if not has_this_servlet then
					log_hierarchy.logger (configuration.application_log_category).error ("Servlet " + servlet_by_name.key_for_iteration + " is not registered with GOA_APPLICATION_SERVER.servlet_manager")
				end
				servlet_by_name.forth
			end
		end

end
