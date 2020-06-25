<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<title>Manual Control Mode</title>
		<link rel="stylesheet" href="${pageContext.request.contextPath}/resource/bootstrap/css/bootstrap.min.css">
		<script src="${pageContext.request.contextPath}/resource/jquery/jquery.min.js"></script>
		<script src="${pageContext.request.contextPath}/resource/popper/popper.min.js"></script>
		<script src="${pageContext.request.contextPath}/resource/bootstrap/js/bootstrap.min.js"></script>
		<link rel="stylesheet" href="${pageContext.request.contextPath}/resource/jquery-ui/jquery-ui.min.css">
		<script src="${pageContext.request.contextPath}/resource/jquery-ui/jquery-ui.min.js"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/paho-mqtt/1.0.1/mqttws31.min.js" type="text/javascript"></script>
		<script src="${pageContext.request.contextPath}/resource/jquery-ui/jQueryRotate.js"></script>

		<script>
			$(function(){
				client = new Paho.MQTT.Client(location.hostname, 61614, new Date().getTime().toString());
				client.onMessageArrived = onMessageArrived;
				client.connect({onSuccess:onConnect});
			});

			function onConnect() {
				console.log("mqtt broker connected")
				client.subscribe("/sensor");
				client.subscribe("/camerapub");
				client.subscribe("/ultra");
				
				message = new Paho.MQTT.Message('MODEON');
				message.destinationName = "/order/mode";
				client.send(message);
			}

			function onMessageArrived(message) {
				if(message.destinationName =="/camerapub") {
					$("#cameraView").attr("src", "data:image/jpg;base64,"+ message.payloadString);
					$("#cameraView2").attr("src", "data:image/jpg;base64,"+ message.payloadString);
					$("#hiyo").css("background-image","url(data:image/jpg;base64,"+ message.payloadString+")")
				}

				if(message.destinationName =="/ultra") {
					const json2 = message.payloadString;
					const obj2 = JSON.parse(json2);
					$("#Ultrasonic").attr("value",obj2.Ultrasonic);
				}

				if(message.destinationName =="/sensor") {
					const json = message.payloadString;
					const obj = JSON.parse(json);

					$("#Gas").attr("value",obj.Gas);
					$("#Thermister").attr("value",obj.Thermister);
					$("#Photoresister").attr("value",obj.Photoresister);
					$("#Tracking").attr("value",obj.Tracking);
				}
			}

				function fun1(value) {
					message2 = value
					message = new Paho.MQTT.Message(message2);

					if (message2 == "R" || message2 == "G" || message2 == "B" || message2 == "W" || message2 =="N"){
						message.destinationName = "/order/led";
						if(message2 == "N"){
							$("#CurrentLed").attr("value","LED OFF");
						} else
							$("#CurrentLed").attr("value","LED ("+ message2 + ") ON");
					}

					if (message2 == "ON" || message2 == "OFF"){
						message.destinationName = "/order/buzzer";
						$("#CurrentBuzzer").attr("value", "BUZZER " + message2);
					}

					if (message2 == "ENABLE" || message2 == "DISABLE"){
						message.destinationName = "/order/laser";
						$("#CurrentLaser").attr("value", "LASER " + message2)
					}

					if (message2 == "MODEON" || message2 == "MODEOFF"){
						message.destinationName = "/order/mode";
						if(message2 == "MODEON")
							$("#CurrentMODE").attr("value", "MANUAL MODE ON")
						else
							$("#CurrentMODE").attr("value", "AUTO MODE ON")
					}

					if (message2 == "TURNON" || message2 == "TURNOFF"){
						message.destinationName = "/order/lcd";
						$("#CurrentLcd").attr("value", "LCD " + message2);
					}
					if (message2.includes("DCGO") || message2 == "DCSTOP"){
						message.destinationName = "/order/dc";
						$("#CurrentDC").attr("value", message2)
					}
					if (message2.includes("SVGO") || message2 == "SVSTOP"){
						message.destinationName = "/order/sv";
						$("#CurrentSV").attr("value", message2)
					}
					if (message2.includes("SHGO") || message2 == "SHSTOP"){
						message.destinationName = "/order/sh";
						$("#CurrentSH").attr("value", message2)
					}
					if (message2.includes("SWGO") || message2 == "SWSTOP"){
						message.destinationName = "/order/sw";
						$("#CurrentSW").attr("value", message2)
					}
					if (message2.includes("SUGO") || message2 == "SUSTOP"){
						message.destinationName = "/order/su";
						$("#CurrentSU").attr("value", message2)
					}
					message.qos = 0;
					console.log(message.payloadString);
					client.send(message);
				}
////////////////////////////////////////////  GamePad  //////////////////////////////////////////////////////
				var start;
				window.addEventListener("gamepadconnected", function(e) {
					  var gp = navigator.getGamepads()[e.gamepad.index];
					  gameLoop();
				});

				window.addEventListener("gamepaddisconnected", function(e) {
					  cancelRequestAnimationFrame(start);
				});

				var interval;

				if (!('ongamepadconnected' in window)) {
				  interval = setInterval(pollGamepads, 500);
				}

				function pollGamepads() {
				  var gamepads = navigator.getGamepads ? navigator.getGamepads() : (navigator.webkitGetGamepads ? navigator.webkitGetGamepads : []);
				  for (var i = 0; i < gamepads.length; i++) {
				    var gp = gamepads[i];
				    if (gp) {
				      gameLoop();
				      clearInterval(interval);
				    }
				  }
				}

				function buttonPressed(b) {
				  if (typeof(b) == "object") {
				    return b.pressed;
				  }
					return b == 1.0;
				}
					var count = 0
					var svgo = 20
					var shgo = 90
					var swgo = 90
					var sugo = 80
					var dc = 13
					var prebuzzerflag = false
					var prelaserflag = false
					var ctrlflags = true

					function gameLoop() {
					  var gamepads = navigator.getGamepads ? navigator.getGamepads() : (navigator.webkitGetGamepads ? navigator.webkitGetGamepads : []);
					  if (!gamepads) {
					    return;
					  }
				      var message = null;
					  var gp = gamepads[0];

////////////////////////////   AUTO MODE   ////////////////////////////////////////
						 if(buttonPressed(gp.buttons[4]) && ctrlflags == true){
							 count++;
							 if (count >8){
								ctrlflags = false;
								message2 = "MODEOFF"
								message = new Paho.MQTT.Message(message2);
								message.destinationName = "/order/mode";
								client.send(message);
								let ret = window.open("http://localhost:8080/project/home/AutoControl.do", "_self");
								count = 0;
							}
						 }
////////////////////////////   CTRL MODE   ////////////////////////////////////////
						 else if(buttonPressed(gp.buttons[5]) && ctrlflags == false){
							 count++;
							 if (count >8){
								message2 = "MODEON"
							 	ctrlflags = true;
								message = new Paho.MQTT.Message(message2);
								message.destinationName = "/order/mode";
								client.send(message);
								let ret = window.open("http://localhost:8080/project/home/ManualControl.do", "_self");
								count = 0;
							 }
						 }
/////////////////////////////////////   LED   /////////////////////////////////////////////
					  if (buttonPressed(gp.buttons[0]) && ctrlflags == true){
						    count++;
						    if (count >8){
						    	message2 = "G"
						    	message = new Paho.MQTT.Message(message2);
						    	message.destinationName = "/order/led";
						    	client.send(message);
								$("#CurrentLed").attr("value","LED ("+ message2 + ") ON");
								count = 0;
						    }
					  } else if (buttonPressed(gp.buttons[1]) && ctrlflags == true){
						  count++;
						    if (count >8){
							    message2 = "R"
							    message = new Paho.MQTT.Message(message2);
							  	message.destinationName = "/order/led";
							  	client.send(message);
								$("#CurrentLed").attr("value","LED ("+ message2 + ") ON");
								count = 0;
						    }
					  } else if (buttonPressed(gp.buttons[2]) && ctrlflags == true){
						  count++;
						    if (count >8){
							    message2 = "B"
							    message = new Paho.MQTT.Message(message2);
							    message.destinationName = "/order/led";
							    client.send(message);
							    $("#CurrentLed").attr("value","LED ("+ message2 + ") ON");
							    count = 0;
						    }
					 } else if (buttonPressed(gp.buttons[3]) && ctrlflags == true){
						  count++;
						    if (count >8){
							    message2 = "W"
							    message = new Paho.MQTT.Message(message2);
							    message.destinationName = "/order/led";
							    client.send(message);
							    $("#CurrentLed").attr("value","LED ("+ message2 + ") ON");
							    count = 0;
						    }
					 } else if (buttonPressed(gp.buttons[9]) && ctrlflags == true){
						  count++;
						    if (count >8){
							    message2 = "N"
							    message = new Paho.MQTT.Message(message2);
							    message.destinationName = "/order/led";
							    client.send(message);
							    $("#CurrentLed").attr("value","LED OFF");
							    count = 0;
						    }
					 }
//////////////////////////// BUZZER //////////////////////////////////////
					  if (buttonPressed(gp.buttons[6]) && ctrlflags == true){
					    message2 = "ON"
					    message = new Paho.MQTT.Message(message2);
					    message.destinationName = "/order/buzzer";
					    client.send(message);
					    $("#CurrentBuzzer").attr("value", "BUZZER " + message2);
					    prebuzzerflag= true;
					 } else if (!buttonPressed(gp.buttons[6]) && ctrlflags == true) {
						 if (prebuzzerflag){
						    message2 = "OFF"
						    message = new Paho.MQTT.Message(message2);
						    message.destinationName = "/order/buzzer";
						    client.send(message);
						    $("#CurrentBuzzer").attr("value", "BUZZER " + message2);
						    prebuzzerflag= false;
					 	}
					 }

////////////////////////////  LASER  /////////////////////////////////////////////////
					 if (buttonPressed(gp.buttons[7]) && ctrlflags == true){
						    message2 = "ENABLE"
						    message = new Paho.MQTT.Message(message2);
						    message.destinationName = "/order/laser";
						    client.send(message);
						    $("#CurrentLaser").attr("value", "LASER " + message2);
						    prelaserflag= true;
					 } else if (!buttonPressed(gp.buttons[7]) && ctrlflags == true){
						 if (prelaserflag){
						 		message2 = "DISABLE"
							    message = new Paho.MQTT.Message(message2);
							    message.destinationName = "/order/laser";
							    client.send(message);
							    $("#CurrentLaser").attr("value", "LASER " + message2);
							    prelaserflag= false;
						 }
					 }
////////////////////////////   SERVO VERTICAL   //////////////////////////////////////////////
					 if (buttonPressed(gp.buttons[12]) && ctrlflags == true){
						 	svgo++;
						    if(svgo > 90){
						    	svgo = 90
						    }
						 	message2 = "SVGO"+svgo;
						    message = new Paho.MQTT.Message(message2);
						    message.destinationName = "/order/sv";
						    client.send(message);
						    $("#CurrentSV").attr("value", "SVGO " + message2);
						    $("#verticalselects").val(svgo)
					 }

					 if (buttonPressed(gp.buttons[13]) && ctrlflags == true){
						 svgo--;
						 if(svgo < 5){
							 svgo = 5
						 }
					     message2 = "SVGO"+svgo;
					     message = new Paho.MQTT.Message(message2);
					     message.destinationName = "/order/sv";
					     client.send(message);
					     $("#CurrentSV").attr("value", "SVGO " + message2);
					     $("#verticalselects").val(svgo)
					 }
////////////////////////////   SERVO HORIZONTAL   //////////////////////////////////////////////
					 if (buttonPressed(gp.buttons[14]) && ctrlflags == true){
						 shgo++;
						    if(shgo > 170){
						    	shgo = 170
						    }
						 	message2 = "SHGO"+shgo;
						    message = new Paho.MQTT.Message(message2);
						    message.destinationName = "/order/sh";
						    client.send(message);
						    $("#CurrentSH").attr("value", "SH " + message2);
						    $("#horizontalselects").val(shgo)
					 }
					 if (buttonPressed(gp.buttons[15]) && ctrlflags == true){
						 shgo--;
						    if(shgo < 12){
						    	shgo = 12
						    }
					 		message2 = "SHGO"+shgo;
					        message = new Paho.MQTT.Message(message2);
						    message.destinationName = "/order/sh";
						    client.send(message);
						    $("#CurrentSH").attr("value", "SH " + message2);
						    $("#horizontalselects").val(shgo)
					  }
/////////////////////////////// DCMOTOR ////////////////////////////////////////////////////

					 if (buttonPressed(gp.buttons[11]) && ctrlflags == true){
						message2 = "DCSTOP";
				        message = new Paho.MQTT.Message(message2);
					    message.destinationName = "/order/dc";
					    client.send(message);
					    dc = 0;
					    $("#CurrentDC").attr("value", "DC" + message2);
					    
					 }

					 if(gp.axes[3] > 0.5 && ctrlflags == true){
						 dc--;
						 if(dc<12){
							 if(dc<-80){
								 dc = -80;
							 }
							 if(dc<0){
							 	dc2 = -1*dc
							 } else
								dc2 =dc;

							message2 = "DCBACKGO" + dc2;
							message = new Paho.MQTT.Message(message2);
							message.destinationName = "/order/dc"
							client.send(message);
							$("#CurrentDC").attr("value", message2)
							$("#countselects").val(dc2)

						} else {
							message2 = "DCGO" + dc;
							message = new Paho.MQTT.Message(message2);
							message.destinationName = "/order/dc"
							client.send(message);
							$("#CurrentDC").attr("value", message2)
							$("#countselects").val(dc2)
						}
					}

					 else if(gp.axes[3] < -0.5 && ctrlflags == true){
						 dc++;
						 if (dc >11){
							if(dc > 80){
								dc = 80;
							}
							message2 = "DCGO" + dc;
							message = new Paho.MQTT.Message(message2);
							message.destinationName = "/order/dc"
							client.send(message);
							$("#CurrentDC").attr("value", message2)
							$("#countselects").val(dc)
						 } else {
							 if(dc<-80){
								 dc = -80;
						 	 }
							 if(dc<0)
							 	dc2 = -1*dc
							 else
								 dc2 =dc;

							 message2 = "DCBACKGO" + dc2;
							 message = new Paho.MQTT.Message(message2);
							 message.destinationName = "/order/dc"
							 client.send(message);
							 $("#CurrentDC").attr("value", message2)
							 $("#countselects").val(dc2)
						 }
					}

					 else if( gp.axes[3] > -0.2 && gp.axes[3] <0.2 && ctrlflags == true){
						dc = 0;
						message2 = "DCGO" + dc;
						message = new Paho.MQTT.Message(message2);
						message.destinationName = "/order/dc"
						client.send(message);
						$("#CurrentDC").attr("value", message2)
						$("#countselects").val(dc)
						
					 }
//////////////////////////////// SERVO///////////////////////////////////////////////////
					 if (buttonPressed(gp.buttons[10]) && ctrlflags == true){
					 		message2 = "STOP"
					        message = new Paho.MQTT.Message("SV"+message2);
						    message.destinationName = "/order/sv";
						    client.send(message);
						    message = new Paho.MQTT.Message("SH"+message2);
						    message.destinationName = "/order/sh";
						    client.send(message);
						    message = new Paho.MQTT.Message("SW"+message2);
						    message.destinationName = "/order/sw";
						    client.send(message);
						    message = new Paho.MQTT.Message("SU"+message2);
						    message.destinationName = "/order/su";
						    client.send(message);
						    $("#CurrentSH").attr("value", "SH " + message2);
						    $("#CurrentSV").attr("value", "SV " + message2);
						    $("#CurrentSW").attr("value", "SW " + message2);
						    $("#CurrentSU").attr("value", "SU" + message2);
						    funrotate(90)
						    $("#wheelselects").val(90)
						    $("#horizontalselects").val(90)
						    $("#ultraselects").val(90)
						    $("#verticalselects").val(20)
						    $("#countselects").val(12)
					 }
//////////////////////////// WHEEL SERVO ///////////////////////////////////////////
					 if(gp.axes[0] > 0.5 && ctrlflags == true) {
						 swgo++;
						    if(swgo > 130){
						    	swgo = 130
						    }
						 	message2 = "SWGO"+swgo;
						    message = new Paho.MQTT.Message(message2);
						    message.destinationName = "/order/sw";
						    client.send(message);
						    $("#CurrentSW").attr("value", "SW" + message2);
						    sugo = 170-swgo;
						    message2 = "SUGO"+sugo;
						    message = new Paho.MQTT.Message(message2);
						    message.destinationName = "/order/su";
						    client.send(message);
						    $("#CurrentSU").attr("value", "SU" + message2);
						    funrotate(swgo)
						    $("#wheelselects").val(swgo)
						    $("#ultraselects").val(sugo)
					 }
					 else if(gp.axes[0] < -0.5 && ctrlflags == true){
						 swgo--;
						    if(swgo < 50){
						    	swgo = 50
						    }
					 		message2 = "SWGO"+swgo;
					        message = new Paho.MQTT.Message(message2);
						    message.destinationName = "/order/sw";
						    client.send(message);
						    $("#CurrentSW").attr("value", "SW" + message2);
						    sugo = 170-swgo;
						    message2 = "SUGO"+sugo;
						    message = new Paho.MQTT.Message(message2);
						    message.destinationName = "/order/su";
						    client.send(message);
						    $("#CurrentSU").attr("value", "SU" + message2);
						    funrotate(swgo)
						    $("#wheelselects").val(swgo)
						    $("#ultraselects").val(sugo)
					 }
					 console.log(gp.axes[1])
					 start = requestAnimationFrame(gameLoop);
				}
				</script>

				<style>
					.axes {
					  padding: 1em;
					}

					.buttons {
					  margin-left: 1em;
					}

					/*meter*/.axis {
					  min-width: 200px;
					  margin: 1em;
					}

					.button {
					  display: inline-block;
					  width: 1em;
					  text-align: center;
					  padding: 1em;
					  border-radius: 20px;
					  border: 1px solid black;
					  background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAIAAACQd1PeAAAAAXNSR0IArs4c6QAAAAxJREFUCNdjYPjPAAACAgEAqiqeJwAAAABJRU5ErkJggg==);
					  background-size: 0% 0%;
					  background-position: 50% 50%;
					  background-repeat: no-repeat;
					}
					.button {
					background-image: url(data:image/png;base64,);
					}
					.pressed {
					  border: 1px solid red;
					}

					.touched::after {
					  content: "touch";
					  display: block;
					  position: absolute;
					  margin-top: -0.2em;
					  margin-left: -0.5em;
					  font-size: 0.8em;
					  opacity: 0.7;
					}
				</style>
	</head>
	<body>
	
		<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
		  <a class="navbar-brand" style="font-weight: bold; margin-left: 20px">Current Mode Status:&nbsp;&nbsp;&nbsp;&nbsp;MANUAL</a>
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
		    	<a class="navbar-brand" href="${pageContext.request.contextPath}/home/main.do" style="font-weight: bold;">HOME&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</a>
		    	<a class="navbar-brand" href="AutoControl.do" style="font-weight: bold" >Convert to Auto Sensing Mode</a>
		    </form>
		  </div>
		</nav>

		<div id="hiyo" style="background-repeat : no-repeat; background-size : cover;">
		
		<div style="width: 470px; height:170px; margin-left: 20px; background-color:gainsboro; opacity: 0.9;">
			<div class="btn-toolbar mb-3" role="toolbar" aria-label="Toolbar with button groups">
			  <div class="btn-group mr-2" role="group" aria-label="First group"style="width: 400px;height:50px;margin-left: 30px; margin-top: 30px">
					<button onclick="fun1('R')" class="btn btn-secondary">RED</button>
					<button onclick="fun1('G')" class="btn btn-secondary">GREEN</button>
					<button onclick="fun1('B')" class="btn btn-secondary">BLUE</button>
					<button onclick="fun1('W')" class="btn btn-secondary">WHITE</button>
					<button onclick="fun1('N')" class="btn btn-secondary">OFF</button>
			  </div>
			</div>

			<div class="input-group mb-3" style="width: 400px; margin-left: 30px">
			  <div class="input-group-prepend">
			    <span class="input-group-text" id="inputGroup-sizing-default" style="width: 200px">Current LED Status</span>
			  </div>
			  <input id="CurrentLed" value="LED OFF" type="text" class="form-control" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-default">
			</div>
		</div>

		<div style="width: 470px; height:150px; margin-left: 20px; background-color:gainsboro; opacity: 0.9; margin-top: 20px;align-content: center; " >
			<div class="btn-toolbar mb-3" role="toolbar" aria-label="Toolbar with button groups">
			  <div class="btn-group mr-2" role="group" aria-label="First group" style="width: 400px;height:50px; margin-left: 30px; margin-top: 15px">
					<button onclick="fun1('ON')" class="btn btn-secondary">BUZZER ON</button>
					<button onclick="fun1('OFF')" class="btn btn-secondary">BUZZER OFF</button>
			  </div>
			</div>
			
			<div class="input-group mb-3" style="width: 400px; margin-left: 30px">
			  <div class="input-group-prepend">
			    <span class="input-group-text" id="inputGroup-sizing-default" style="width: 200px">Current Buzzer Status</span>
			  </div>
			  <input id="CurrentBuzzer" value="BUZZER OFF" type="text" class="form-control" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-default">
			</div>
		</div>

		<div style="width: 470px; height:150px; margin-left: 20px; background-color:gainsboro; opacity: 0.9; margin-top: 20px;align-content: center; " >
			<div class="btn-toolbar mb-3" role="toolbar" aria-label="Toolbar with button groups">
			  <div class="btn-group mr-2" role="group" aria-label="First group" style="width: 400px;height:50px; margin-left: 30px; margin-top: 15px">
					<button onclick="fun1('ENABLE')" class="btn btn-secondary" style="width: 200px">LASER ATTACK</button>
					<button onclick="fun1('DISABLE')" class="btn btn-secondary" style="width: 200px">LASER RELEASED</button>
			  </div>
			</div>

			<div class="input-group mb-3" style="width: 400px; margin-left: 30px">
			  <div class="input-group-prepend">
			    <span class="input-group-text" id="inputGroup-sizing-default" style="width: 200px">Current Laser Status</span>
			  </div>
			  <input id="CurrentLaser" value="LASER RELEASED" type="text" class="form-control" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-default">
			</div>
		</div>

		<div style="width: 470px; height:150px; margin-left: 20px; background-color:gainsboro; opacity: 0.9; margin-top: 20px;align-content: center; " >
			<div class="btn-toolbar mb-3" role="toolbar" aria-label="Toolbar with button groups">
			  <div class="btn-group mr-2" role="group" aria-label="First group" style="width: 400px;height:50px; margin-left: 30px; margin-top: 15px">
					<button onclick="fun1('TURNON')" class="btn btn-secondary" style="width: 200px">LCD SCREEN ON</button>
					<button onclick="fun1('TURNOFF')" class="btn btn-secondary" style="width: 200px">LCD SCREEN OFF</button>
			  </div>
			</div>

			<div class="input-group mb-3" style="width: 400px; margin-left: 30px">
			  <div class="input-group-prepend">
			    <span class="input-group-text" id="inputGroup-sizing-default" style="width: 200px;">Current LCD Status</span>
			  </div>
			  <input id="CurrentLcd" value= "LCD SCREEN OFF" type="text" class="form-control" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-default">
			</div>
		</div>			

 		<div style="width: 470px; height:150px; margin-left: 20px; background-color:gainsboro; opacity: 0.9; margin-top: 20px;align-content: center;visibility: hidden " >
 			<div class="btn-toolbar mb-3" role="toolbar" aria-label="Toolbar with button groups">
				  <div class="btn-group mr-2" role="group" aria-label="First group" style="width: 400px;height:50px; margin-left: 30px; margin-top: 15px">
						<button onclick="fun1('MODEON')" class="btn btn-secondary" style="width: 200px">MANUAL MODE ON</button>
						<button onclick="fun1('MODEOFF')" class="btn btn-secondary" style="width: 200px">AUTO MODE ON</button>
				  </div>
			</div>

			<div class="input-group mb-3" style="width: 400px; margin-left: 30px">
			  <div class="input-group-prepend">
			    	<span class="input-group-text" id="inputGroup-sizing-default" style="width: 200px"></span>
			  </div>
			  	<input id="CurrentMODE" value="MANUAL MODE ON" type="text" class="form-control" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-default">
			</div>
		</div>
		
		<img id=image_canv src="${pageContext.request.contextPath}/resource/img/tank.png" style="position:fixed; right:0; top:0 ;margin-top: 350px; margin-right: 30px"/>
		
		<div style="width: 580px; height:250px; margin-left: 20px; background-color:gainsboro; opacity: 0.9; margin-top: 20px;align-content: center; position: absolute; right:0; top:0; margin-right: 30px; margin-top: 55px" >
			<div class="input-group">
				  <div class="input-group-prepend">
				    	<span class="input-group-text" id="inputGroup-sizing-default" style="width: 300px; margin-top: 10px; margin-left: 10px; margin-bottom: 10px">Current Speed &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;12 ~ 80</span>
				  </div>
				   		<input id= "countselects" type="number" name="countselect" min="12" max = "80" value="12" style="margin-top: 10px" onmousewheel="fun1('DCGO'+$(countselects).val())" onchange="fun1('DCGO'+$(countselects).val())" class="form-control" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-default">
				  		<button onclick="fun1('DCSTOP');stopbuttondc()" class="btn btn-secondary" style="width: 170px; margin-left: 10px; margin-top: 10px; margin-bottom: 10px; margin-right: 10px">DC Motor STOP</button>
			</div>
			
			<div class="input-group">
				  <div class="input-group-prepend">
				    	<span class="input-group-text" id="inputGroup-sizing-default" style="width: 300px; margin-left: 10px; margin-bottom: 10px">Camera - Vertical &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;5 ~ 90</span>
				  </div>
				  		<input id= "verticalselects" type="number" name="verticalselects" min="5" max = "90" value="20" onmousewheel="fun1('SVGO'+$(verticalselects).val())" onchange="fun1('SVGO'+$(verticalselects).val())" class="form-control" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-default">
				  		<button onclick="fun1('SVSTOP');stopbuttonsv()" class="btn btn-secondary" style="width: 170px; margin-left: 10px; margin-bottom: 10px; margin-right: 10px">Default Angle</button>
			</div>
			
			<div class="input-group">
				  <div class="input-group-prepend">
				    	<span class="input-group-text" id="inputGroup-sizing-default" style="width: 300px; margin-left: 10px; margin-bottom: 10px">Camera - Horizontal &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;12 ~ 170</span>
				  </div>
				  		<input id= "horizontalselects" type="number" name="horizontalselects" min="12" max = "170" value="90" onmousewheel="fun1('SHGO'+$(horizontalselects).val())" onchange="fun1('SHGO'+$(horizontalselects).val())" class="form-control" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-default">
				  		<button onclick="fun1('SHSTOP');stopbuttonsh()" class="btn btn-secondary" style="width: 170px; margin-left: 10px; margin-bottom: 10px; margin-right: 10px">Default Angle</button>
			</div>
			
			<div class="input-group">
				  <div class="input-group-prepend">
				    	<div class="input-group-text" id="inputGroup-sizing-default" style="width: 300px; margin-left:10px; margin-bottom: 10px;float: left;">Ultrasonic Servo</div>  <div style="float: right; margin-left: -75px; line-height: 35px; text-align: left; width: 75px;">40 ~ 120</div>
				  </div>
				  		<input id= "ultraselects" type="number" name="ultraselects" min="40" max ="120" value="90" onmousewheel="fun1('SUGO'+$(ultraselects).val())" onchange="fun1('SUGO'+$(ultraselects).val())" class="form-control" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-default">
				  		<button onclick="fun1('SUSTOP');stopbuttonsu()" class="btn btn-secondary" style="width: 170px; margin-left: 10px; margin-bottom: 10px; margin-right: 10px">Default Angle</button>
			</div>

			<div class="input-group">
				  <div class="input-group-prepend">
				    	<span class="input-group-text" id="inputGroup-sizing-default" style="width: 300px; margin-left: 10px; margin-bottom: 10px">Wheel Servo &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 50 ~ 130</span>
				  </div>
				  		<input id= "wheelselects" type="number" name="wheelselects" min="50" max ="130" value="90" onmousewheel="fun1('SWGO'+$(wheelselects).val())" onchange="fun1('SWGO'+$(wheelselects).val())" class="form-control" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-default">
				  		<button id= "wheelstop" onclick="fun1('SWSTOP');stopbuttonsw()" class="btn btn-secondary" style="width: 170px; margin-left: 10px; margin-bottom: 10px; margin-right: 10px">Default Angle</button>
			</div>
		</div>

		<!-- 탱그 미니어쳐 조작을 위한 js -->
		<script>
			var value= 0;
			var value2= 0;
			function stopbuttonsw(){
				$('#wheelselects').val(90)	
			}
			function stopbuttonsu(){
				$('#ultraselects').val(90)	
			}function stopbuttondc(){
				$('#countselects').val(12)	
			}function stopbuttonsv(){
				$('#verticalselects').val(20)	
			}function stopbuttonsh(){
				$('#horizontalselects').val(90)	
			}
			function funrotate(data=0){
				if(data ==0){
			      value= ($(wheelselects).val()-90);
			      $("#image_canv").rotate({animateTo:value})
				}
				else{
					let value= data-90;
				    $("#image_canv").rotate({animateTo:value})
				}
			}
			
			$("#wheelstop").on('click',function(event){ funrotate(0)})
			$("#wheelselects").on('mousewheel',function(event){ funrotate(0)});
			$("#wheelselects").on('change',function(event){ funrotate(0)});
		</script>

 		<div style="margin-left: 1100px; font-size: 15px; font-weight:bold">
			<div>Distance towards Object (cm) :<input id = "Ultrasonic" value="" style="border: none; margin-left: 10px; margin-bottom: 5px; background-color: transparent; font-weight:bold"/></div>
			<div>Temperature (celsius) :<input id = "Thermister" value="" style="border: none; margin-left: 10px; margin-bottom: 5px; background-color: transparent; font-weight:bold"/></div>
			<div>Land Mine Detecting Status:<input id = "Tracking" value="" style="border: none; margin-left: 10px; margin-bottom: 5px; background-color: transparent; font-weight:bold"/></div>
			<div>Brightness (lux) :<input id = "Photoresister" value="" style="border: none; margin-left: 10px; margin-bottom: 5px; background-color: transparent; font-weight:bold"/></div>
			<div>Gas Status (pm) :<input id = "Gas" value="" style="border: none;margin-left: 10px; background-color: transparent; font-weight:bold"/></div>
		</div>
		
		</div>
	</body>
</html>