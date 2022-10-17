<cfquery name="getStats" datasource="#application.datasource#">
    select * from urls
</cfquery>

<cfoutput>#SerializeJSON(getStats)#</cfoutput>