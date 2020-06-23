<%@ page contentType="text/html; charset=UTF-8"%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>highcharts</title>
		<link rel="stylesheet" href="<%=application.getContextPath()%>/resources/bootstrap/css/bootstrap.min.css">
		<script src="<%=application.getContextPath()%>/resources/javascript/jquery.min.js"></script>
		<script src="<%=application.getContextPath()%>/resources/bootstrap/js/bootstrap.min.js"></script>	
		
		<script src="<%=application.getContextPath()%>/resources/highcharts/code/highcharts.js"></script>
		<script src="<%=application.getContextPath()%>/resources/highcharts/code/themes/gray.js"></script>
		<script src="${pageContext.request.contextPath}/resource/jquery/jquery.min.js"></script>
		<script src="${pageContext.request.contextPath}/resource/popper/popper.min.js"></script>
		<script src="${pageContext.request.contextPath}/resource/bootstrap/js/bootstrap.min.js"></script>
		<link rel="stylesheet" href="${pageContext.request.contextPath}/resource/jquery-ui/jquery-ui.min.css">
		<script src="${pageContext.request.contextPath}/resource/jquery-ui/jquery-ui.min.js"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/paho-mqtt/1.0.1/mqttws31.min.js" type="text/javascript"></script>
		
		<script>
			$(function(){
				client = new Paho.MQTT.Client(location.hostname, 61614, new Date().getTime().toString());
				client.onMessageArrived = onMessageArrived;
				client.connect({onSuccess:onConnect});
			});
			var chart;
			function onConnect(){
				console.log("mqtt broker connected")
				client.subscribe("/ultra");
			}

			function onMessageArrived(message) {					
				if(message.destinationName =="/ultra") 
				{	
					
					console.log("씨1")
					const json2 = message.payloadString;
					console.log("씨2")
					const obj2 = JSON.parse(json2);
					console.log("씨3")
					var series = chart.series[0];
		            var shift = series.data.length > 20;
		           	console.log(series.data)
		            console.log("씨4")
		            

 					const nDate = new Date();//.toLocaleString("ko-KR", {timeZone: "Asia/Seoul"});
					console.log(nDate);
					//var v = nDate.getSeconds();
					var v = nDate.getTime()+32400000; // 9시간을 더해서 대한민국 시간에 맞춤
		           // console.log(v);
					var a= {x:v,y:obj2.Ultrasonic}
		            chart.series[0].addPoint(a, true, shift);
		            console.log("씨5")
		            //setTimeout(onMessageArrived, 2000);
		            console.log("씨6")
				}
			}
		
			$(function() {
			    chart = new Highcharts.Chart({
			        chart: {
			            renderTo: 'container',
			            defaultSeriesType: 'spline',
			            events: {
			                load: onMessageArrived
			            }
			        },
			        title: {
			            text: 'UltraSonic'
			        },
			        xAxis: {
			            type: 'datetime',
			            tickPixelInterval: 100,
			            maxZoom: 20 * 1000
			        },
			        yAxis: {
			            minPadding: 0.2,
			            maxPadding: 0.2,
			            title: {
			                text: 'Centimeter',
			                margin: 80
			            }
			        },
			        series: [{
			            name: 'Distance',
			            data: []
			        }]
			    });
			});		
						
		</script>
	</head>
	<body> 
		<div id="container" style="width:100%; height:400px;"></div>
		<div id="container2" style="width:100%; height:400px;"></div>
	</body>
</html>					
					