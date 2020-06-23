<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

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
		
		<script src="https://code.highcharts.com/highcharts.js"></script>
		<script src="https://code.highcharts.com/highcharts-more.js"></script>
		<script src="https://code.highcharts.com/modules/solid-gauge.js"></script>
		<script src="https://code.highcharts.com/modules/exporting.js"></script>
		<script src="https://code.highcharts.com/modules/export-data.js"></script>
		<script src="https://code.highcharts.com/modules/accessibility.js"></script>
		
		<figure class="highcharts-figure">
		    <div id="container-speed" class="chart-container"></div>
		</figure>

		<script>
		
		$(function(){
			client = new Paho.MQTT.Client(location.hostname, 61614, new Date().getTime().toString());
			client.onMessageArrived = onMessageArrived;
			client.connect({onSuccess:onConnect});
		});
		
		function onConnect() {
			console.log("mqtt broker connected")
			client.subscribe("/sensor");
		}
		
		function onMessageArrived(message) {				
			if(message.destinationName =="/sensor") {
				const json2 = message.payloadString;
				const obj2 = JSON.parse(json2);
			}		

				var gaugeOptions = {
				    chart: {
				        type: 'solidgauge'
				    },
				    title: null,
				    pane: {
				        center: ['50%', '85%'],
				        size: '140%',
				        startAngle: -90,
				        endAngle: 90,
				        background: {
				            backgroundColor:
				                Highcharts.defaultOptions.legend.backgroundColor || '#EEE',
				            innerRadius: '60%',
				            outerRadius: '100%',
				            shape: 'arc'
				        }
				    },
				    exporting: {
				        enabled: false
				    },
				    tooltip: {
				        enabled: false
				    },
				    // the value axis
				    yAxis: {
				        stops: [
				            [0.1, '#55BF3B'], // green
				            [0.5, '#DDDF0D'], // yellow
				            [0.9, '#DF5353'] // red
				        ],
				        lineWidth: 0,
				        tickWidth: 0,
				        minorTickInterval: null,
				        tickAmount: 2,
				        title: {
				            y: -70
				        },
				        labels: {
				            y: 16
				        }
				    },
				    plotOptions: {
				        solidgauge: {
				            dataLabels: {
				                y: 5,
				                borderWidth: 0,
				                useHTML: true
				            }
				        }
				    }
				};
				
				// The speed gauge
				var chartSpeed = Highcharts.chart('container-speed', Highcharts.merge(gaugeOptions, {
				    yAxis: {
				        min: 0,
				        max: 200,
				        title: {
				            text: 'Gas'
				        }
				    },
				
				    credits: {
				        enabled: false
				    },
				
				    series: [{
				        name: 'Gas',
				        data: [80],
				        dataLabels: {
				            format:
				                '<div style="text-align:center">' +
				                '<span style="font-size:25px">{y}</span><br/>' +
				                '<span style="font-size:12px;opacity:0.4">km/h</span>' +
				                '</div>'
				        },
				        tooltip: {
				            valueSuffix: ' km/h'
				        }
				    }]
				}));

				// Bring life to the dials
				setInterval(function () {
				    // Speed
				    var point,
				        newVal,
				        inc;
				
				    if (chartSpeed) {
				        point = chartSpeed.series[0].points[0];
				        inc = obj2.Gas;
				        newVal = point.y + inc;
				
				        if (newVal < 0 || newVal > 200) {
				            newVal = point.y - inc;
				        }
				        point.update(newVal);
				    }
				}, 2000);
		</script>
	</head>
</html>