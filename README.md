# url-shortener-api 
By Stephen P (stp@stp1.ca)

## Description
This is a docker image containing a URL Shortener api service written in CFML and using MySQL as the database. 

You can pass it a URL and it will return a json containing the shortened URL back. 

Accessing the shortened URL will redirect you to the website of the original URL submitted to be shortened. 


## Starting the server
Docker Compose is used for this web application. To start the server you can use your command line tool to navigate to the folder where this project is located and type 'docker-compose up -d' to start up the services. 

NOTE: You may need to wait up to 2 minutes for the containers to be ready. 

The command  'docker-compose down' will bring down servers when you are finished using the application.

## Usage

Example: 
Set a new shortened URL

http://localhost/?add=http://google.com

Will return:
 {"URL":"http://localhost/8ffde"} 

 Visiting http://localhost/8ffde will redirect you to https://google.com

To set your own shortened URL this system will accept the url parameter "customurl" which will allow the user to set their own desired shortened URL supporting up to 20 characters. 

Example: 
http://localhost/?add=http://google.com&customurl=goo 

Will return: 
{"URL":"http://localhost/goo"} 


 To remove a URL from the system you can use parameter "remove"

 Example removal: 
 http://localhost/?remove=8ffde will remove the item returning: 

{"SUCCESS":"Removed: 8ffde"} 

Statistics are kept for all redirects. To view statistics you can visit: 
http://localhost/stats/

Note: Statistics are returned as json.