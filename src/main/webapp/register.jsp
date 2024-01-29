<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<meta name="description"
	content="A fully featured admin theme which can be used to build CRM, CMS, etc.">
<meta name="author" content="Coderthemes">

<link rel="shortcut icon" href="bootstrap/images/isoftstone.png">

<title>简存取 -  拾光笔记</title>

<jsp:include page="./views/common/_css.jsp" />
	<style>
		html,body{
			height: 100%;
		}

		body {
			height: 100%;
			width: 100%;
			background-image: url('./bootstrap/images/login.jpg');
			background-repeat: no-repeat;
			background-attachment: fixed;
			background-size: 100% 100%;
		}
	</style>
</head>
<body>

	<div class="wrapper-page">
		<div class="panel panel-color panel-primary panel-pages">
			<div class="panel-heading bg-img">
				<div class="bg-overlay"></div>
				<h3 class="text-center m-t-10 text-white">
					注册 <strong>云小盘</strong>
				</h3>
			</div>

			<div class="panel-body">
				<form class="form-horizontal m-t-20" method="post"
					action="insertUser" onsubmit="submitForm()">

					<div class="form-group">
						<div class="col-xs-12">
							<input class="form-control input-lg" type="text" required=""
								name="username" placeholder="Username">
						</div>
					</div>

					<div class="form-group">
						<div class="col-xs-12">
							<input class="form-control input-lg" type="password" required=""
								name="password" placeholder="Password">
						</div>
					</div>

					<div class="form-group">
						<div class="col-xs-12">
							<input class="form-control input-lg" type="password" required=""
								name="role" placeholder="Secret key">
						</div>
					</div>



					<div class="form-group text-center m-t-40">
						<div class="col-xs-12">
							<button
								class="btn btn-primary btn-lg w-lg waves-effect waves-light"
								type="submit">提交</button>
						</div>
					</div>

					<div class="form-group m-t-30">
						<div class="col-sm-7">
							<a href="login.jsp">返回?</a>
						</div>
					</div>
				</form>
			</div>

		</div>
	</div>
	<!-- 若登陆失败，弹窗提醒 -->
	<%
		String mess = (String) session.getAttribute("message");
		if (mess == null) {

		} else {
	%>
	<script type="text/javascript">
		alert("<%=mess%>");
	</script>
	<%
		session.setAttribute("message", null);
	%>
	<% }%>
	<jsp:include page="./views/common/_js.jsp" />
</body>
</html>