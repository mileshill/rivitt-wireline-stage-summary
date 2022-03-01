# Wireline Analysis
Get more value from your wireline data! [Rivitt](www.rivitt.com) collects real-time data from the wireline unit and streams the data
directly from the edge to your infrastructure. It's not just raw data, the [Rivitt](www.rivitt.com) engine detects events and computes
a stage summary. You can monitor and track wireline operations in real-time from the comfort the office. Morning reports
can be generated detailing the KPIs your team needs to know.

The screen shots below were generated using Grafana, a free open-source tool. You can create, change, or delete any
metrics not useful to your team. Grafana is a simple solution for real-time viewing. [Check out the live dashboard](https://miles1618.grafana.net/dashboard/snapshot/Aap5Pyvd0FcW1BNHsJw697tvKoIjYFRL)! 

[Rivitt Website](www.rivitt.com)
[Rivitt LinkedIn](https://www.linkedin.com/company/rivittenergy)

### Single Stage Summary
![Wireline Stage Summary](/static/wireline_grafana_stage.png?raw=True "Stage Summary")

Fields 
- Duration: total minutes from stage start to stage stop
- Total Depth: max depth measured during stage
- Depth Vertical: depth from surface to heel
- Depth Lateral: depth from heel to toe
- Charge Count: number of charges, including plug, during the stage
- Plug Depth: depth of plug
- Line Chart: measured depth, tension, and voltage
- CCL: measured depth and casing collar locator
- Charge Depth Table: time and depth of each charge
### Multi Stage Summary
![Wireline Stage Summary](/static/wireline_grafana_summary.png?raw=True "Multi Stage Summary")

Fields 
- Duration: sum of all minutes from all stages 
- Total Depth: sum of all max depths
- Total Depth Vertical: sum of depth from surface to heel for all stages
- Total Depth Lateral: sum of depth from heel to toe for all stages
- Total Charge Count: sum of number of charges, including plug, during all stages
- Total Plug Depth: depth of plug
- Line Chart: measured depth, tension, and voltage for all stages
- CCL: measured depth and casing collar locator for all stages
- 
### How it works?
![Rivitt Data Flow](/static/dataflow.png "Rivitt Data Flow")

[Rivitt](www.rivitt.com) captures raw data, aggregates at the IoT edge, applies proprietary analysis to generate each Wireline stage summary. 
Those summary can be aggregated using Excel, SQL, or any other data store and reporting system currently in use. After all,
it's just a JSON being delivered. 

With the data in hand, operators can detect performance trends, validate charge estimates and shipping request, and answer
the important questions. Statistical marketing can be implemented. Knowing gun failure rates, accident probability per 
hour and stage can be computed and used to highlight the safety and performance of your teams.

#### Raw Data, Events, Summaries
Raw data are sensor readings. They are real-time samples of the current state of the system.

Events are computed fields that detect key identifiers within the raw data.

Summaries aggregate and summarize data between events.

Using event detection we are able to build high-value stage summaries, similar to frac post job reports PJRs. Using [Rivitt](www.rivitt.com) summaries,
you will know how many guns fired yesterday, how many stages you ran per truck and total this week, and how many miles of depth your 
cables have descending.





```text
#  Raw measurements consumed from Wireline system
-0.061,0.37560000000000004,-2.9455999999999998,-12.0946,399.12,1584.7913,1062.5291,18422.7246,-0.1721,1579984141,,01/25/2020 02:29:01 PM
-0.09140000000000001,2.9915000000000003,-2.5248,-12.0946,398.75,1585.5417,1061.5334,18428.2832,0.0357,1579984142,,01/25/2020 02:29:02 PM
-0.12190000000000001,3.7519,-2.9455999999999998,-12.0946,399.37,1586.7914,1063.5247,18436.709,-0.2194,1579984143,,01/25/2020 02:29:03 PM
-0.21330000000000002,3.8127,-2.9455999999999998,-12.0946,404.25,1587.7916,1059.5422,18443.1328,0.2917,1579984144,,01/25/2020 02:29:04 PM
-0.09140000000000001,1.866,-2.9455999999999998,-8.0631,399.0,1588.792,1060.5378,18450.0332,0.217,1579984145,,01/25/2020 02:29:05 PM
0.030500000000000003,3.9952,-2.9455999999999998,-8.0631,396.87,1589.5313,1062.5291,18454.8086,-0.1779,1579984146,,01/25/2020 02:29:06 PM
-0.12190000000000001,2.1398,-2.9455999999999998,-8.0631,399.12,1590.7915,1059.5422,18463.0742,0.0235,1579984147,,01/25/2020 02:29:07 PM
-0.061,2.6265,-2.5248,-12.0946,399.5,1591.792,1075.472,18470.0664,0.0058000000000000005,1579984148,,01/25/2020 02:29:08 PM
-0.030500000000000003,2.6873,-2.9455999999999998,-12.0946,398.87,1592.5424,1069.4984,18474.791,-0.3119,1579984149,,01/25/2020 02:29:09 PM
```
```json
// Beautiful summary data engineered from raw source 
{
    "id": "cf1de56a-9882-11ec-8787-afba9208244b",  // Unique identifer locally generated
    "time_start": "2020-01-26 03:53:12", // UTC start detection
    "time_start_epoch": 1580010792,  // Unix epoch
    "time_end": "2020-01-26 05:15:30", // UTC end detection 
    "time_end_epoch": 1580015730, // Unix epoch
    "duration_total_minutes": 82, // Stage duration
    "depth_heel": 10451, // Wellbore heel
    "depth_vertical": 10246, // Surface to heel
    "depth_lateral": 8379, //  Heel to toe
    "depth_max": 18830, // Surface to toe
    "shots_count": 2,  // Detected shots (plug included)
    "shots": [
        {
            "timestamp": "2020-01-26 04:40:31", // UTC
            "timestamp_epoch": 1580013631, // Unix epoch
            "depth_shot": 18803, // Depth of shot
            "type": "plug"  // Plug goes first in Pump Down Plug and Perf
        },
        {
            "timestamp": "2020-01-26 04:41:01",
            "timestamp_epoch": 1580013661,
            "depth_shot": 18802,
            "type": "charge"
        },
}
```


## How to run
Launching is short with just a few steps.
1. Launch the services
2. Connect Grafana to MySQL datasource 
3. Upload Grafana JSON dashboard

### Launch Services
```shell
# Install python requirements!
pip install -f requirements.txt

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


