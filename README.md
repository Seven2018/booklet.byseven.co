
### To run the projet with docker
first of all install:
* [docker](https://docs.docker.com/get-docker/)
* [docker-compose](https://docs.docker.com/compose/install/)

then you can run
```shell
> ./before_run_docker.sh
> docker-compose up
```
now you can go to the website [http://localhost:3000](http://localhost:3000)

### To enable pry debugging on rails with docker:
```shell
Win#1 > docker-compose up
Win#2 > docker attach $(docker-compose ps -q rails)
```
Any `binding.pry` will be handle on the attachement window.
