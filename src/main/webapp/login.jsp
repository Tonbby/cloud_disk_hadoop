<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <meta name="description"
          content="A fully featured admin theme which can be used to build CRM, CMS, etc.">
    <meta name="author" content="Coderthemes">

    <link rel="shortcut icon" href="/bootstrap/images/wo.jpg">


    <title>Hadoop 云盘</title>

    <jsp:include page="./views/common/_css.jsp"/>

    <style>
        html, body {
            height: 100%;
        }

        body {
            height: 100%;
            width: 100%;
            background-image: url('/bootstrap/images/login.jpg');
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
                <strong>Hadoop 云盘</strong>
            </h3>
        </div>

        <div class="panel-body">
            <form class="form-horizontal m-t-20" method="post" action="login">

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
                        <div class="checkbox checkbox-primary">
                            <input id="checkbox-signup" type="checkbox"> <label
                                for="checkbox-signup"> 记住我 </label>
                        </div>

                    </div>
                </div>

                <div class="form-group text-center m-t-40">
                    <div class="col-xs-12">
                        <button
                                class="btn btn-primary btn-lg w-lg waves-effect waves-light"
                                type="submit">登录
                        </button>
                    </div>
                </div>

                <div class="form-group m-t-30">
                    <div class="col-sm-5 text-right">
                        没有账号？-><a href="register.jsp">创建账号</a>
                    </div>
                </div>
            </form>
        </div>

    </div>
</div>

<jsp:include page="./views/common/_js.jsp"/>
</body>
</html>
<style>
    .message {
        position: fixed;
        top: 0;
        left: 50%;
        transform: translateX(-50%);
        background: #f14141;
        color: white;
        padding: 10px 20px;
        border-radius: 5px;
        margin-top: 25px;

    }
</style>
<script>
	var msg = '<%= session.getAttribute("login") %>';
	if (msg == 'failure') {
        var message = document.createElement('div');
        message.innerHTML = '用户名或密码错误!';
        message.className='message';
        document.body.appendChild(message);

        setTimeout(function() {
            document.body.removeChild(message);
        }, 3000);
	}
</script>