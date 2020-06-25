<!DOCTYPE html>
<html>
	<head>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	
		<style>
			body {
			  font-family: Arial;
			  color: white;
			}
			
			.split {
			  height: 100%;
			  width: 50%;
			  position: fixed;
			  z-index: 1;
			  top: 0;
			  overflow-x: hidden;
			  padding-top: 20px;
			}
			
			.left {
			  left: 0;
			  background-color: #111;
			}
			
			.right {
			  right: 0;
			  background-color: darkolivegreen;
			}
			
			.centered {
			  position: absolute;
			  top: 50%;
			  left: 50%;
			  transform: translate(-50%, -50%);
			  text-align: center;
			}
			
			.centered img {
			  width: 500px;
			  border-radius: 70%;
			}
		</style>
	</head>
	<body>
		<div class="split left">
		  <div class="centered">
		   	<a href="ManualControl.do">
			   <img src="${pageContext.request.contextPath}/resource/img/main1.jpg">
			</a>
			
		    <h2>Manual Control Mode</h2>
		    <p>Accessing Manual Operation mode of M1 Abrams</p>
		  </div>
		</div>
		
		<div class="split right">
		  <div class="centered">
		  
		  	<a href="AutoControl.do">
			   <img src="${pageContext.request.contextPath}/resource/img/main2.jpg">
			</a>
			
		    <h2>Auto Control Mode</h2>
		    <p>Accessing Auto-Sensing Operation mode of M1 Abrams</p>
		    
		  </div>
		</div>
	</body>
</html> 