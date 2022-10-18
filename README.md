# url-shortener-api 
By Stephen P (stp@stp1.ca)

## Description
This is a docker image containing a URL Shortener api service written in CFML and using MySQL as the database. 

You can pass it a URL and it will return a json containing the shortened URL back. 

Accessing the shortened URL will redirect you to the website of the original URL submitted to be shortened. 

## Customizations
The default hostname the system uses is 'localhost'. To deploy to production or test on the cloud you will need to edit the first line of code in /app/index.cfm to change the variable to the hostname or ip you are using it from.

## Starting the server
Docker Compose is used for this web application. To start the server you can use your command line tool to navigate to the folder where this project is located and type 'docker-compose up -d' to start up the services. 

NOTE: You may need to wait up to 5 minutes for the containers to be ready. 

The command  'docker-compose down' will bring down servers when you are finished using the application.

## Troubleshooting

Its important to note, that this application by default is using Ports 80 and 3306. If you have any existing services running on those ports the application will fail. You MUST stop all services on those ports before you begin using this application. Or you can edit the docker-compose.yml file to customize the port settings. 

## Usage


### Create A New Shortened URL
Example: 
Set a new shortened URL

http://localhost/?add=http://google.com

Will return:
 {"URL":"http://localhost/8ffde"} 

Visiting http://localhost/8ffde will redirect you to https://google.com

### Set a Custom URL of user's choice

To set your own shortened URL this system will accept the url parameter "customurl" which will allow the user to set their own desired shortened URL supporting up to 20 characters. 

Example: 
http://localhost/?add=http://google.com&customurl=goo 

Will return: 
{"URL":"http://localhost/goo"} 

### Remove A URL from the system
 To remove a URL from the system you can use parameter "remove"

 Example removal: 
 http://localhost/?remove=8ffde will remove the item returning: 

{"SUCCESS":"Removed: 8ffde"} 

### View statistics of URLs redirected from the application

Statistics are kept for all redirects. To view statistics you can visit: 
http://localhost/stats/

Note: Statistics are returned as json.