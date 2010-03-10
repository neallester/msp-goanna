APPLICATION LIBRARY
version 1.0
May 11, 2001
Author: Neal L. Lester (neal@3dsafety.com)
Copyright (c) 2001, Lockheed-Martin Space Systems Company

This library provides facilities to develop dynamic web based applications within the Goanna framework.

KNOWN LIMITATIONS

1) Uses ISE EiffelBase and the ISE Agent Syntax.
2) Uses the ISE v4.5 string.empty rather than string.is_empty
3) Some applications that use LOGIN_SEQUENCE are unable to retrieve stored user files (STORABLE retrieval error)
4) USER_LIST contains clear text password information, but is stored insecurely as an ISE STORABLE.
5) Identifiers (i.e. query_strings form element names, etc.) consist of easily spoofed strings that look like consequtive integers.  The sequences restart after 100,000,000 uses,leading to unpredictable behavior if the system is not shut down and restarted when the sequence restarts and the previously used identifiers are still active.
6) HTML generated doesn't always render the same under both Internet Explorer and Netscape
7) This version has only been tested under Windows NT 4.0.  Please advise if you are able to run it in another environment.
8) The fundamental design of this library is still evolving - especially the cluster TOPIC.  Contact the author (neal@3dsafety.com) to find out where it is going.

TO CREATE AN APPLICATION

1) Install Apache, FastCGI, Goanna & Associated Libraries as described elsewhere.

2) Add the following to your ace file:

	root
		application : "make"

3) In addition to cluster definitions for the Goanna & associated libraries, add the following to your project's ace file:

	bachelor : "d:\goanna\examples\bachelor" -- Replace with actual location
	application (bachelor) 	: 	"$\application";
	user (application)	:	"$\user";
	domain (application)	:	"$\domain";
	topic	(application)	: 	"$\topic";
	unique_string_sequence (application) 	: 	"$\unique_string_sequence";
	content_container (application) 	: 	"$\content_container";
	form_elements (content_container)	: 	"$\form_elements"
	forms (content_container) 		: 	"$\forms";
	page_sequence_elements (application) 	: 	"$\page_sequence_elements";

4) If necessary, add the following to the appropriate GOBO cluster in ace:

	exclude
		"arrayed_stack.e";
		"linked_list.e";
		"linked_queue.e";
	end

5) Copy the files in folder "application_specific" into your project's root_cluster or elsewhere.  Modify these classes directly rather than subclassing them.

6) Create a sub_class of USER and implement the deferred features.

7) Modify USER_ANCHOR to refer to your version of IMPLEMENTED_USER.

8) Modify SYSTEM_CONSTANTS to match your application's configuration.

9) Copy the files contained in application\data to the subdirectory indicated in SYSTEM_CONSTANTS.data_directory

10) Compile & Run your application.  You can access your application the same as any Goanna servlet.

11) See the application "bachelor" in the goanna\examples subdirectory for a sample application.

LIBRARY ARCHITECTURE

cluster APPLICATION

cluster USER

USER

The root of the application specific data model (every SESSION must have a USER).  Includes state information (i.e. a history of pages served to the user, current PAGE_SEQUENCE, etc.  Includes user preferences for language, type of client (to serve browser specific html), and image_size (to serve larger images to users with larger monitors and/or faster connections).  Hooks to the various preferences are in place, but currently only one option for each preference is supported - and changing preferences is not supported.

cluster CONTENT_CONTAINER

Contains abstractions for various html constructs.  Each content container stores it's content (e.g. text), and knows how to generate it's own html.  Very incomplete in terms of breadth and features; but there is enough to display a plain looking page.  

FORM and FORM_ELEMENT

Facilities for displaying and processing forms.

cluster PAGE_SEQUENCE_ELEMENT

PAGE_SEQUENCE_ELEMENT

An element of a page sequence.  Can be a PAGE or a PAGE_SEQUENCE.

PAGE_SEQUENCE

Contains the logic defining a sequence of pages displayed to the user.

PAGE

A single page, displayed to the user.  Created by PAGE_FACTORY which adds CONTENT_CONTAINERs to the page.  The CONTENT_CONTAINERs are displayed between a page_header and a page_footer that is displayed on every page in the application.  Each page is associated with a TOPIC (see the discussion of TOPIC below) which handles data manipulation & undo for that page.  

cluster TOPIC

A topic addressed by the application.  Many topics are also a PAGE_SEQUENCE and a DOMAIN.  When this is so, TOPIC comes to include the data, data manipulation routines, and page sequencing logic for a particular domain in the application data model.  These data manipulation routines are loaded by PAGE_FACTORY or FORM as agents into the appropriate DYNAMIC_URL or FORM_ELEMENT to allow the user to interact with the data model.

cluster DOMAIN

The data and data manipulation routines for a domain in the application data model.

cluster CONTENT

TEXT_LIST

All of the text shown to the user, located in a single class.

