<!--- set variable to control host name --->
<cfset hostnamevar = "localhost">

<!---   Init output struct   --->
<cfset outputStruct = StructNew("Ordered")>


<!---   Init error msg variable   --->
<cfset errorOutput = "">




<!--- -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- ADD Action -=-=-=-=-=-=-=-=-=-=-=-=-= ---->


<!---   Check for existance of "add" url param   --->
<cfif isdefined("url.add")>

    <!---   check for valid URL to be passed   --->
    <cfif NOT isValid("URL",url.add)>
        <cfset errorOutput = "Invalid URL was submitted.">
    </cfif>

    <!---  Check if user requested a custom shortened url   --->
    <cfif isdefined("url.customurl")>
            <!---  make sure its not more than 20 chars   --->
            <cfif len(url.customurl) lt 20>

               <!---  make sure it only contains letters and numbers   --->
               <cfif reFind("^.*[^a-zA-Z0-9 ].*$", url.customurl) gt 0>
                    <!--- invalid character found --->
                    <cfset errorOutput = "Invalid character's found in custom URL.">
                </cfif>
            <cfelse>
                <cfset errorOutput = "Custom URL was too long. Must be 20 charaters or less.">
            </cfif>


            <!---   make sure it not too short   --->
            <cfif len(url.customurl) lt 2>
                <cfset errorOutput = "Customer URL was too short. It must be 2 or more characters long.">
            </cfif>

            <cfset shortenedURL = url.customurl>

            <cfquery name="checkExists" datasource="#application.datasource#">
                select urlid from urls 
                where shorturl = <cfqueryparam cfsqltype="varchar" maxlength="20" value="#shortenedURL#">
            </cfquery>
            <cfif checkExists.recordcount gt 0>
                <cfset errorOutput = "The custom shortened url you supplied is already in use. Please try another.">
            </cfif>


    <cfelse>
            <!---   create a 5 char string to use as shortened url. 
            In this case i'm utilizing the hash() function and grabbing 
            first 5 chars   --->
            <cfset shortenedURL = lcase(left(hash(url.add),5))>
            
            <!---  check if the shortned url exists already and if so try another one 
            Hey its a hash so its unlikely, but then again we are only utilizing 5 chars
            so possibility for a collision exists so we do a quick check to make sure   --->
            <cfquery name="checkExists" datasource="#application.datasource#">
                select urlid from urls 
                where shorturl = <cfqueryparam cfsqltype="varchar" maxlength="20" value="#shortenedURL#">
            </cfquery>
            <!---  check query results and if its not 0 we create a new shornedURL variable   --->
            <cfif checkExists.recordcount gt 0>
                <!--- This time if it exists we inject the time 
                into the hashing algo to mix it up a bit   --->
                <cfset shortenedURL = lcase(left(hash(url.add & now()),5))>
            </cfif>


    </cfif>
    
    <!---  If no errors exist we can proceed to write the new shortned url to db   --->
    <cfif errorOutput is "">
        <cfquery name="inserturl" datasource="#application.datasource#">
            insert into urls (url,shorturl,datecreated,clickcount)
            values (<cfqueryparam cfsqltype="varchar" maxlength="500" value="#url.add#">,
                    <cfqueryparam cfsqltype="varchar" maxlength="20" value="#shortenedURL#">,
                    #now()#,
                    0)
        </cfquery>

        <!---  Lucee does not handle missing folders well so we create a folder 
        with the name of the shortneed url in it and copy in
        a template which will serve as the index.cfm of the new folder    --->
        <cfif not directoryExists("./" & shortenedURL)>
            <cfdirectory action="create" directory="#shortenedURL#">
            <cfset destVar =  "./" & shortenedURL & "/index.cfm">
            <cffile action = "copy" 
            source = "_redirect-template.cfm" 
            destination = "#destvar#">
        </cfif>
        
        
        
    </cfif>
  
    <!---  if an error does exist we create the "Error" struct element   --->
    <cfif errorOutput is not "">
        <cfset outputStruct.Error = errorOutput>
    <cfelse>
        <!--- if no error exists we set the "URL" struct element by combining our host
        address with the new shortned url string   --->
        <cfset outputStruct.URL = "http://#hostnamevar#/" & shortenedURL>
    </cfif>

    

</cfif>




<!--- -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- Remove Action -=-=-=-=-=-=-=-=-=-=-=-=-= ---->
<cfif isdefined("url.remove")>
    <!---  Check the input param   --->
    <!---  make sure its not more than 20 chars   --->
            <cfif len(url.remove) lt 20>

               <!---  make sure it only contains letters and numbers   --->
               <cfif reFind("^.*[^a-zA-Z0-9 ].*$", url.remove) gt 0>
                    <!--- invalid character found --->
                    <cfset errorOutput = "Invalid character's found in Shortened URL to remove.">
                </cfif>
            <cfelse>
                <cfset errorOutput = "Shortened URL to remove was too long. Must be 20 charaters or less.">
            </cfif>


            <!---   make sure it not too short   --->
            <cfif len(url.remove) lt 2>
                <cfset errorOutput = "Shortened URL to remove was too short. It must be 2 or more characters long.">
            </cfif>


            <cfif errorOutput is "">
                <cfquery name="checkExists" datasource="#application.datasource#">
                    select urlid from urls 
                    where shorturl = <cfqueryparam cfsqltype="varchar" maxlength="5" value="#url.remove#">
                </cfquery>
                

                <cfif checkExists.recordcount gt 0>
                    
                    <!---  remove file and dir   --->
                    <cffile action = "delete" file="./#url.remove#/index.cfm"> 

                    <cfdirectory action = "delete" directory = "#url.remove#"> 
                    
                    <!---  remove db record   --->
                    <cfquery name="removequery" datasource="#application.datasource#">
                        delete from urls 
                        where shorturl = <cfqueryparam cfsqltype="varchar" maxlength="5" value="#url.remove#">;
                    </cfquery>

                    <!---   set success struct    --->
                    <cfset outputStruct.Success = "Removed: " & url.remove>

                </cfif>

            </cfif>

</cfif>



<!--- If neither add or remove parameters are set we give a default message showing usage  --->
<cfif not isdefined("url.add") and not isdefined("url.remove")>
    <h1>Welcome to the url-shortner-api app</h1>
    <p>You are seeing this page becuase you have not passed the server any paramters.</p>
    <p><strong>Usage:</strong>
    <br>Example: 
    <br>Set a new shortened URL
    <br>
    <cfoutput>
        http://#hostnamevar#/?add=http://google.com
        <br>
        Will return:
        <br>{"URL":"http://#hostnamevar#/8ffde"} 
        <br><br>
        Visiting http://#hostnamevar#/8ffde will redirect you to https://google.com
        <br><br>
        To set your own shortened URL this system will accept the url parameter "customurl" which will allow the user to set their own desired shortened URL supporting up to 20 characters. 
        <br>
        Example: <br>
        http://#hostnamevar#/?add=http://google.com&customurl=goo 
        <br><br>
        Will return: <br>
        {"URL":"http://#hostnamevar#/goo"} <br>
        <br>

        To remove a URL from the system you can use parameter "remove"
        <br><br>
        Example removal: <br>
        http://#hostnamevar#/?remove=8ffde will remove the item returning: 
        <br><br>
        {"SUCCESS":"Removed: 8ffde"} 
        <br><br>
        Statistics are kept for all redirects. To view statistics you can visit:<br> 
        http://#hostnamevar#/stats/<br>
        <br>
        Note: Statistics are returned as json.
        <br>
    </cfoutput>
    </p>
<cfelse>
    <!---   serialize to JSON format our outputStruct variable   --->
    <cfoutput>#SerializeJSON(outputStruct)#</cfoutput>
</cfif>



