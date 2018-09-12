## WordFinder - sample Dancer2 web application.

## Dependencies:
* Dancer2
* Path::Tiny
* Algorithm::Permute
* App::Prove (if you want to run tests)

## Instructions:
1. git clone https://github.com/bdoliver/WordFinder.git
2. cd ./WordFinder
3. plackup ./bin/app.psgi

This will start the web server listening on port 5000.

Eg:
```bash
$ curl http://localhost:5000/ping
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0

$ curl http://localhost:5000/wordfinder/dgo
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    28    0    28    0     0     28      0 --:--:-- --:--:-- --:--:--   112
["do","dog","go","god","od"]
```

NB: The search algorithm is not particularly efficient. The longer the letter
sequence, the slower it will get (>10 chars is where it starts to get _really_
bad). Bear in mind this is only a sample application / proof of concept.

4. to run the tests (optional):

    prove -I./lib ./t


## Docker image:
A container image is publicly available on docker hub,
and may be run as follows:

```bash
sudo docker run --name bdo-wordfinder-app \
                -p 8080:5000
                -d bdoliver/bdo-wordfinder-app:latest
```

You can then test the application as described above by using port 8080
on the local host:

```bash
$ curl -v http://localhost:8080/ping
*   Trying 127.0.0.1...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 8080 (#0)
> GET /ping HTTP/1.1
> Host: localhost:8080
> User-Agent: curl/7.59.0
> Accept: */*
>
< HTTP/1.1 200 OK
< Server: Perl Dancer2 0.206000
< Content-Length: 0
< Content-Type: text/html
< Date: Wed, 12 Sep 2018 22:40:28 GMT
< Connection: keep-alive
<
* Connection #0 to host localhost left intact
$

$ curl -v http://localhost:8080/wordfinder/dgo
*   Trying 127.0.0.1...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 8080 (#0)
> GET /wordfinder/dgo HTTP/1.1
> Host: localhost:8080
> User-Agent: curl/7.59.0
> Accept: */*
>
< HTTP/1.1 200 OK
< Content-Type: application/json
< Transfer-Encoding: chunked
< Date: Wed, 12 Sep 2018 22:39:52 GMT
< Connection: keep-alive
<
* Connection #0 to host localhost left intact
["do","dog","go","god","od"]
$
```


