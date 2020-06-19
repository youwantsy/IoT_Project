<%@ page contentType="text/html; charset=UTF-8"%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Insert title here</title>
		
		<link rel="stylesheet" href="${pageContext.request.contextPath}/resource/bootstrap/css/bootstrap.min.css">
		<script src="${pageContext.request.contextPath}/resource/jquery/jquery.min.js"></script>
		<script src="${pageContext.request.contextPath}/resource/popper/popper.min.js"></script>
		<script src="${pageContext.request.contextPath}/resource/bootstrap/js/bootstrap.min.js"></script>
		<link rel="stylesheet" href="${pageContext.request.contextPath}/resource/jquery-ui/jquery-ui.min.css">
		<script src="${pageContext.request.contextPath}/resource/jquery-ui/jquery-ui.min.js"></script>
		
		
		<script src="https://code.highcharts.com/stock/highstock.js"></script>
		<script src="https://code.highcharts.com/stock/modules/data.js"></script>
		<script src="https://code.highcharts.com/stock/modules/exporting.js"></script>
		<script src="https://code.highcharts.com/stock/modules/export-data.js"></script>
		
		<script src="https://cdnjs.cloudflare.com/ajax/libs/paho-mqtt/1.0.1/mqttws31.min.js" type="text/javascript"></script>
		
		<div id="container" style="height: 400px; min-width: 310px"></div>
		
		<script>
				$(function(){
					client = new Paho.MQTT.Client(location.hostname, 61614, new Date().getTime().toString());
					client.onMessageArrived = onMessageArrived;
					client.connect({onSuccess:onConnect});
				});
		
				function onConnect() {
					console.log("mqtt broker connected")
					client.subscribe("/ultra");
				}
				
				function onMessageArrived(message)
				{				
					if(message.destinationName =="/ultra")
					{
						const json2 = message.payloadString;
						const obj2 = JSON.parse(json2);
						
						$("#Ultrasonic").attr("value",obj2.Ultrasonic);
					}
		
		
				Highcharts.getJSON(json2,
						
				function (data) {
	
			    var startDate = new Date(data[data.length - 1][0]), // Get year of last data point
			        minRate = 1,
			        maxRate = 0,
			        startPeriod,
			        date,
			        rate,
			        index;
	
			    startDate.setMonth(startDate.getMonth() - 3); // a quarter of a year before last data point
			    startPeriod = Date.UTC(startDate.getFullYear(), startDate.getMonth(), startDate.getDate());
	
			    for (index = data.length - 1; index >= 0; index = index - 1) {
			        date = data[index][0]; // data[i][0] is date
			        rate = data[index][1]; // data[i][1] is exchange rate
			        if (date < startPeriod) {
			            break; // stop measuring highs and lows
			        }
			        if (rate > maxRate) {
			            maxRate = rate;
			        }
			        if (rate < minRate) {
			            minRate = rate;
			        }
			    }
	
			    // Create the chart
			    Highcharts.stockChart('container', {
	
			        rangeSelector: {
			            selected: 1
			        },
	
			        title: {
			            text: 'USD to EUR exchange rate'
			        },
	
			        yAxis: {
			            title: {
			                text: 'Exchange rate'
			            },
			            plotLines: [{
			                value: minRate,
			                color: 'green',
			                dashStyle: 'shortdash',
			                width: 2,
			                label: {
			                    text: 'Last quarter minimum'
			                }
			            }, {
			                value: maxRate,
			                color: 'red',
			                dashStyle: 'shortdash',
			                width: 2,
			                label: {
			                    text: 'Last quarter maximum'
			                }
			            }]
			        },
	
			        series: [{
			            name: 'USD to EUR',
			            data: data,
			            tooltip: {
			                valueDecimals: 4
			            }
			        }]
			    });
			});
		</script>
	</head>
	<body>
	</body>
</html>