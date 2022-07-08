
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

### To import prod db
```shell
# save last version
$ heroku pg:backups capture
# then download it
curl $(heroku pg:backups public-url -r prod) -o latest.dump
# import locally
pg_restore --verbose --clean --no-acl --no-owner -h localhost -U postgres -d booklet_byseven_co_development latest.dump
```
pg_restore --verbose --clean --no-acl --no-owner -h localhost -U postgres -d booklet_byseven_co_development latest.dump