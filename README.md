# NGINX / PHP-FPM / Postgres

A light-weight NGINX, PHP-FPM, Postgres and Supervisord container for Docker.

## Supervisord

Supervisord is used to run both NGINX and PHP-FPM at the same time, and is the process Docker starts when spinning up a container from the image we are building here.
