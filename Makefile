docker-up:
	docker-compose up -d

docker-down:
	docker-compose down

app-log:
	docker logs -f easy-pairing-api

rails-console:
	docker exec -it $(shell docker ps -qf "name=easy-pairing-api") bash -c "bin/rails c"

db-console:
	docker exec -it $(shell docker ps -qf "name=easy-pairing-db") psql -U postgres
