To manually scan all the file:

```bash
docker exec -t -i owncloud /bin/bash
cd /var/www/owncloud
chpst -u fcgi-php:$(id -Gn fcgi-php | tr ' ' ':') ./occ files:scan --all
```
