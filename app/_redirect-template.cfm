<cfset shortenedURL = "">
<cfset start = 0>
<cfloop from="1" to="#len(cgi.script_name)#" index="x">
    <cfif mid(cgi.script_name,x,1) is "/">
        <cfset start = start + 1>
    </cfif>
    <cfif start is 1>
        <cfset shortenedURL = shortenedURL & mid(cgi.script_name,x,1)> 
    </cfif>
    <cfif start is 2>
        <cfbreak>
    </cfif>
</cfloop>

<cfset shortenedURL = mid(shortenedURL,2,len(shortenedURL) - 1)>

<cfoutput>
    #cgi.script_name#<br>
    #shortenedURL#
</cfoutput>



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