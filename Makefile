docker-up:
	docker-compose up -d

docker-down:
	docker-compose down

docker-console:
	docker exec -it $(shell docker ps -qf "name=easy-pairing-api") bash

rails-console:
	docker exec -it $(shell docker ps -qf "name=easy-pairing-api") bash -c "bin/rails c"

db-console:
	docker exec -it $(shell docker ps -qf "name=easy-pairing-db") psql -U postgres

db-reset:
	docker exec -it $(shell docker ps -qf "name=easy-pairing-api") bash -c "rake db:reset db:migrate"

app-log:
	docker logs -f easy-pairing-api

test: db-reset
	docker exec -it $(shell docker ps -qf "name=easy-pairing-api") bash -c "rspec spec/"
