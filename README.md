
# Transparent HTTP Cacheing Container using Squid.

This Dockerfile builds an Alpine Linux container using Squid configured to work in transparent mode as a small and fast caching web proxy.

### Why?

If you build a lot of containers, you might be spending a lot of time waiting for packages to download. Using Squid to cache downloads automatically saves time and bandwidth and it is totally transparent to you.

## Usage

This docker image is available as a trusted build on the docker index, so there's no setup required. Using this image for the first time will start a download. Further runs will be immediate, as the image will be cached locally.

The recommended way to run this container looks like this:

    docker run -d --name squid --net host --privileged riddopic/squid

Next on your docker host you will need to setup an IPtables rule to transparently route all HTTP requests through the proxy running in the container:

    iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to 3129 -w

### Inspecting the container

If you would like to have a look around or check the logs you can connect to the container using docker exec:

    docker exec -it squid /bin/ash

## Tuning

The container can be tuned using environment variables.

Variable | Description
------------ | -------------
`MAX_CACHE_OBJECT` | Squid has a maximum object cache size. Often when caching debian packages vs standard web content it is valuable to increase this size. Use the `-e MAX_CACHE_OBJECT=1024` to set the max object size (in MB).
`DISK_CACHE_SIZE` | The squid disk cache size can be tuned. use `-e DISK_CACHE_SIZE=5000` to set the disk cache size (in MB).
`SQUID_DIRECTIVES_ONLY` | The contents of squid.conf will only be what's defined in `SQUID_DIRECTIVES` giving the user full control of squid.
`SQUID_DIRECTIVES` | This will append any contents of the environment variable to squid.conf. It is expected that you will use multi-line block quote for the contents.

### Persistent Cache

When the container is terminated the cache is lost. To prevent this and maintain a persistent cache you can use a mounted volume. The cache location is `/var/cache/squid` so if you mount that as a volume you can get persistent caching. Use `-v /home/user/squid_cache:/var/cache/squid` in your command line to enable persistent caching.

## License
```
Author::   Stefano Harding <riddopic@gmail.com>
Copyright: 2014-2015, Stefano Harding

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
