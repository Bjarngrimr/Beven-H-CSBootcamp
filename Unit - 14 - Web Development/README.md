## Week 14 Homework: Web Development


---

### Questions 

Before you work through the questions below, please create a new file and record your answers there. This will be your homework deliverable.

#### HTTP Requests and Responses

Answer the following questions about the HTTP request and response process.

1. What type of architecture does the HTTP request and response process occur in?

    The HTTP request and response is based on the client/server based architecture  

2. What are the different parts of an HTTP request?

    HTTP requests are divided into three parts;  
    - Request line
    - Header
    - Body

3. Which part of an HTTP request is optional?

    Overall the only part of a HTTP request that is optional is the Body  

4. What are the three parts of an HTTP response?

    A HTTP response is also divided into three parts;  
    - Status line
    - Header
    - Body  

5. Which number class of status codes represents errors?

    For HTTP status codes the Fourth and Fith class represents error, Forth is Client errors and Fifth is Server Errors.  

6. What are the two most common request methods that a security professional will encounter?

    The two most common request methods are GET and POST  

7. Which type of HTTP request method is used for sending data?

    POST is used to send data  

8. Which part of an HTTP request contains the data being sent to the server?

    The BODY will contain the source code of the request.  

9. In which part of an HTTP response does the browser receive the web code to generate and style a web page?

    The BODY of the response contains the source code of the targeted page. 

#### Using curl

Answer the following questions about `curl`:

10. What are the advantages of using `curl` over the browser?

    Curl is always available even on a headless server, it is able to be used for automation of HTTP Requests, some browsers are limited in what you can do with the HTTP requests and responses.  

11. Which `curl` option is used to change the request method?

    The Option -X declares that we are using something other than the default GET request.  

12. Which `curl` option is used to set request headers?

    The Option -H will set the header name in enclosed quotes.  

13. Which `curl` option is used to view the response header?

    The Option -I will view the response header.  

14. Which request method might an attacker use to figure out which HTTP requests an HTTP server will accept?

    Primarily this can be achieved by using GET.  

#### Sessions and Cookies

Recall that HTTP servers need to be able to recognize clients from one another. They do this through sessions and cookies.

Answer the following questions about sessions and cookies:

15. Which response header sends a cookie to the client?

    ```HTTP
    HTTP/1.1 200 OK
    Content-type: text/html
    Set-Cookie: cart=Bob
    ```
    - Set-Cookie: cart=Bob sends the cookie to the client  

16. Which request header will continue the client's session?

    ```HTTP
    GET /cart HTTP/1.1
    Host: www.example.org
    Cookie: cart=Bob
    ```
    - Cookie: cart=Bob is connected the the session and will continue.  

#### Example HTTP Requests and Responses

Look through the following example HTTP request and response and answer the following questions:

**HTTP Request**

```HTTP
POST /login.php HTTP/1.1
Host: example.com
Accept-Encoding: gzip, deflate, br
Connection: keep-alive
Content-Type: application/x-www-form-urlencoded
Content-Length: 34
Upgrade-Insecure-Requests: 1
User-Agent: Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132 Mobile Safari/537.36

username=Barbara&password=password
```

17. What is the request method?

    POST.  

18. Which header expresses the client's preference for an encrypted response?

    Upgrade-Insecure-Requests: 1  

19. Does the request have a user session associated with it?

    No this request is establishing a session.  

20. What kind of data is being sent from this request body?

    Username and Password.  

**HTTP Response**

```HTTP
HTTP/1.1 200 OK
Date: Mon, 16 Mar 2020 17:05:43 GMT
Last-Modified: Sat, 01 Feb 2020 00:00:00 GMT
Content-Encoding: gzip
Expires: Fri, 01 May 2020 00:00:00 GMT
Server: Apache
Set-Cookie: SessionID=5
Content-Type: text/html; charset=UTF-8
Strict-Transport-Security: max-age=31536000; includeSubDomains
X-Content-Type: NoSniff
X-Frame-Options: DENY
X-XSS-Protection: 1; mode=block

[page content]
```

21. What is the response status code?

    200 OK.  

22. What web server is handling this HTTP response?

    Apache.  

23. Does this response have a user session associated to it?

    Yes, indicated by "Set-Cookie: SessionID=5"  

24. What kind of content is likely to be in the [page content] response body?

    It is likely that in [page content] there is HTML code for the requested page to be displayed or simple text.  

25. If your class covered security headers, what security request headers have been included?

    - Strict-Transport-Security: max-age=31536000; includeSubDomains  
    - X-Content-Type: NoSniff  
    - X-Frame-Options: DENY  
    - X-XSS-Protection: 1; mode=block  

#### Monoliths and Microservices

Answer the following questions about monoliths and microservices:

26. What are the individual components of microservices called?
    
    The individual components of micro services are called services.  

27. What is a service that writes to a database and communicates to other services?
    
    APIs will write and read data from databases and will allow for communication to other services.  

28. What type of underlying technology allows for microservices to become scalable and have redundancy?

    By using containers, such as Docker, we have a lightweight and simple solution to make microservices both scaleable and redundant.  

#### Deploying and Testing a Container Set

Answer the following questions about multi-container deployment:

29. What tool can be used to deploy multiple containers at once?

    Docker.  

30. What kind of file format is required for us to deploy a container set?

    A YAML file.  

#### Databases

31. Which type of SQL query would we use to see all of the information within a table called `customers`?
    
    - SELECT * FROM customers;  

32. Which type of SQL query would we use to enter new data into a table? (You don't need a full query, just the first part of the statement.)
   
    - INSERT INTO 'table name' (input data fields here)  
    - VALUES (add data in same order as fields)  

33. Why would we never run `DELETE FROM <table-name>;` by itself?
   
    By running this particular query we wouldn't delete a small piece of data but the WHOLE table!  

---

