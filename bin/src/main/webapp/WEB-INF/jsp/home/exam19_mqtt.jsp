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
				client.subscribe("/camerapub");
			}

			function onMessageArrived(message)
			{
				console.log(message.payloadString)
				$("#cameraView").attr("src", "data:image/jpg;base64,"+message.payloadString);
			}
		</script>
	</head>

	<body>
		<h5 class="alert alert-info">/home/exam19_mqtt.jsp</h5>		
		<img id="cameraView"/>
	</body>
</html>