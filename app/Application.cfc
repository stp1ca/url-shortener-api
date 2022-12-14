<cfcomponent
	displayname="Application"
	output="true"
	hint="Handle the application.">
	<cfscript>
		this.datasources["appdatabase"] = {
			class: 'com.mysql.cj.jdbc.Driver'
			, bundleName: 'com.mysql.cj'
			, bundleVersion: '8.0.19'
			, connectionString: 'jdbc:mysql://appdb:3306/appdatabase?characterEncoding=UTF-8&serverTimezone=America/Vancouver&maxReconnects=3'
			, username: 'root'
			, password: "encrypted:b8f1c97924a3bf896be9d7c322fc1094c43a423071ba1cc3e30b459890173ba2"
			
			// optional settings
			, connectionLimit:100 // default:-1
			, liveTimeout:15 // default: -1; unit: minutes
			, alwaysSetTimeout:true // default: false
			, validate:true // default: false
  		};
	</cfscript>	 
	
	<!--- Set up the application. --->
	<cfset THIS.Name = "URLShortenerAPI" />
	<cfset THIS.ApplicationTimeout = CreateTimeSpan( 0, 0, 1, 0 ) />
	<cfset THIS.SessionManagement = true />
	<cfset THIS.SetClientCookies = false />



	<!--- Define the page request properties. --->
	<cfsetting
		requesttimeout="20"
		showdebugoutput="false"
		enablecfoutputonly="false"
		/>


	<cffunction
		name="OnApplicationStart"
		access="public"
		returntype="boolean"
		output="false"
		hint="Fires when the application is first created.">
            <cfset application.datasource = "appdatabase">

		<!--- Return out. --->
		<cfreturn true />
	</cffunction>


	<cffunction
		name="OnSessionStart"
		access="public"
		returntype="void"
		output="false"
		hint="Fires when the session is first created.">

		<!--- Return out. --->
		<cfreturn />
	</cffunction>


	<cffunction
		name="OnRequestStart"
		access="public"
		returntype="boolean"
		output="false"
		hint="Fires at first part of page processing.">

		<!--- Define arguments. --->
		<cfargument
			name="TargetPage"
			type="string"
			required="true"
			/>

			<!--- RESET APP? --->
			<cfif isdefined("url.reinit")>
				<cfset OnApplicationStart()>
				<cfset OnSessionStart()>
			</cfif>

		<!--- Return out. --->
		<cfreturn true />
	</cffunction>


	<cffunction
		name="OnRequest"
		access="public"
		returntype="void"
		output="true"
		hint="Fires after pre page processing is complete.">

		<!--- Define arguments. --->
		<cfargument
			name="TargetPage"
			type="string"
			required="true"
			/>

		<!--- Include the requested page. --->
		<cfinclude template="#ARGUMENTS.TargetPage#" />

		<!--- Return out. --->
		<cfreturn />
	</cffunction>


	<cffunction
		name="OnRequestEnd"
		access="public"
		returntype="void"
		output="true"
		hint="Fires after the page processing is complete.">

		<!--- Return out. --->
		<cfreturn />
	</cffunction>


	<cffunction
		name="OnSessionEnd"
		access="public"
		returntype="void"
		output="false"
		hint="Fires when the session is terminated.">

		<!--- Define arguments. --->
		<cfargument
			name="SessionScope"
			type="struct"
			required="true"
			/>

		<cfargument
			name="ApplicationScope"
			type="struct"
			required="false"
			default="#StructNew()#"
			/>

		<!--- Return out. --->
		<cfreturn />
	</cffunction>


	<cffunction
		name="OnApplicationEnd"
		access="public"
		returntype="void"
		output="false"
		hint="Fires when the application is terminated.">

		<!--- Define arguments. --->
		<cfargument
			name="ApplicationScope"
			type="struct"
			required="false"
			default="#StructNew()#"
			/>

		<!--- Return out. --->
		<cfreturn />
	</cffunction>


	<cffunction
		name="OnError"
		access="public"
		returntype="void"
		output="true"
		hint="Fires when an exception occures that is not caught by a try/catch.">
		<!--- Define arguments. --->
		<cfargument
			name="Exception"
			type="any"
			required="true"
			/>

		<cfargument
			name="EventName"
			type="string"
			required="false"
			default=""
			/>


			<!---  Display Error on page. Remove these lines to secure application   --->
			<p><cfoutput>OnError event: #arguments.eventName#</cfoutput></p>
			<cfdump var="#arguments.exception#" label="OnError: exception"> 

		<!--- Return out. --->
		<cfreturn />
	</cffunction>
	

	<!--- Handle 404's --->
	<cffunction name="onMissingTemplate" returnType="boolean" output="false"> 
		<cfargument name="thePage" type="string" required="true"> 
		<cflog file="cfblgogersmissingfiles" text="#arguments.thePage#"> 
		<cflocation url="404.cfm?thepage=#urlEncodedFormat(arguments.thePage)#" addToken="false"> 
	</cffunction>
</cfcomponent>