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
		
		<link href="${pageContext.request.contextPath}/resource/bootstrap/css/change.css" rel="stylesheet">
		
	</head>
	<body>
		<script>
			$(function(){
				client = new Paho.MQTT.Client(location.hostname, 61614, new Date().getTime().toString());
				client.onMessageArrived = onMessageArrived;
				client.connect({onSuccess:onConnect});
			});
	
			function onConnect() {
				console.log("mqtt broker connected")
				client.subscribe("/1cctv");
				client.subscribe("/2cctv");
				client.subscribe("/3cctv");
				client.subscribe("/4cctv");
				//console.log("mqtt subscribed")
			}

			function onMessageArrived(message) {
				//console.log("message received")
				if(message.destinationName =="/1cctv") {
					//console.log("topic received")
					$("#cameraView1").attr("src", "data:image/jpg;base64,"+ message.payloadString);
				}
				if(message.destinationName =="/2cctv") {
					//console.log("topic received")
					$("#cameraView2").attr("src", "data:image/jpg;base64,"+ message.payloadString);
				}
				if(message.destinationName =="/3cctv") {
					//console.log("topic received")
					$("#cameraView3").attr("src", "data:image/jpg;base64,"+ message.payloadString);
				}
				if(message.destinationName =="/4cctv") {
					//console.log("topic received")
					$("#cameraView4").attr("src", "data:image/jpg;base64,"+ message.payloadString);
				}
			}
			
			var curr_stat = true;
 			function view(cctv_num){
				//console.log("view function activated")

				if (cctv_num == '1'){
					//console.log("show cctv 1")
					if (curr_stat){
						$("#show1").css({"display":"none"})
						curr_stat = false
						console.log(curr_stat)
					}
					else if (!curr_stat){
						$("#show1").css({"display":"block"})
						curr_stat = true
					}
				}
				
				if (cctv_num == '2'){
					//console.log("show cctv 2")
					if (curr_stat){
						$("#show2").css({"display":"none"})
						curr_stat = false
						console.log(curr_stat)
					}
					else if (!curr_stat){
						$("#show2").css({"display":"block"})
						curr_stat = true
					}
				}
				
				if (cctv_num == '3'){
					//console.log("show cctv 3")
					if (curr_stat){
						$("#show3").css({"display":"none"})
						curr_stat = false
						console.log(curr_stat)
					}
					else if (!curr_stat){
						$("#show3").css({"display":"block"})
						curr_stat = true
					}
				}
				
				if (cctv_num == '4'){
					//console.log("show cctv 4")
					if (curr_stat){
						$("#show4").css({"display":"none"})
						curr_stat = false
						console.log(curr_stat)
					}
					else if (!curr_stat){
						$("#show4").css({"display":"block"})
						curr_stat = true
					}
				}
			}
		</script>
		
<!-- 
		<div class="btn-group mr-2" role="group" aria-label="First group" style="margin-left: 320px; width: 320px">
		    <button type="button" class="btn btn-secondary" onclick="view('1')">CCTV 1</button>
		    <button type="button" class="btn btn-secondary" onclick="view('2')">CCTV 2</button>
		    <button type="button" class="btn btn-secondary" onclick="view('3')">CCTV 3</button>
		    <button type="button" class="btn btn-secondary" onclick="view('4')">CCTV 4</button>
		 </div>

		<div class="row row-cols-2" style="width: 640px; height:480px">
			<div class="col"  id="show1"><img id=cameraView1 style="width: 320px;height:240px"/></div>
			<div class="col"  id="show2"><img id=cameraView2 style="width: 320px;height:240px"/></div>
			<div class="col"  id="show3"><img id=cameraView3 style="width: 320px;height:240px"/></div>
			<div class="col"  id="show4"><img id=cameraView4 style="width: 320px;height:240px"/></div>
		</div>
 -->
 	 
  		<div id="content">
			<div id="bigImages">
					<img class="big" id=cameraView1>
					<!--이미지 위에 cctv 번호 텍스트로 띄우려고 했을 때 시도한 방법
					<div>CCTV #1</div> 
					-->
			</div>
			<div id="smallImages">
					<img class="small" id=cameraView2>
					<img class="small" id=cameraView3>
					<img class="small" id=cameraView4>
			</div>
		</div>
		<script src="${pageContext.request.contextPath}/resource/jquery/change.js"></script>
		
</body>
</html>
