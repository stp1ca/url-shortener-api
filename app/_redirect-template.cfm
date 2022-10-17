<cfoutput>#mid(cgi.script_name,2,5)#</cfoutput>

<!---   extract shortened url from addressbar URL   --->
<cfset shortenedURL = mid(cgi.script_name,2,5)>

<!---   fetch the url from db   --->
<cfquery name="getURL" datasource="#application.datasource#">
    select clickcount, url from urls 
    where shorturl = <cfqueryparam cfsqltype="cf_sql_varchar" value="#shortenedURL#">
</cfquery>

<!---   if it exists in db then we increment the count and redirect   --->
<cfif getURL.recordcount gt 0>
    <cfset newcount = getURL.clickcount + 1>
    <cfquery name="updateCount" datasource="#application.datasource#">
        update urls set clickcount = <cfqueryparam cfsqltype="cf_sql_int" value="#newcount#">
        where shorturl = <cfqueryparam cfsqltype="cf_sql_varchar" value="#shortenedURL#">
    </cfquery>
    <cflocation url="#getURL.url#">
</cfif>