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
				// Create a client instance
				client = new Paho.MQTT.Client(location.hostname, 61614, new Date().getTime.toString());
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
					message.destinationName = "/ledorder";
					message.qos = 0;
					console.log(message.payloadString)
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
			</div>
	</body>
</html>