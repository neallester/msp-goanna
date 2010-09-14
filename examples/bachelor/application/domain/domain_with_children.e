note
	description: "Domains that have children"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "FastCGI Applications"
	date: "$Date: 2001/06/13"
	revision: "$Revision: 491 $"
	author: "Neal L. Lester <neal@3dsafety.com>"
	copyright: "Copyright (c) 2001 Lockheed-Martin Space System Company"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class
	DOMAIN_WITH_CHILDREN

inherit
	DOMAIN
		export {DOMAIN_WITH_PARENT}
			initialized
		end

feature

	receive_child_notification (child: DOMAIN_WITH_PARENT)
			-- Receive notification that child was updated and process
		require
			child_of_current: child.parent = current	
		do
			update_time_last_modified (child.time_last_modified)
			process_child_notification (child)
		ensure
			time_last_modified_updated: time_last_modified = child.time_last_modified
		end

	initialize
		do
			if not domain_with_children_initialized then
				create child_list.make
				create_children
				domain_with_children_initialized := true
			end
		end

	reset
		do
			from
				child_list.start
			until
				child_list.after
			loop
				child_list.item_for_iteration.reset
				child_list.forth
			end
		end

	evaluated : BOOLEAN
		do
			from
				result := true
				child_list.start
			until
				child_list.after or (result = false)
			loop
				result := child_list.item_for_iteration.evaluated
				child_list.forth
			end
		end

feature {NONE}

	child_list: DS_LINKED_LIST [DOMAIN_WITH_PARENT]

	create_children
			-- Create children and add them to child_list
		deferred
		end

	process_child_notification (child: DOMAIN_WITH_PARENT)
			-- Do whatever processing is necessary due to child_notification
			-- Note: processing specific to a child should generally be done in that child.
		do
		end

	domain_with_children_initialized: BOOLEAN
			-- the children aspect of this domain has been initialized

feature

	initialized: BOOLEAN
		do
			result := domain_with_children_initialized
		end

invariant

	child_list_exists: child_list /= Void
	initialized_implies_domain_with_children_initialized: initialized implies domain_with_children_initialized

end -- class DOMAIN_WITH_CHILDREN
