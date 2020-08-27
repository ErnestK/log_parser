# Parser log

## Task description
Write a ruby script that:            
a. Receives a log as argument            
b. Returns the following:            
list of webpages with most page views ordered from most pages views to less page views e.g.:          
`/home 90 visits /index 80 visits etc...`          
list of webpages with most unique page views also ordered:                    
`/about/2 8 unique views /index 5 unique views etc...`          

**SOLID, DDD for you classes**            
**Show work with repositories, monads, DDD... Not just do task as simply as possible( even if its smart decision ) because this project demo**                                          
**Data structure for the log and entities, not hashes**                      
          
## How to install section 
To install project you should
- clone project
- execute `cd log_parser`  in console            
- execute `bundle install` in console        
- execute `docker-compose up -d` in console to run the container with Redis. For development it was decided to bring the database into the container.

## How to run app
After you have completed step "How to install section", you should
- execute `./bin/main test_1.log` or `./bin/main webserver.log`, in console           
Both files provided in repo.

## How to run specs
After you have completed step "How to install section", you should
- execute `rspec` in console - to run all tests
- execute `rubocop` in console - to run checking cops
- execute `reek` in console - to run checking the smells

## Approach description
The project was carried out with an emphasis on scalability,          
as a demonstration of working with repositories, monads, DDD...          
The project could have been easier but more boring.          

### Database
Redis was chosen as the database, it works quickly on the operations that were necessary to process the task.           
and the problem with migrations was gone           

### Env flag
We have the dotenv configuration, 
Here host for db is defined. By default, this is localhost.
Also there is a flag for checking the IP address, 
by default it is disabled and the IP is not checked for validity, 
since the webservice.log file contains too bad IPS.
But it can be converted to `true` and the check will turn on

### Repositories
Since the interviewers asked me to use the DDD methodology patterns, I decided to use the repository pattern.                                   
I developed it inspired by the spring boot repository.           
We describe repositories without being tied to a database and the methods that we want to execute on db            
(in Kotlin, these are just interfaces, we had to use modules but prohibit calling them directly, it's a pity that there are no abstract methods in Ruby),           
           
And then we write the implementation for the database           
As a result, the business logic does not know at all about the database and how the code is executed,            
and it is extremely easy to change the database to another database.           
It is also more convenient to test and maintain the code.           
           
### Service
The main place for storing business logic is in services.           
Gem dry-monads was used           
And they are built according to several rules!           
- Each of them has only one public calling method `call`.                      
- Verb naming           
- Each of them works in a monad           
- Each of them returns Success or Failure           
- Doesn't crash on error (we can always expand the result and process / render it and not just show 500 code)           
           
So we get that we can easily associate them with each other.
It is also more convenient to test and maintain the code.    

### Config
Since the task was supposed to develop a script without rails,           
we did not have initializers where you can initialize the connection to the database.           
A config file was created that is initialized when the script is launched,           
and is thrown Db connection into every service which works with the database so as not to reopen the connection.           

### Parsers
Parsers and validation rules are determined by the "Parsers" service,             
a parser for files with the ".log" extension was developed.             
You can easily add other parsers and add them in the "FileParserService", then you can parse files with other extensions             

### Printers
The task required that the report should be displayed in the stdout,
it was realized by the "printer"
which can be easily changed to any other printer that can output data to the database, file ...
You need to implement a class with the same methods and replace it when initializing the config

### File reading
File reads in stream without full loading in memory

## Possible Improvements (ideas)
- Clear redis after each specs during gem or spec helper, a module was used that was supposed to do this, but it is unstable.         
I had to use before each block.            
- Maybe should persist history for each files. But this is outscope of task.     
- Add new printers(file..) and parsers(csv, json, xml..). Adding in project is very simple need only implemenatation.        
- If we use this script for delayed jobs on many files, we can think about parallelization of code.           
- Add new repo implentation( mongo, postgres.. )
- CI label
