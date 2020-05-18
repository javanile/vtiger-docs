
update:
	bash update.sh
parse:
	docker run --rm -v $${PWD}:/app -u $$(id -u) -w /app php -f parse.php $(take)

