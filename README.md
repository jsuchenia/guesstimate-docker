# Docker version of getguesstimate

Docker version of getguesstimate WITHOUT PERSISTENCE

Upstream: https://github.com/getguesstimate/


## How to build it
```
docker build -t localhost/getguesstimate .
```

## How to run it
```
docker run --rm -it -p 4000:4000 -p 3000:3000 localhost/getguesstimate
```

Then you can visit http://localhost:3000/ - after around 30-60 seconds, as webpack build takes time
