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
			function fun1()
			{
				console.log("fun1() 실행");
			}
			
			function fun2(a,b) //var a, var b 를 하면 문법 오류가 뜬다. default값을 못준다,
			{
				var result = a + b;
				return result;
			}
			
			function fun3(a,b)
			{
				var result = fun2(a,b);
				console.log(result)
			}
			
			function fun4(result)
			{
				if(result == null)
				{
					return false;
				}
				else
				{
					return true;
				}
			}
			
			function fun5()
			{
				var mid = document.loginForm.mid.value; //loginForm이라는 이름을 갖고있는 태그를 찾아서 안에있는 mid이름을 갖고있는 태그를 찾아서 그것의 value값.
				if(mid == "")
					return false;
				else
					return true;
			}
			
			var fun6 = function()
			{
				console.log("fun6() 함수 실행")
			}; // 이름없는 함수를 정의를 해서 변수에 넣으면 var6이 함수 이름이 되어버린다. function fun6(){}과 완전히 똑같다.
		</script>
	
	</head>
	<body>
		<h5 class="alert alert-info">/home/exam06_function.jsp</h5>	
		
		<div>
			<button onclick="fun1()" class="btn btn-success btn-sm">fun1() 호출</button>
			<button onclick="fun3(3, 5)"class="btn btn-success btn-sm">fun3() 호출</button>
			
			<a onclick="return fun4(null)" href="main.do" class = "btn btn-success btn-sm">메인 화면</a>
			<%--  fun4의 결과값을 원래 a태그 안의 결과값으로 return 해준다. true면 href 실행, false면 href 실행 못하게 함 --%>
			<form name="loginForm" method="post" action="main.do" onsubmit = "return fun5()" style = "margin-top:10px">
				<input type="text" name="mid"/>
				<%--submit의 효과를 내는 것이 3개가 있다.
					submit,
					button,
					input type="image"--%>
				<input type="submit" value="전송" class="btn btn-success btn-sm"/>
				<button  class="btn btn-info btn-sm">전송</button>
				<input type="image" src="${pageContext.request.contextPath}/resource/img/redbutton.PNG"/>
			</form>
			<button onclick="fun6()" class="btn btn-success btn-sm">fun6() 호출</button>
		</div>		
	</body>
</html>