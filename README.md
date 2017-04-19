Simple dockerized PHP project
====

## Containers

Main container was based on oficial [PHP7.1-FPM](https://github.com/docker-library/php/blob/ec02e1bcf1196ed3f8b74ecc956cf81554e32db8/7.1/fpm/Dockerfile).
Out of the box You will have container with PHP7.1 (including memcached, mongodb, geoip, amqp extensions), supervisord and git onboard.

`docker-compose.yml` brings dependencies to next containers:
 - mysql
 - mongodb
 - redis
 - memcached
 - rabbitmq
 
 ## HOWTO
 
 ### 1. How to run?
 
 - Install [`docker-ce`](https://docs.docker.com/engine/installation/#platform-support-matrix)
 - Install [`docker-compose`](https://docs.docker.com/compose/install/)
 - Run `docker-compose up`
    + If You need to customize services' ports then You need to specify them in _docker-compose.override.yml_ 
      or create new custom config file and specify it in `up` command (documentation [here](https://docs.docker.com/compose/extends/)):
      
    ```bash
      docker-compose -f docker-compose.yml -f docker-compose.dev.yml up
    ```
 _To get information about available containers and ports see `docker-compose.yml`_
 
 ### 2. How to use my ssh keys?
 
 Simply put your private key under `etc/ssh/`
 
 > Note that You will need to start `docker-compose build` after You will make any changes to configuration
 
 ### 3. How to configure PhpStorm and xdebug?
 
 You need to alias your local IP to something else : 
   - On Mac: `sudo ifconfig lo0 alias 10.254.254.254`
   - On Linux: `sudo ifconfig lo:1 10.254.254.254 up`
     
 in order to use XDebug properly ([source](https://forums.docker.com/t/ip-address-for-xdebug/10460/26)).

 Add `10.254.254.254` in _DBGp Proxy > Host setting_.
     
   - IDE key: _PHPSTORM_
   - Host: _10.254.254.254_
   - Port: _9089_
 
 
