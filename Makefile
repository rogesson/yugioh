build:
	docker-compose build

lint: build
	docker-compose run --rm app rubocop

bash: build
	docker-compose run --rm app /bin/bash

test: build
	docker-compose run --rm app rspec spec/
