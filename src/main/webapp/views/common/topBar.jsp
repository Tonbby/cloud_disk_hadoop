<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
%>
<div class="topbar">
    <!-- LOGO -->
    <div class="topbar-left">
        <div class="text-center">
            <a href="${pageContext.request.contextPath}/views/index.jsp"
               class="logo"><i class="md md-cloud-queue"></i> <span>Hadoop 云盘</span></a>
        </div>
    </div>
    <!-- Button mobile view to collapse sidebar menu -->
    <div class="navbar navbar-default" role="navigation">
        <div class="container">
            <div class="">
                <div class="pull-left">
                    <button class="button-menu-mobile open-left">
                        <i class="fa fa-bars"></i>
                    </button>
                    <span class="clearfix"></span>
                </div>
                <%--				<form class="navbar-form pull-left" role="search">--%>
                <%--					<div class="form-group">--%>
                <%--						<input type="text" class="form-control search-bar"--%>
                <%--							placeholder="Type here for search...">--%>
                <%--					</div>--%>
                <%--					<button type="button"--%>
                <%--						class="btn waves-effect waves-light btn-primary">--%>
                <%--						<i class="fa fa-search"></i>--%>
                <%--					</button>--%>
                <%--				</form>--%>
                <ul class="nav navbar-nav navbar-right pull-right">
                    <li>
                        <a onclick="logout()" href="<%=path%>/login.jsp">退出系统</a>
                    </li>
                    <li class="hidden-xs"><a href="#" id="btn-fullscreen"
                                             class="waves-effect"><i class="md md-crop-free"></i> </a></li>
                </ul>
            </div>
            <!--/.nav-collapse -->
        </div>
    </div>
</div>
<script>
    function logout(){
        $.get('<%=path%>/logout', function () {

        }, 'json');
    }
</script>