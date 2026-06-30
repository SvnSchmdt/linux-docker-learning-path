# Cheat Sheet

## Linux – Navigation & Files

```bash
pwd                         # current directory
ls -lah                     # list with details, hidden, human sizes
cd -                        # go to previous directory
mkdir -p dir/sub            # create nested dirs
cp -r src/ dst/             # copy recursively
mv old new                  # move / rename
rm -rf dir/                 # delete recursively (CAREFUL)
find . -name "*.py"         # find by name
find . -type f -size +1M    # find files > 1MB
```

## Linux – Permissions

```bash
chmod 755 script.sh         # rwxr-xr-x
chmod 644 file.txt          # rw-r--r--
chmod 600 secret            # rw------- (owner only)
chmod +x script.sh          # add execute
chown user:group file       # change owner
ln -s target linkname       # create symlink
```

## Linux – Text Processing

```bash
grep -rn "pattern" .        # recursive search with line numbers
grep -i "error" app.log     # case-insensitive
grep -v "DEBUG" app.log     # exclude lines
sort file.txt | uniq -c | sort -rn  # count occurrences
wc -l file.txt              # count lines
tail -f app.log             # follow log file
find . | xargs grep "TODO"  # grep in found files
```

## Linux – Processes

```bash
ps aux | grep name          # find process
kill PID                    # graceful stop
kill -9 PID                 # force kill
pkill processname           # kill by name
jobs                        # list background jobs
command &                   # run in background
df -h                       # disk usage
free -h                     # memory usage
```

## Docker – Images

```bash
docker images               # list local images
docker pull nginx:alpine    # pull image
docker build -t name:tag .  # build from Dockerfile
docker tag src:tag dst:tag  # add tag
docker push user/image:tag  # push to registry
docker rmi image:tag        # remove image
docker image prune          # remove dangling images
```

## Docker – Containers

```bash
docker run -d --name web -p 8080:80 nginx  # run detached
docker run -it ubuntu bash              # interactive shell
docker run --rm myapp                   # auto-remove on exit
docker ps                               # running containers
docker ps -a                            # all containers
docker logs -f container                # follow logs
docker exec -it container bash          # shell in container
docker stop container                   # graceful stop
docker rm container                     # remove stopped
docker rm -f container                  # force remove running
docker container prune                  # remove all stopped
```

## Docker – Volumes & Networks

```bash
docker volume create mydata     # create volume
docker volume ls                # list volumes
docker volume rm mydata         # remove volume
docker volume prune             # remove all unused
docker network create mynet     # create network
docker network ls               # list networks
docker network rm mynet         # remove network
```

## Docker Compose

```bash
docker compose up -d            # start all (detached)
docker compose down             # stop and remove
docker compose down -v          # also remove volumes
docker compose ps               # service status
docker compose logs -f app      # follow service logs
docker compose exec app bash    # shell in service
docker compose build            # rebuild images
docker compose pull             # pull latest images
docker compose restart app      # restart one service
```
