<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
	<head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
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
				// Create a client instance
				client = new Paho.MQTT.Client(location.hostname, 61614, new Date().getTime().toString());
				// set callback handlers
				client.onMessageArrived = onMessageArrived; // callback함수 등록
				// connect the client
				client.connect({onSuccess:onConnect});
			});
			
			// called when the client connects
			function onConnect() {
				console.log("mqtt broker connected")
				client.subscribe("/sensor");
				client.subscribe("/camerapub");
				client.subscribe("/ultra");
			}
			
		
			function onMessageArrived(message)
			{				
				if(message.destinationName =="/camerapub")
					$("#cameraView").attr("src", "data:image/jpg;base64,"+ message.payloadString);
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
					if (message2 == "R" || message2 == "G" || message2 == "B" || message2 =="N"){
						message.destinationName = "/order/led";
						if(message2 == "N"){
							$("#CurrentLed").attr("value","LED OFF");
						} else
							$("#CurrentLed").attr("value","LED ("+ message2 + ") ON");	
					}
					
					if (message2 == "ON" || message2 == "OFF"){
						message.destinationName = "/order/buzzer";
						if (message2 == "OFF"){
							$("#CurrentBuzzer").attr("value", "BUZZER " + message2)
						} else 
							$("#CurrentBuzzer").attr("value", "BUZZER " + message2)
					}
					
					if (message2 == "ENABLE" || message2 == "DISABLE"){
						message.destinationName = "/order/laser";
						if (message2 == "DISABLE"){
							$("#CurrentLaser").attr("value", "LASER " + message2)
						} else 
							$("#CurrentLaser").attr("value", "LASER " + message2)
					}
					
					
					if (message2 == "TURNON" || message2 == "TURNOFF"){
						message.destinationName = "/order/lcd";
						if (message2 == "TURNOFF"){
							$("#CurrentLcd").attr("value", "LCD " + message2)
						} else 
							$("#CurrentLcd").attr("value", "LCD " + message2)
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
		</script>
	</head>

	<body>
		<h5 class="alert alert-info">/home/exam19_mqtt.jsp</h5>		
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
				Servo_Wheel(50~130) :<input id= "wheelselects" type="number" name="wheelselects" min="50" max ="130" value="50" onmousewheel="fun1('SWGO'+$(wheelselects).val())" onchange="fun1('SWGO'+$(wheelselects).val())"/>
				<button onclick="fun1('SWSTOP')">STOP</button>
				<div>CurrentSW :<input id = "CurrentSW" value=""/></div>
			</div>
			<div>
				Servo_Ultra(40~120) :<input id= "ultraselects" type="number" name="ultraselects" min="40" max ="120" value="40" onmousewheel="fun1('SUGO'+$(ultraselects).val())" onchange="fun1('SUGO'+$(ultraselects).val())"/>
				<button onclick="fun1('SUSTOP')">STOP</button>
				<div>CurrentSU :<input id = "CurrentSU" value=""/></div>
			</div>
	</body>
</html>