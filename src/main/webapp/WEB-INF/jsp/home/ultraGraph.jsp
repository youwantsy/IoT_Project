<%@ page contentType="text/html; charset=UTF-8"%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>highcharts</title>
		<link rel="stylesheet" href="<%=application.getContextPath()%>/resources/bootstrap/css/bootstrap.min.css">
		<script src="<%=application.getContextPath()%>/resources/javascript/jquery.min.js"></script>
		<script src="<%=application.getContextPath()%>/resources/bootstrap/js/bootstrap.min.js"></script>	
		
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
		<!-- 택만씨가 넣은 부분 : 문제가 될 경우 빼버린다. -->
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
		<!-- 택만씨가 넣은 부분 마지막 부분: 문제가 될 경우 빼버린다. -->
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
			$(function(){
				client = new Paho.MQTT.Client(location.hostname, 61614, new Date().getTime().toString());
				client.onMessageArrived = onMessageArrived;
				client.connect({onSuccess:onConnect});
				
			});
			var chart;
			function onConnect(){
				console.log("mqtt broker connected")
				client.subscribe("/ultra");
				client.subscribe("/sensor");
			}

			function onMessageArrived(message) {					
				if(message.destinationName =="/ultra") 
				{	
					const json2 = message.payloadString;
					const obj2 = JSON.parse(json2);
					var series = chart.series[0];
		            var shift = series.data.length > 20;
		           	console.log(series.data)		            

 					const nDate = new Date();//.toLocaleString("ko-KR", {timeZone: "Asia/Seoul"});
					console.log(nDate);
					//var v = nDate.getSeconds();
					var v = nDate.getTime()+32400000; // 9시간을 더해서 대한민국 시간에 맞춤
		           // console.log(v);
					var t = parseFloat(parseFloat(obj2.Ultrasonic).toFixed(2)) 
					var a= {x:v,y:t}
					chart.series[0].addPoint(a, true, shift);
		            
				}
 				if(message.destinationName =="/sensor") 
				{	
					const json2 = message.payloadString;
					const obj2 = JSON.parse(json2);
					var series = chart.series[0];
		            var shift = series.data.length > 20;
		           	console.log(series.data)
		            

 					const nDate = new Date();//.toLocaleString("ko-KR", {timeZone: "Asia/Seoul"});
					console.log(nDate);
					var v = nDate.getTime()+32400000; // 9시간을 더해서 대한민국 시간에 맞춤
					var t = parseFloat(parseFloat(obj2.Thermister).toFixed(2)) 
					var a= {x:v,y:obj2.Photoresister}
					var a2= {x:v,y:t}
		            chart2.series[0].addPoint(a, true, shift);
		            chart3.series[0].addPoint(a2, true, shift);
		            ggas = parseInt(obj2.Gas);
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
				         max: 150,
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

	<body style = "background-color: rgb(0,0,0);">
	<div class="container-fluid">
		<div class="col">
			<div>
				<div style = "width:97%;  height:300px; outline:thick solid #000000;  margin-left: 20px; margin-top: 50px">
					<div id="container" class="chart_container" style="width:30%; float:left; height:280px; padding-top: 20px; padding-left: 25px;"></div>
						<div ><img id=mine_img src="${pageContext.request.contextPath}/resource/img/mine.png" style="position:absolute; color:red;right:0; top:0 ;margin-top: 450px; margin-right: 100px;width: 270px;height:220px"/></div>
						
						<figure class="highcharts-figure" style="float:right; padding-right: 50px; padding-top: 50px">
						    <div id="gas-detecter"  class="chart-container"></div>
						</figure>
				</div>
			</div>
		</div>
		<div class="col">
			<div>
				<div style = "width:97%; height:300px; outline:thick solid #000000;background-color: gray; margin-left: 20px;margin-top: 50px">
					<div id="container2" class="chart_container" style="width:30%;  height:280px; padding-top: 20px; padding-left: 25px;"></div>
				</div>
			</div>
		</div>
		<div class="col">	
			<div>
				<div style = "width:97%; height:300px; outline:thick solid #000000; background-color: gray;margin-left: 20px; margin-top: 50px;margin-bottom:20px">
					<div id="container3" class="chart_container" style="width:30%; height:280px; padding-top: 20px; padding-left: 25px;"></div>
				</div>
			</div>
		</div>
	</div>
		
	<!-- <script>
////////////////////////////////////////////////////GAS //////////////////////////////////////////63636363
	
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
			            text: 'Speed'
			        }
			    },

			    credits: {
			        enabled: false
			    },

			    series: [{
			        name: 'Speed',
			        data: [80],
			        dataLabels:{
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
	

			// The RPM gauge
			var chartRpm = Highcharts.chart('container-rpm', Highcharts.merge(gaugeOptions, {
			    yAxis: {
			        min: 0,
			        max: 5,
			        title: {
			            text: 'RPM'
			        }
			    },

			    series: [{
			        name: 'RPM',
			        data: [1],
			        dataLabels: {
			            format:
			                '<div style="text-align:center">' +
			                '<span style="font-size:25px">{y:.1f}</span><br/>' +
			                '<span style="font-size:12px;opacity:0.4">' +
			                '* 1000 / min' +
			                '</span>' +
			                '</div>'
			        },
			        tooltip: {
			            valueSuffix: ' revolutions/min'
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
			        inc = Math.round((Math.random() - 0.5) * 100);
			        newVal = point.y + inc;

			        if (newVal < 0 || newVal > 200) {
			            newVal = point.y - inc;
			        }

			        point.update(newVal);
			    }

			    // RPM
			    if (chartRpm) {
			        point = chartRpm.series[0].points[0];
			        inc = Math.random() - 0.5;
			        newVal = point.y + inc;

			        if (newVal < 0 || newVal > 5) {
			            newVal = point.y - inc;
			        }

			        point.update(newVal);
			    }
			}, 2000);
	</script> -->
	</body>

</html>					
					