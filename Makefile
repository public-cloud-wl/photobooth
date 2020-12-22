build:
	fpm -s dir -t rpm -n photobooth -v 0.0.2 --after-install ./after-install  ./photobooth=/usr/bin/ ./photobooth.service=/etc/systemd/system/photobooth.service ./static/=/var/www/photobooth/static/

