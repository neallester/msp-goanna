Sample Goanna Application
Bachelor.exe
Author: Neal L. Lester (neal@3dsafety.com)
May 14, 2001

To Build the Application:

1) Install Apache, FastCGI, and Goanna as explained elsewhere.

2) Make the following changes to the Apache httpd.conf file (allowing for any changes to accommodate your configuration):

LoadModule fastcgi_module modules/mod_fastcgi.dll

FastCgiExternalServer "d:/goanna/examples/bachelor/EIFGEN/W_code/bachelor.exe" -host localhost:8000

Alias /FastCGI "d:/goanna/examples/bachelor/EIFGEN/W_code/bachelor.exe"

<Directory "d:goanna/examples/bachelor/EIFGEN/W_code">
  SetHandler fastcgi-script
	  AddHandler fastcgi-script exe fcgi
        Options Indexes MultiViews ExecCGI
        AllowOverride None
        Order allow,deny
        Allow from all
</Directory>

3) Make any necessary modifications to d:\goanna\examples\bachelor\ace.ace and d:\goanna\examples\bachelor\system_constants.e.

4) Freeze and run your system.  You should be able to access the application from a browser at the following URL:

	http://localhost/FastCGI/bachelor

Note: Logging in as an existing user may not work.

The Topics used in the application include:

bachelor_topic.e
	bachelor_topic_with_subtopics.e
		choosing_a_wife.e
		compatibility.e
	yes_no_topic.e
		she_is_pregnant.e
		has_a_girlfriend.e
		he_drinks.e
		she_drinks.e