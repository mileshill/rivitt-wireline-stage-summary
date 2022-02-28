docker-start-mysql:
	echo "Launching MySQL"
	docker run \
		--name mysql \
		--network="host" \
		--volume '${PWD}/scripts/sql:/docker-entrypoint-initdb.d' \
		--volume '${PWD}/data/mysql:/var/lib/mysql' \
		--volume "${PWD}/data/csv:/data" \
		-e MYSQL_ROOT_PASSWORD=admin \
		-e MYSQL_ROOT_USER=root \
		-p 3306:3006 \
		-d \
		mysql \
		--secure-file-priv='/data' \
		--local-infile=1


	echo "MySQL launch complete... Connection initialization delayed for 30 seconds."


docker-stop-mysql:
	echo "Stopping mysql"
	docker rm -f mysql

docker-start-grafana:
	echo "Starting Grafana"
	docker volume create grafana-storage
	docker run \
		--name grafana \
		--network="host" \
		--user "$(id -u)" \
		--volume "grafana-storage:/var/lib/grafana" \
		-p 3000:3000 \
		-d \
		grafana/grafana-oss
	echo "Grafana launch complete. Connection initialization delayed for 30 seconds"

docker-stop-grafana:
	docker rm -f grafana

load-data-wireline:
	python ${PWD}/main.py --filepath ${PWD}/data/csv/wireline_records.csv --db-table data

load-data-stage:
	python ${PWD}/main.py --filepath ${PWD}/data/csv/wireline_stages.csv --db-table stages

load-data-shots:
	python ${PWD}/main.py --filepath ${PWD}/data/csv/wireline_shots.csv --db-table shots

load-data: load-data-wireline load-data-stage load-data-shots
