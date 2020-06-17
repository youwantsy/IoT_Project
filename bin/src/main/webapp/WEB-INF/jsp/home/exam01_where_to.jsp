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
		<script>
			console.log("1"); // print
			
			function fun1()
			{
				console.log("fun1 실행");
				
			}
		</script>
		<script src="${pageContext.request.contextPath}/resource/js/exam_01_where_to.js"></script>
	<!-- java script는 <script태그 안에서 작성해야한다. -->
	</head>
	<body>
		<script>
			console.log("2");
			fun1()
		</script>
		
		<h5 class="alert alert-info">/home/exam01_where_to.jsp</h5>
		
		<script>
			console.log("3");
			fun1()
		</script>
		
				
	</body>
</html>