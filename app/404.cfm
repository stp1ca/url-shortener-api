<cfparam name="url.thePage" default="">

<cfif not len(trim(url.thePage))> <cflocation url="index.cfm" addToken="false"> </cfif>


<h2>404</h2>

<p> Sorry, but the page you requested, <cfoutput>#url.thePage#</cfoutput>, was not found on this site. </p>

