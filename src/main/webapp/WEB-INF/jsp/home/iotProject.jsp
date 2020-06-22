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
		<script src="https://cdnjs.cloudflare.com/ajax/libs/paho-mqtt/1.0.1/mqttws31.min.js" type="text/javascript"></script>
		
		
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
			}
			
			function onMessageArrived(message)
			{				
				if(message.destinationName =="/camerapub")
				{		
					$("#cameraView").attr("src", "data:image/jpg;base64,"+ message.payloadString);
					$("#cameraView2").attr("src", "data:image/jpg;base64,"+ message.payloadString);
				}
				
				if(message.destinationName =="/ultra")
				{
					const json2 = message.payloadString;
					const obj2 = JSON.parse(json2);
					$("#Ultrasonic").attr("value",obj2.Ultrasonic);
				}
				
				if(message.destinationName =="/sensor")
				{
					const json = message.payloadString;
					const obj = JSON.parse(json);
					
					$("#Gas").attr("value",obj.Gas);
					$("#Thermister").attr("value",obj.Thermister);
					$("#Photoresister").attr("value",obj.Photoresister);
					$("#Tracking").attr("value",obj.Tracking);
					
				}

			}
			
				function fun1(value)
				{
					// Publish a Message
					message2 = value
					message = new Paho.MQTT.Message(message2);
					
					// 명령 값에 따라 토픽 분류 + 현재 상태 출력
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
						$("#CurrentMODE").attr("value", "CONTROL" + message2)
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
				  // No gamepad events available, poll instead.
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
				var svgo = 12
				var shgo = 90
				var prebuzzerflag = false
				var prelaserflag = false
					function gameLoop() {
					  var gamepads = navigator.getGamepads ? navigator.getGamepads() : (navigator.webkitGetGamepads ? navigator.webkitGetGamepads : []);
					  if (!gamepads) {
					    return;
					  }
				      var message = null;
					  
					  var gp = gamepads[0];
					  
///////////////////////////////////// LED /////////////////////////////////////////////
					  if (buttonPressed(gp.buttons[0])) 
					  {
						    count++;
						    if (count >8){
					    	message2 = "G"
					    	message = new Paho.MQTT.Message(message2);
					    	message.destinationName = "/order/led";
					    	client.send(message);
							$("#CurrentLed").attr("value","LED ("+ message2 + ") ON");
							count = 0;
						    }
					  } 
					  else if (buttonPressed(gp.buttons[1])) 
					  {
						  count++;
						    if (count >8){
						    message2 = "R"
						    message = new Paho.MQTT.Message(message2);
						  	message.destinationName = "/order/led";
						  	client.send(message);
							$("#CurrentLed").attr("value","LED ("+ message2 + ") ON");	
							count = 0;
						    }						
					  } 
					  else if (buttonPressed(gp.buttons[2]))
					  {
						  count++;
						    if (count >8){
						    message2 = "B"
						    message = new Paho.MQTT.Message(message2);
						    message.destinationName = "/order/led";
						    client.send(message);
						    $("#CurrentLed").attr("value","LED ("+ message2 + ") ON");
						    count = 0;
						    }
					 }else if (buttonPressed(gp.buttons[3]))
					  {
						  count++;
						    if (count >8){
						    message2 = "W"
						    message = new Paho.MQTT.Message(message2);
						    message.destinationName = "/order/led";
						    client.send(message);
						    $("#CurrentLed").attr("value","LED ("+ message2 + ") ON");
						    count = 0;
						    }
					 }else if (buttonPressed(gp.buttons[9]))
					  {
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
					  if (buttonPressed(gp.buttons[6]))
					  {
						//버 저  
						    message2 = "ON"
						    message = new Paho.MQTT.Message(message2);
						    message.destinationName = "/order/buzzer";
						    client.send(message);
						    $("#CurrentBuzzer").attr("value", "BUZZER " + message2);
						    prebuzzerflag= true;
					 }
					 else if (!buttonPressed(gp.buttons[6]))
					  {
						 if (prebuzzerflag){ 
						    message2 = "OFF"
						    message = new Paho.MQTT.Message(message2);
						    message.destinationName = "/order/buzzer";
						    client.send(message);
						    $("#CurrentBuzzer").attr("value", "BUZZER " + message2);
						    prebuzzerflag= false;
					 	} 

					 }
					 
//////////////////////////// LASER ////////////////////////////////////////
					 if (buttonPressed(gp.buttons[7]))
					  {
						    message2 = "ENABLE"
						    message = new Paho.MQTT.Message(message2);
						    message.destinationName = "/order/laser";
						    client.send(message);
						    $("#CurrentLaser").attr("value", "LASER " + message2);
						    prelaserflag= true;
					 }else if (!buttonPressed(gp.buttons[7]))
					  {			
						 if (prelaserflag){ 
						 		message2 = "DISABLE"
							    message = new Paho.MQTT.Message(message2);
							    message.destinationName = "/order/laser";
							    client.send(message);
							    $("#CurrentLaser").attr("value", "LASER " + message2);
							    prelaserflag= false;
						 	} 
					 }
//////////////////////////// 카메라 서보 vertical //////////////////////////////////////////////						 
					 if (buttonPressed(gp.buttons[12]))
					  {
						 	svgo++;
						    if(svgo > 90)
						    	{svgo = 90}
						    
						 	message2 = "SVGO"+svgo;
						    message = new Paho.MQTT.Message(message2);
						    message.destinationName = "/order/sv";
						    client.send(message);
						    $("#CurrentSV").attr("value", "SVGO " + message2);
					
					 }
					 
					 if (buttonPressed(gp.buttons[13]))
					  {
						 svgo--;
						 if(svgo < 5)
					    	{svgo = 5}
						    message2 = "SVGO"+svgo;
						    message = new Paho.MQTT.Message(message2);
						    message.destinationName = "/order/sv";
						    client.send(message);
						    $("#CurrentSV").attr("value", "SVGO " + message2);
					
					 }

////////////////////////////카메라 서보 horizon //////////////////////////////////////////////				 
					 if (buttonPressed(gp.buttons[14]))
					  {
						 shgo++;
						    if(shgo > 170)
						    	{shgo = 170}
						    
						 	message2 = "SHGO"+shgo;
						    message = new Paho.MQTT.Message(message2);
						    message.destinationName = "/order/sh";
						    client.send(message);
						    $("#CurrentSH").attr("value", "SH " + message2);
					
					 }
				 
					 if (buttonPressed(gp.buttons[15]))
					  { shgo--;
					    if(shgo < 12)
				    	{shgo = 12}
				    
				 		message2 = "SHGO"+shgo;
				        message = new Paho.MQTT.Message(message2);
						    message.destinationName = "/order/sh";
						    client.send(message);
						    $("#CurrentSH").attr("value", "SH " + message2);
/////////////////////////////// DCMOTOR ////////////////////////////////////////////////////
					 }
					 if (buttonPressed(gp.buttons[10]))
					  { 
						message2 = "DCSTOP";
				        message = new Paho.MQTT.Message(message2);
						    message.destinationName = "/order/dc";
						    client.send(message);
						    $("#CurrentDC").attr("value", "DC" + message2);
					
					 }
//////////////////////////////// 서보모터 초기화 ///////////////////////////////////////////////////
					 if (buttonPressed(gp.buttons[11]))
					  {
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
					 }
					 if (axes)
					  
					  
					  
					  //message.qos = 0;
					  //console.log(message.payloadString);
					  
					  start = requestAnimationFrame(gameLoop);
					}
		
		/*  
		var haveEvents = 'GamepadEvent' in window;
		 var haveWebkitEvents = 'WebKitGamepadEvent' in window;
		 var controllers = {};
		 var rAF = window.mozRequestAnimationFrame ||
		   window.webkitRequestAnimationFrame ||
		   window.requestAnimationFrame;

		 function connecthandler(e) {
		   addgamepad(e.gamepad);
		 }
		 function addgamepad(gamepad) {
		   controllers[gamepad.index] = gamepad; var d = document.createElement("div");
		   d.setAttribute("id", "controller" + gamepad.index);
		   var t = document.createElement("h1");
		   t.appendChild(document.createTextNode("gamepad: " + gamepad.id));
		   d.appendChild(t);
		   var b = document.createElement("div");
		   b.className = "buttons";
		   for (var i=0; i<gamepad.buttons.length; i++) {
		     var e = document.createElement("span");
		     e.className = "button";
		     //e.id = "b" + i;
		     e.innerHTML = i;
		     b.appendChild(e);
		   }
		   d.appendChild(b);
		   var a = document.createElement("div");
		   a.className = "axes";
		   for (i=0; i<gamepad.axes.length; i++) {
		     e = document.createElement("meter");
		     e.className = "axis";
		     //e.id = "a" + i;
		     e.setAttribute("min", "-1");
		     e.setAttribute("max", "1");
		     e.setAttribute("value", "0");
		     e.innerHTML = i;
		     a.appendChild(e);
		   }
		   d.appendChild(a);
		   document.getElementById("start").style.display = "none";
		   document.body.appendChild(d);
		   rAF(updateStatus);
		 }

		 function disconnecthandler(e) {
		   removegamepad(e.gamepad);
		 }

		 function removegamepad(gamepad) {
		   var d = document.getElementById("controller" + gamepad.index);
		   document.body.removeChild(d);
		   delete controllers[gamepad.index];
		 }

		 function updateStatus() {
		   scangamepads();
		   console.log("실행1");
		   for (j in controllers) {
		     var controller = controllers[j];
		     var d = document.getElementById("controller" + j);
		     var buttons = d.getElementsByClassName("button");
		     for (var i=0; i<controller.buttons.length; i++) { //
		       var b = buttons[i];
		    
		       var val = controller.buttons[i];
		       var pressed = val == 1.0;
		       var touched = false;
		       if (typeof(val) == "object") {
		         pressed = val.pressed;
		         console.log("실행2");
		         if ('touched' in val) {
		           touched = val.touched;
		           console.log("실행3");
		         }
		         val = val.value;
		       }
		       var pct = Math.round(val * 100) + "%";
		       b.style.backgroundSize = pct + " " + pct;
		       b.className = "button";
		       if (pressed) {
		    	   message2 = 'B'
					   message = new Paho.MQTT.Message(message2);
			    	   message.destinationName = "/order/led";
			    	   $("#CurrentLed").attr("value","LED ("+ message2 + ") ON");	
			    	   message.qos = 0;
						console.log(message.payloadString);
						client.send(message);
		    	   console.log("실행4");
		         b.className += " pressed";
		       }
		      
		     }

		     var axes = d.getElementsByClassName("axis");
		     for (var i=0; i<controller.axes.length; i++) {
		    	 console.log("실행6");
		       var a = axes[i];
		       a.innerHTML = i + ": " + controller.axes[i].toFixed(4);
		       a.setAttribute("value", controller.axes[i]);
		     }
		   }
		   rAF(updateStatus);
		 }

		 function scangamepads() {
		   var gamepads = navigator.getGamepads ? navigator.getGamepads() : (navigator.webkitGetGamepads ? navigator.webkitGetGamepads() : []);
		   console.log("실행7");
		   for (var i = 0; i < gamepads.length; i++) {
		     if (gamepads[i] && (gamepads[i].index in controllers)) {
		    	 console.log("실행8");
		       controllers[gamepads[i].index] = gamepads[i];
		     }
		   }
		 }

		 if (haveEvents) {
		   window.addEventListener("gamepadconnected", connecthandler);
		   window.addEventListener("gamepaddisconnected", disconnecthandler);
		 } else if (haveWebkitEvents) {
		   window.addEventListener("webkitgamepadconnected", connecthandler);
		   window.addEventListener("webkitgamepaddisconnected", disconnecthandler);
		 } else {
		   setInterval(scangamepads, 500);
		 } */

		</script>
		
		<!--

Gamepad API Test

Written in 2013 by Ted Mielczarek <ted@mielczarek.org>

To the extent possible under law, the author(s) have dedicated all copyright and related and neighboring rights to this software to the public domain worldwide. This software is distributed without any warranty.

You should have received a copy of the CC0 Public Domain Dedication along with this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

-->
<script type="text/javascript"></script>
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
		<div>
			<img id="cameraView"/>
			
			<div>			
				<div>GAS :<input id = "Gas" value=""/></div>
				<div>Thermister :<input id = "Thermister" value=""/></div>
				<div>Photoresister :<input id = "Photoresister" value=""/></div>
				<div>Ultrasonic :<input id = "Ultrasonic" value=""/></div>
				<div>Tracking :<input id = "Tracking" value=""/></div>
			</div>

			<div>
				<button onclick="fun1('R')">LED_RED</button>
				<button onclick="fun1('G')">LED_GREEN</button>
				<button onclick="fun1('B')">LED_BLUE</button>
				<button onclick="fun1('W')">LED_WHITE</button>
				<button onclick="fun1('N')">LED_OFF</button>
				<div>CurrentLed :<input id = "CurrentLed" value=""/></div>
			</div>

			<div>
				<button onclick="fun1('ON')">BUZZER_ON</button>
				<button onclick="fun1('OFF')">BUZZER_OFF</button>
				<div>CurrentBuzzer :<input id = "CurrentBuzzer"value=""/></div>
			</div>

			<div>
				<button onclick="fun1('ENABLE')">LASER_ON</button>
				<button onclick="fun1('DISABLE')">LASER_OFF</button>
				<div>CurrentLaser :<input id = "CurrentLaser" value=""/></div>
			</div>

			<div>
				<button onclick="fun1('TURNON')">LCD_ON</button>
				<button onclick="fun1('TURNOFF')">LCD_OFF</button>
				<div>CurrentLcd :<input id = "CurrentLcd" value=""/></div>
			</div>

			<div>
				CurrentSpeed(12~80) :<input id= "countselects" type="number" name="countselect" min="12" max = "80" value="12" onmousewheel="fun1('DCGO'+$(countselects).val())" onchange="fun1('DCGO'+$(countselects).val())"/>
				<button onclick="fun1('DCSTOP')">STOP</button>
				<div>CurrentDC :<input id = "CurrentDC" value=""/></div>
			</div>
	
			<div>
				Servo_Wheel(50~130) :<input id= "wheelselects" type="number" name="wheelselects" min="50" max ="130" value="50" onmousewheel="fun1('SWGO'+$(wheelselects).val())" onchange="fun1('SWGO'+$(wheelselects).val())"/>
				<button onclick="fun1('SWSTOP')">STOP</button>
				<div>CurrentSW :<input id = "CurrentSW" value=""/></div>
			</div>
			
			<div>
				Servo_vertical(5~90) :<input id= "verticalselects" type="number" name="verticalselects" min="5" max = "90" value="5" onmousewheel="fun1('SVGO'+$(verticalselects).val())" onchange="fun1('SVGO'+$(verticalselects).val())"/>
				<button onclick="fun1('SVSTOP')">STOP</button>
				<div>CurrentSV :<input id = "CurrentSV" value=""/></div>
			</div>

			<div>
				Servo_horizontal(12~170) :<input id= "horizontalselects" type="number" name="horizontalselects" min="12" max = "170" value="12" onmousewheel="fun1('SHGO'+$(horizontalselects).val())" onchange="fun1('SHGO'+$(horizontalselects).val())" />
				<button onclick="fun1('SHSTOP')">STOP</button>
				<div>CurrentSH :<input id = "CurrentSH" value=""/></div>
			</div>

			<div>
				Servo_Ultra(40~120) :<input id= "ultraselects" type="number" name="ultraselects" min="40" max ="120" value="40" onmousewheel="fun1('SUGO'+$(ultraselects).val())" onchange="fun1('SUGO'+$(ultraselects).val())"/>
				<button onclick="fun1('SUSTOP')">STOP</button>
				<div>CurrentSU :<input id = "CurrentSU" value=""/></div>
			</div>

			<div>
				<button onclick="fun1('MODEON')">CONTROL_MODE_ON</button>
				<button onclick="fun1('MODEOFF')">CONTROL_MODE_OFF</button>
				<div>CurrentMODE :<input id = "CurrentMODE" value=""/></div>
			</div>
			<div>
				<button onclick="openFullscreen();">Open Video in Fullscreen Mode</button>
				<img width="100%" id = "cameraView2"> 
				</img>
				<script>
				var elem = document.getElementById("cameraView2");
				function openFullscreen() {
				  if (elem.requestFullscreen) {
				    elem.requestFullscreen();
				  } else if (elem.mozRequestFullScreen) { /* Firefox */
				    elem.mozRequestFullScreen();
				  } else if (elem.webkitRequestFullscreen) { /* Chrome, Safari & Opera */
				    elem.webkitRequestFullscreen();
				  } else if (elem.msRequestFullscreen) { /* IE/Edge */
				    elem.msRequestFullscreen();
				  }
				}
				</script>
			</div>
		
		</div>
		<h2 id="start">Press a button on your controller to start</h2>
	</body>
</html>