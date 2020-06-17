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
		<link rel = "stylesheet" href="${pageContext.request.contextPath}/resource/css/exam17_css.css">
	</head>
	<body>
		<h5 class="alert alert-info">/home/exam17_css.jsp</h5>
		
			<div id="container">
				<button>객체 찾기 by id</button>
				<button>객체 찾기 by class</button>
				<div>
					<div id="div1">id:div1</div>
					<div class="class1">class:class1</div>
					<div class="class1">class:class2</div>
				</div>
			</div>
		
	</body>
</html>