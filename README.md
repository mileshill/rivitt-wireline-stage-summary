# Wireline Analysis
### Single Stage Summary
![Wireline Stage Summary](/static/wireline_grafana_stage.png?raw=True "Stage Summary")

### Multi Stage Summary
![Wireline Stage Summary](/static/wireline_grafana_summary.png?raw=True "Multi Stage Summary")

## How to run
Launching is short with just a few steps.
1. Launch the services
2. Connect Grafana to MySQL datasource 
3. Upload Grafana JSON dashboard

### Launch Services
```shell
# Start MySQL
# The first initialization prevents connections for 
# up to 60 seconds. Be patient. Check the logs to verify.
make docker-start-mysql

# Start Grafana
# Just like MySQL, the initial setup takes about 60 seconds.
# Be patient. Check the logs to verify.
make docker-start-grafana

# Load the CSV data into SQL
make load-data
```

### Grafana
To configure grafana you will upload the dashboard template and connect
the datasource. Only two steps.

#### Login to local Grafana
From your browser, http://localhost:3000/login <br>
Username: `admin`
Password: `admin`

#### Connecting the datasource
On the left sidebar, go to the **gear** and then choose **data sources**.
You'll choose the **MySQL** source. Click the save and test.
If you get the green light, you're all set.

Connection params:
```shell
mysql_user=root
mysql_password=admin
host=localhost
port=3306
database=wireline
```

#### Upload the JSON dashboard
On the left sidebar, go to the **cross** symbol and then choose **upload**.
Select upload JSON file. The dashboard is located at `/path/to/project/wireline-grafana-mysql/data/grafana/dashboard.json`.
Once uploaded, you can go into the dashboard.


