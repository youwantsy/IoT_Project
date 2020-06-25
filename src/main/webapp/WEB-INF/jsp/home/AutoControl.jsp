<%@ page contentType="text/html; charset=UTF-8"%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>highcharts</title>
		<link rel="stylesheet" href="${pageContext.request.contextPath}/resource/bootstrap/css/bootstrap.min.css">
		<script src="${pageContext.request.contextPath}/resource/jquery/jquery.min.js"></script>
		<script src="${pageContext.request.contextPath}/resource/popper/popper.min.js"></script>
		<script src="${pageContext.request.contextPath}/resource/jquery/jquery.min.js"></script>
		<script src="${pageContext.request.contextPath}/resource/popper/popper.min.js"></script>
		<script src="${pageContext.request.contextPath}/resource/bootstrap/js/bootstrap.min.js"></script>
		<link rel="stylesheet" href="${pageContext.request.contextPath}/resource/jquery-ui/jquery-ui.min.css">
		<script src="${pageContext.request.contextPath}/resource/jquery-ui/jquery-ui.min.js"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/paho-mqtt/1.0.1/mqttws31.min.js" type="text/javascript"></script>

		<script src="https://code.highcharts.com/highcharts.js"></script>
		<script src="https://code.highcharts.com/highcharts-more.js"></script>
		<script src="https://code.highcharts.com/modules/solid-gauge.js"></script>
		<script src="https://code.highcharts.com/modules/exporting.js"></script>
		<script src="https://code.highcharts.com/modules/export-data.js"></script>
		<script src="https://code.highcharts.com/modules/accessibility.js"></script>
		<script src="<%=application.getContextPath()%>/resources/highcharts/code/themes/gray.js"></script>
		
		<script src="${pageContext.request.contextPath}/resource/js/toggle_and_hover.js"></script>

		<!-- 이미지 위에 커서 있을 때 확대 되는 css chart_container:hover 까지 -->
		<style type="text/css">
	    	.toggleBG{background: #CCCCCC; width: 70px; height: 30px; border: 1px solid #CCCCCC; border-radius: 15px;}
	    	.toggleFG{background: #FFFFFF; width: 30px; height: 30px; border: none; border-radius: 15px; position: relative; left: 0px;}
		</style>
		
		<style>
		    .chart_container {
		    	overflow:hidden;
		        -webkit-transform:scale(1);
		        -moz-transform:scale(1);
		        -ms-transform:scale(1); 
		        -o-transform:scale(1);  
		        transform:scale(1);
		        -webkit-transition:.3s;
		        -moz-transition:.3s;
		        -ms-transition:.3s;
		        -o-transition:.3s;
		        transition:.3s;
		    }
		    .chart_container:hover{
		        -webkit-transform:scale(1.2);
		        -moz-transform:scale(1.2);
		        -ms-transform:scale(1.2);   
		        -o-transform:scale(1.2);
		        transform:scale(1.2);
		    }
        </style>
		<style>
		.highcharts-figure .chart-container {
			width: 300px;
			height: 200px;
			float: right;
		}
		
		.highcharts-figure, .highcharts-data-table table {
			width: 600px;
			margin: 0 auto;
		}
		
		.highcharts-data-table table {
		    font-family: Verdana, sans-serif;
		    border-collapse: collapse;
		    border: 1px solid #EBEBEB;
		    margin: 10px auto;
		    text-align: center;
		    width: 100%;
		    max-width: 500px;
		}
		.highcharts-data-table caption {
		    padding: 1em 0;
		    font-size: 1.2em;
		    color: #555;
		}
		.highcharts-data-table th {
			font-weight: 600;
		    padding: 0.5em;
		}
		.highcharts-data-table td, .highcharts-data-table th, .highcharts-data-table caption {
		    padding: 0.5em;
		}
		.highcharts-data-table thead tr, .highcharts-data-table tr:nth-child(even) {
		    background: #f8f8f8;
		}
		.highcharts-data-table tr:hover {
		    background: #f1f7ff;
		}
		
		@media (max-width: 600px) {
			.highcharts-figure, .highcharts-data-table table {
				width: 100%;
			}
			.highcharts-figure .chart-container {
				width: 300px;
				float: none;
				margin: 0 auto;
			}
		
		}
		</style>
	</head>
		<script>
			
		ggas = 0;
			var chart;
			
			$(function(){
				client = new Paho.MQTT.Client(location.hostname, 61614, new Date().getTime().toString());
				client.onMessageArrived = onMessageArrived;
				client.connect({onSuccess:onConnect});
			});

			function onConnect(){
				console.log("mqtt broker connected")
				client.subscribe("/ultra");
				client.subscribe("/sensor");
				
				message = new Paho.MQTT.Message('MODEOFF');
				message.destinationName = "/order/mode";
				client.send(message);
			}

			function onMessageArrived(message) {					
				if(message.destinationName =="/ultra") 
				{	
					const json2 = message.payloadString;
					const obj2 = JSON.parse(json2);
					var series = chart.series[0];
		            var shift = series.data.length > 20;
		           	console.log(series.data)		            

 					const nDate = new Date();
					console.log(nDate);
					//var v = nDate.getSeconds();
					var v = nDate.getTime()+32400000;
		           // console.log(v);
					var t = parseFloat(parseFloat(obj2.Ultrasonic).toFixed(2)) 
					var a= {x:v,y:t}
					chart.series[0].addPoint(a, true, shift);
					
					if (t <= 7){
		            	$("#attack_img").attr("src", "${pageContext.request.contextPath}/resource/img/attack.jpg")
		            }
		            else if (t > 7){
		            	$("#attack_img").attr("src", "${pageContext.request.contextPath}/resource/img/normal.jpg")
		            }
				}
 				if(message.destinationName =="/sensor") {	
					const json2 = message.payloadString;
					const obj2 = JSON.parse(json2);
					var series = chart.series[0];
		            var shift = series.data.length > 20;
		           	console.log(series.data)
		            
 					const nDate = new Date();
					console.log(nDate);
					var v = nDate.getTime()+32400000;
					
					var t = parseFloat(parseFloat(obj2.Thermister).toFixed(2)) 
					var vision = parseFloat(parseFloat(obj2.Photoresister))
					var a= {x:v,y:obj2.Photoresister}
					var a2= {x:v,y:t}
		            chart2.series[0].addPoint(a, true, shift);
		            chart3.series[0].addPoint(a2, true, shift);
		            ggas = parseInt(obj2.Gas);
		            
		            if(obj2.Tracking == "1"){
		            	$("#mine_img").attr("src", "${pageContext.request.contextPath}/resource/img/mine2.png")
		            }
		            else if(obj2.Tracking =="0"){
		            	$("#mine_img").attr("src", "${pageContext.request.contextPath}/resource/img/mine.png")
		            }
		            if(t >= 30){
		            	$("#heat_img").attr("src", "${pageContext.request.contextPath}/resource/img/overheat.png")
		            }
		            else if(t < 30){
	            		$("#heat_img").attr("src", "${pageContext.request.contextPath}/resource/img/overheat2.png")
	            	}
		            if (vision < 120){
		            	$("#night_img").attr("src", "${pageContext.request.contextPath}/resource/img/daytime.jpg")
		            }
		            else if (vision >= 120){
		            	$("#night_img").attr("src", "${pageContext.request.contextPath}/resource/img/night.jpg")
		            }
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
			            data: [],
			        	color: "#E613AE"
			        }]
			    });
			});
			 
			$(function() {
			    chart2 = new Highcharts.Chart({
			        chart: {
			            renderTo: 'container2',
			            defaultSeriesType: 'spline',
			            events: {
			                load: onMessageArrived
			            }
			        },
			        title: {
			            text: 'Photoresister'
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
			                text: 'Lux',
			                margin: 80
			            }
			        },
			        series: [{
			            name: 'LUX',
			            data: [],
			            color: '#F52023'
			        }]
			    });
			});
			
			 $(function() {
			    chart3 = new Highcharts.Chart({
			        chart: {
			            renderTo: 'container3',
			            defaultSeriesType: 'spline',
			            events: {
			                load: onMessageArrived
			            }
			        },
			        title: {
			            text: 'Thermister'
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
			                text: 'Temp',
			                margin: 80
			            }
			        },
			        series: [{
			            name: 'Thermister',
			            data: [],
			            color: '#88E0FD'
			        }]
			    });
			});  
			 
			 $(function() {
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
				 var chartSpeed = Highcharts.chart('gas-detecter', Highcharts.merge(gaugeOptions, {
				     yAxis: {
				         min: 50,
				         max: 90,
				         title: {
				             text: 'Gas'
				         }
				     },
				     credits: {
				         enabled: false
				     },
				     series: [{
				         name: 'Gas',
				         data: [0],
				         dataLabels: {
				             format:
				                 '<div style="text-align:center">' +
				                 '<span style="font-size:25px; color:white">{y}</span><br/>' +
				                 '<span style="font-size:15px; color:white; opacity:0.4">wei</span>' +
				                 '</div>'
				         },
				         tooltip: {
				             valueSuffix: 'wei'
				         }
				     }]
				 }));

				 // Bring life to the dials
				 setInterval(function () {
				     // Speed
				     var point

				     if (chartSpeed) {
				         point = chartSpeed.series[0].points[0];

				         if (ggas > 0 || ggas < 100) {
					         point.update(ggas);
				         }
				     }
				 }, 1000);
			 });
		</script>
	<body>
		<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
		  <a class="navbar-brand">Current Mode Status:&nbsp;&nbsp;&nbsp;&nbsp;AUTO</a>
		  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
		    <span class="navbar-toggler-icon"></span>
		  </button>
		
		  <div class="collapse navbar-collapse" id="navbarSupportedContent">
		  	<ul class="navbar-nav mr-auto">
		      <li class="nav-item active">
		        <a class="nav-link" href="#"> <span class="sr-only">(current)</span></a>
		      </li>
		    </ul>
		    <form class="form-inline my-2 my-lg-0">
		    	<a class="navbar-brand" href="${pageContext.request.contextPath}/home/main.do">HOME&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</a>
		    	<a class="navbar-brand" href="ManualControl.do">Convert to Manual Control Mode</a>	
		    </form>
		  </div>
		</nav>

		<div class="container-fluid" style="background-color: black;height:100%">
		
			<div class="col">
				<div>
					<div style = "width:97%;  height:300px; margin-left: 20px; margin-top: 0px">
						<div id="container" class="chart_container" style="width:30%; float:left; height:280px; padding-top: 20px; padding-left: 25px;"></div>
						<figure class="highcharts-figure" style="float:right; padding-right: 50px; padding-top: 50px">
						    <div id="gas-detecter"  class="chart-container"></div>
						</figure>
					</div>
				</div>
			</div>
			
			<div class="col">
				<div>
					<div style = "width:97%; height:300px; margin-left: 20px;margin-top: 50px">
						<div id="container2" class="chart_container" style="width:30%;  height:280px; padding-top: 20px; padding-left: 25px;"></div>
					</div>
				</div>
			</div>
			
			<div class="col">
				<div>
					<div style = "width:97%; height:300px; margin-left: 20px; margin-top: 50px;margin-bottom:0px">
						<div id="container3" class="chart_container" style="width:30%; height:280px; padding-top: 20px; padding-left: 25px;"></div>
					</div>
				</div>
			</div>
			
			<div><img id=attack_img style="position:absolute; color:red;right:0; top:0 ;margin-top: 70px; margin-right: 800px;width: 550px;height:280px"/></div>
			<div><img id=mine_img  style="position:absolute; color:red;right:0; top:0 ;margin-top: 440px; margin-right: 100px;width: 270px;height:220px"/></div>
			<div><img id=heat_img  style="position:absolute; color:red;right:0; top:0;margin-top: 750px; margin-right: 100px;width: 220px;height:220px"/></div>
			<div><img id=night_img style="position:absolute; color:red;right:0; top:0;margin-top: 420px; margin-right: 800px;width: 550px;height:280px"/></div>
		</div>
	</body>
</html>