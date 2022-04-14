# Advanced Docker Infrastructure

This is an over the top complicated solution for calculating a Fibonacci number.
The purpose is to implement a multicontainer deployment.

* [Technologies](#technologies)
* [Overview](#overview)
* [Flow](#flow)
* [Nginx](#nginx)
* [Deployment](#deployment)
* [Run](#run)

### Technologies
* Docker
* React
* Nodejs
* Nginx
* Redis
* Postgres

### Overview
![](resources/images/overview.png)

### Flow
![](resources/images/flow.png)

1. The user writes a number and clicks the submit button.
2. The React application makes an Ajax request to the backend Express server.
3. The Express server stores the number in the Postgres database. The Express server will also
   store the number in the Redis Cache Store.
4. The Redis Cache Store will trigger a separate backend Nodejs process (worker).
5. The Worker watches Redis for new indices that show up. Anytime a new index shows up in Redis,
   the Worker is going to pull that value out and calculate the Fibonacci value for it and store the calculated
   value back in Redis.

### Nginx
The nginx server is going to look at the incomming requests and decide which
service to route the request to. The nginx routing is based on the url path:
* `/`: the request is routed to the React server.
* `/api`: the request is routed to the Express server.

The React server and Express server is "behind" nginx and cannot be accessed
unless you go through the nginx server (nginx refers to these as upstream servers).

![](resources/images/nginx-routing.png)

### Deployment
AWS...


### Run 

Start the containers 
```shell
docker-compose up
```
![](resources/images/containers.png)
![](resources/images/app.png)

