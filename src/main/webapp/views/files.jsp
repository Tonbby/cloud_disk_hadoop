<%@ page import="com.cosyblogs.cloud.disk.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    Object user = session.getAttribute("user");
    String username = null;
    if (user == null) {
        response.sendRedirect(path + "/login.jsp");
    } else {
        username = ((User) user).getUsername();
        System.out.println("files.jsp:" + user);
    }
%>
<!-- Office.js -->
<%--<script src="https://appsforoffice.microsoft.com/lib/1/hosted/office.js"></script>--%>

<%--<!-- highlight.js -->--%>
<%--<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.2.0/styles/default.min.css"/>--%>
<%--<script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.2.0/highlight.min.js"></script>--%>

<!DOCTYPE html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <meta name="description"
          content="A fully featured admin theme which can be used to build CRM, CMS, etc.">
    <meta name="author" content="Coderthemes">

    <link rel="shortcut icon" href="<%=path %>/bootstrap/images/wo.jpg">


    <title>Hadoop 云盘</title>

    <jsp:include page="common/_css.jsp"/>

    <!-- bootstrap table css -->
    <link href="<%=path %>/bootstrap/table/bootstrap-table.min.css"
          rel="stylesheet" type="text/css">
    <!-- modal css -->
    <link href="<%=path %>/bootstrap/plugins/modal-effect/component.css"
          rel="stylesheet" type="text/css">
    <!-- sweetalert css -->
    <link href="<%=path %>/bootstrap/plugins/sweetalert/sweetalert.css"
          rel="stylesheet" type="text/css">

</head>
<style>
    .preview {
        display: none; /* Hidden by default */
        position: fixed; /* Stay in place */
        z-index: 1000; /* Sit on top */
        left: 0;
        top: 0;
        width: 100%; /* Full width */
        height: 100%; /* Full height */
        overflow: auto; /* Enable scroll if needed */
        background-color: rgb(0, 0, 0); /* Fallback color */
        background-color: rgba(0, 0, 0, 0.9); /* Black w/ opacity */
    }

    .preview-content {
        background-color: #fefefe;
        margin-left: 10%; /* 15% from the top and centered */
        margin-top: 30px;
        padding: 5px;
        border: 1px solid #888;
        width: 80%; /* Could be more or less, depending on screen size */
        height: 800px;
    }
</style>
<div id="preview_modal" class="preview">
    <div class="preview-content">
        <span class="preview_close">&times;</span>
        <embed id="pre-content" width="100%" height="100%"/>
    </div>
</div>
<body class="fixed-left">

<!-- Begin page -->
<div id="wrapper">

    <!-- Top Bar Start -->
    <jsp:include page="common/topBar.jsp"/>
    <!-- Top Bar End -->

    <!-- Left Sidebar Start -->
    <jsp:include page="common/sidebar.jsp"/>
    <!-- Left Sidebar End -->

    <!-- right Content Start -->
    <div class="content-page">
        <!-- Start content -->
        <div class="content">
            <div class="container">

                <!-- Page-Title -->
                <div class="row">
                    <div class="col-sm-12">
                        <h4 class="pull-left page-title">欢迎您!</h4>
                        <ol class="breadcrumb pull-right">
                            <li><a href="#">Hadoop 云盘</a></li>
                            <li class="active">文件管理</li>
                        </ol>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <h3 class="panel-title">文件列表</h3>
                            </div>

                            <div class="panel-body">
                                <div class="row">
                                    <div id="toolbar" class="toolbar">
                                        <button id="btn_upload" class="btn btn-default"
                                                data-toggle="modal" data-target="#fileModal">
                                            <span class="md md-cloud-upload" aria-hidden="true"/>上传文件
                                        </button>
                                        <button id="btn_delete" class="btn btn-default"
                                                onclick="deleteFiles()">
                                            <span class="md md-delete" aria-hidden="true"/>批量删除
                                        </button>
                                        <button id="btn_mkdir" class="btn btn-default"
                                                data-toggle="modal" data-target="#dirModal">
                                            <span class="md md-folder" aria-hidden="true"/>新建文件夹
                                        </button>
                                        <button id="btn_download" class="btn btn-default"
                                                onclick="upperDir()">
                                            <span class="md md-assignment-return" aria-hidden="true"/>返回上一层
                                        </button>
                                    </div>
                                    <table id="fileTable"></table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- End Row -->
                <div class="row">
                    <div class="col-md-12">
                        <div id="fileModal" class="modal fade" tabindex="-1"
                             role="dialog" aria-labelledby="fileModalLabel"
                             aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <button type="button" class="close" data-dismiss="modal"
                                                aria-hidden="true">×
                                        </button>
                                        <h4 class="modal-title" id="fileModalLabel">上传文件</h4>
                                    </div>
                                    <div class="modal-body">
                                        <form id="fileForm" class="form-horizontal" role="form"
                                              enctype="multipart/form-data">
                                            <div class="form-group" style="display: none">
                                                <label class="col-md-2 control-label">文件所属</label>
                                                <div class="col-md-10">
                                                    <input id="ffolder" type="text" name="ffolder" class="form-control"
                                                           readonly="readonly">
                                                </div>
                                            </div>
                                            <div class="form-group" style="display: none">
                                                <label class="col-md-2 control-label">上传ID</label>
                                                <div class="col-md-10">
                                                    <input id="fowner" type="text" name="fowner" class="form-control"
                                                           value="${user.id}" readonly="readonly">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-md-2 control-label">文件路径</label>
                                                <div class="col-md-10">
                                                    <input id="fpath" type="text" name="fpath" class="form-control"
                                                           readonly="readonly">
                                                </div>
                                            </div>
                                            <div class="form-group" readonly="readonly">
                                                <label class="col-md-2 control-label">文件类型</label>
                                                <div class="col-md-10">
                                                    <div class="input-group m-t-12" required="">
                                                        <div class="radio radio-inline">
                                                            <input type="radio" id="inlineRadio1" value="1" readonly="readonly"
                                                                   name="ftype">
                                                            <label for="inlineRadio1">图片</label>
                                                        </div>
                                                        <div class="radio radio-inline">
                                                            <input type="radio" id="inlineRadio2" value="2" readonly="readonly"
                                                                   name="ftype">
                                                            <label for="inlineRadio2">文档</label>
                                                        </div>
                                                        <div class="radio radio-inline">
                                                            <input type="radio" id="inlineRadio3" value="3" readonly="readonly"
                                                                   name="ftype">
                                                            <label for="inlineRadio3">音乐</label>
                                                        </div>
                                                        <div class="radio radio-inline">
                                                            <input type="radio" id="inlineRadio4" value="4" readonly="readonly"
                                                                   name="ftype">
                                                            <label for="inlineRadio4">视频</label>
                                                        </div>
                                                        <div class="radio radio-inline">
                                                            <input type="radio" id="inlineRadio5" value="5" readonly="readonly"
                                                                   name="ftype">
                                                            <label for="inlineRadio5">其他</label>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-md-2 control-label">选择文件</label>
                                                <div class="col-md-10">
                                                    <div class="input-group m-t-12">
                                                        <input id="file" type="file" name="file" style="display: none"
                                                               onchange="reFile(this)" required="required">
                                                        <input id="refile" type="text" class="form-control"
                                                               onchange="reFile(this)" placeholder="Please choose file...">
                                                        <span class="input-group-btn">
                                                            <button onclick="openFile()" type="button"
                                                                class="btn waves-effect waves-light btn-primary">Select</button>
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                        </form>
                                    </div>

                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-default waves-effect"
                                                data-dismiss="modal">取消
                                        </button>
                                        <button onclick="insertFile()" type="button"
                                                class="btn btn-primary waves-effect waves-light">上传
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12">
                        <div id="fileModify" class="modal fade" tabindex="-1"
                             role="dialog" aria-labelledby="fileModifyLabel"
                             aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <button type="button" class="close" data-dismiss="modal"
                                                aria-hidden="true">×
                                        </button>
                                        <h4 class="modal-title" id="fileModifyLabel">修改文件</h4>
                                    </div>
                                    <div class="modal-body">
                                        <form id="modifyForm" class="form-horizontal" role="form"
                                              enctype="multipart/form-data">
                                            <div class="form-group" style="display: none;">
                                                <label class="col-md-2 control-label">文件编号</label>
                                                <div class="col-md-10">
                                                    <input id="mfid" type="text" name="fid"
                                                           class="form-control" readonly="readonly">
                                                </div>
                                            </div>
                                            <div class="form-group" style="display: none;">
                                                <label class="col-md-2 control-label">文件路径</label>
                                                <div class="col-md-10">
                                                    <input id="mfpath" type="text" name="fpath"
                                                           class="form-control" readonly="readonly">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-md-2 control-label">文件名称</label>
                                                <div class="col-md-10">
                                                    <input id="mfname" type="text" name="fname"
                                                           class="form-control">
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-default waves-effect"
                                                data-dismiss="modal">取消
                                        </button>
                                        <button onclick="updateFile()" type="button"
                                                class="btn btn-primary waves-effect waves-light">修改
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12">
                        <div id="fileDetails" class="modal fade" tabindex="-1"
                             role="dialog" aria-labelledby="fileDetailsLabel"
                             aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <button type="button" class="close" data-dismiss="modal"
                                                aria-hidden="true">×
                                        </button>
                                        <h4 class="modal-title" id="fileDetailsLabel">详情信息</h4>
                                    </div>
                                    <div class="modal-body">
                                        <form id="viewForm" class="form-horizontal" role="form"
                                              enctype="multipart/form-data">
                                            <div class="form-group">
                                                <label class="col-md-2 control-label">文件名称</label>
                                                <div class="col-md-10">
                                                    <input id="ffname" type="text" name="fname"
                                                           class="form-control" readonly="readonly">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-md-2 control-label">文件大小</label>
                                                <div class="col-md-10">
                                                    <input id="ffsize" type="text" name="fsize"
                                                           class="form-control" readonly="readonly">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-md-2 control-label">文件后缀</label>
                                                <div class="col-md-10">
                                                    <input id="ffsuffix" type="text" name="fsuffix"
                                                           class="form-control" readonly="readonly">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-md-2 control-label">文件路径</label>
                                                <div class="col-md-10">
                                                    <input id="ffpath" type="text" name="fpath"
                                                           class="form-control" readonly="readonly">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-md-2 control-label">上传时间</label>
                                                <div class="col-md-10">
                                                    <input id="fftime" type="text" name="ftime"
                                                           class="form-control" readonly="readonly">
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-default waves-effect"
                                                data-dismiss="modal">关闭
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12">
                        <div id="dirModal" class="modal fade" tabindex="-1" role="dialog"
                             aria-labelledby="dirModalLabel" aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <button type="button" class="close" data-dismiss="modal"
                                                aria-hidden="true">×
                                        </button>
                                        <h4 class="modal-title" id="dirModalLabel">新建文件夹</h4>
                                    </div>
                                    <div class="modal-body">
                                        <form id="dirForm" class="form-horizontal" role="form"
                                              enctype="multipart/form-data">
                                            <div class="form-group">
                                                <label class="col-md-2 control-label">文件路径</label>
                                                <div class="col-md-10">
                                                    <input id="fpathm" type="text" name="fpath"
                                                           class="form-control" readonly="readonly">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-md-2 control-label">文件名</label>
                                                <div class="col-md-10">
                                                    <input id="fnamem" type="text" name="fname"
                                                           class="form-control">
                                                </div>
                                            </div>

                                            <div class="form-group" style="display: none;">
                                                <label class="col-md-2 control-label">文件所属</label>
                                                <div class="col-md-10">
                                                    <input id="ffolderm" type="text" name="ffolder"
                                                           class="form-control">
                                                </div>
                                            </div>
                                            <div class="form-group" style="display: none">
                                                <label class="col-md-2 control-label">上传ID</label>
                                                <div class="col-md-10">
                                                    <input id="fowner" type="text" name="fowner"
                                                           class="form-control" value="${user.id}"
                                                           readonly="readonly">
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-default waves-effect"
                                                data-dismiss="modal">取消
                                        </button>
                                        <button onclick="insertDir()" type="button"
                                                class="btn btn-primary waves-effect waves-light">新建
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- container -->
        </div>
        <!-- content -->

        <footer class="footer text-right"> 2023 © Hadoop 云盘.</footer>

    </div>
    <!-- right Content Start End -->

</div>
<!-- END page -->

<jsp:include page="common/_js.jsp"/>

<!-- bootstrap table js -->
<script src="<%=path %>/bootstrap/table/bootstrap-table.min.js"></script>
<script src="<%=path %>/bootstrap/table/bootstrap-table-zh-CN.min.js"></script>

<!-- modal-effect js -->
<script src="<%=path %>/bootstrap/plugins/modal-effect/classie.js"></script>
<script src="<%=path %>/bootstrap/plugins/modal-effect/modalEffects.js"></script>

<!-- sweetalert js -->
<script src="<%=path %>/bootstrap/plugins/sweetalert/sweetalert.min.js"></script>

<script>
    // $ == jQuery
    var username = "<%=username%>"
    console.log("files.jsp:\nusername:" + username);
    var ffolder = 0;
    var upper = [];
    var fpath = '/hdfs/' + username + '/';
    var upperfpath = [];
    upper.push(0);
    upperfpath.push('/hdfs/' + username + '/');
    $('#fpath').val(fpath);
    $('#ffolder').val(ffolder);
    $('#fpathm').val(fpath);
    $('#ffolderm').val(ffolder);
    $(function () {
        $('#fileTable').bootstrapTable({
            url: '<%=path %>/file/getFiles',
            method: 'get',
            cache: false,
            pagination: true,
            pageNumber: 1,                      //初始化加载第一页，默认第一页,并记录
            pageSize: 10,                     //每页的记录行数（*）
            pageList: [10, 25, 50, 100],        //可供选择的每页的行数（*）
            sidePagination: 'server',
            clickToSelect: true,
            uniqueId: "fid",
            toolbar: "#toolbar",
            columns: [
                {
                    checkbox: true, visible: true,
                    formatter: function (value, row, index) {
                        if (row.ftype == 6)
                            return {disabled: true}
                    }

                },
                {
                    field: 'fname', title: '文件名', align: 'center',
                    formatter: function (value, row, index) {
                        if (row.ftype != 6)
                            return '<a href="<%=path %>/hdfs/download?fileName=' + row.fpath + '">' + value + '</a>';
                        else
                            return '<a href="#" onclick="openDir(\'' + row.fid + '\',\'' + row.fname + '\',\'' + row.fpath + '\')">' + value + '</a>';

                    }
                },
                {
                    field: 'fsize', title: '文件大小（KB）', align: 'center',
                    formatter: function (value, row, index) {
                        if (row.ftype != 6)
                            return (value / (1024)).toFixed(3);
                        else
                            return '------';
                    }
                },
                {
                    field: 'ftype', title: '文件类型', align: 'center',
                    formatter: function (value, row, index) {
                        var type = ''
                        switch (value) {
                            case 1 :
                                type = '图片';
                                break;
                            case 2 :
                                type = '文档';
                                break;
                            case 3 :
                                type = '音乐';
                                break;
                            case 4 :
                                type = '视频';
                                break;
                            case 5 :
                                type = '其他';
                                break;
                            case 6 :
                                type = '文件夹';
                                break;
                            default:
                                type = '未知类型';
                        }
                        return type;
                    }
                },
                {field: 'ftime', title: '上传时间', align: 'center'},
                {
                    field: 'fid', title: '操作', align: 'center',
                    formatter: function (value, row, index) {
                        if (row.ftype != 6)
                            return '<a href="#" onclick="preView(\'' + value + '\',\'' + row.ftype + '\',\'' + row.fsuffix + '\')">预览</a>&nbsp;&nbsp;' +
                                '<a href="#" onclick="viewFile(\'' + value + '\')">详情</a>&nbsp;&nbsp;' +
                                '<a href="#" onclick="collectFile(\'' + value + '\')">收藏</a>&nbsp;&nbsp;' +
                                '<a href="#" onclick="modifyFile(\'' + value + '\')">编辑</a>&nbsp;&nbsp;' +
                                '<a href="#" onclick="deleteFile(\'' + value + '\')">删除</a>';
                        else
                            return '<a href="#" onclick="deleteDir(\'' + value + '\',\'' + row.fpath + '\')">删除</a>';
                    }
                }
            ],
            queryParams: function (params) {
                params = {
                    fowner: "${user.id}",
                    ffolder: ffolder,
                    pageNum: (params.offset / params.limit) + 1,
                    pageSize: params.limit,                        //页面大小

                };
                return params;
            }
        });
    });

    function getTypeBySuffix(suffix) {
        if (suffix == '.pdf') {
            return 'application/pdf';
        } else if (suffix == '.txt') {
            return 'text/plain';
        } else if (suffix == '.doc' || suffix == '.docx') {
            return 'application/msword';
        } else if (suffix == '.mp3' || suffix == '.m4a') {
            return 'audio/mpeg';
        } else if (suffix == '.mp4') {
            return 'video/mp4';
        } else if (suffix == '.jpg' || suffix == '.png' || suffix == 'jpeg') {
            return 'image/png';
        } else {
            return null;
        }
    }


    // Get the modal
    var modal = document.getElementById("preview_modal");

    // Get the <span> element that closes the modal
    var span = document.getElementsByClassName("preview_close");

    // When the user clicks on <span> (x), close the modal
    span.onclick = function () {
        var embed = document.getElementById('pre-content');
        embed.src = "about:blank"; // 将src属性设置为about:blank
        embed.type = ""; // 将type属性设置为空字符串
        modal.style.display = "none";
    }

    // When the user clicks anywhere outside of the modal, close it
    window.onclick = function (event) {
        if (event.target == modal) {
            var embed = document.getElementById('pre-content');
            embed.src = "about:blank"; // 将src属性设置为about:blank
            embed.type = ""; // 将type属性设置为空字符串
            modal.style.display = "none";
        }
    }

    function preView(fid, ftype, fsuffix) {
        console.log("fsuffix: " + fsuffix);
        var xhr = new XMLHttpRequest();
        xhr.open('GET', '<%=path%>/hdfs/preview?fid=' + fid, true);
        xhr.responseType = 'arraybuffer';
        var type = getTypeBySuffix(fsuffix);
        if (type == null) {
            alert("暂不支持该类型文件的预览！")
            return;
        }
        console.log("type: " + type);
        xhr.onload = function () {
            if (this.status == 200) {
                var blob = new Blob([this.response], {type: type});
                var url = URL.createObjectURL(blob);
                var embed = document.getElementById('pre-content');
                if (type == 'application/pdf') {
                    embed.src = url;
                } else if (type.startsWith('image/')) {
                    embed.src = url;
                } else if (type.startsWith('audio/')) {
                    embed.src = url;
                    embed.setAttribute('controls', true);
                } else if (type.startsWith('video/')) {
                    embed.src = url;
                    embed.setAttribute('controls', true);
                } else if (type == 'text/plain') {
                    embed.src = url;
                } else {
                    alert("暂不支持对该类型文件的预览！");
                    return;
                }
                modal.style.display = "block";

            }
        };
        xhr.send();
    }

    function collectFile(fid) {
        $.get('<%=path%>/file/collectFile', {fid: fid}, function (data) {
            swal("已收藏!", "这个文件已放入收藏夹.", "success");
        }, 'json');
    }

    function viewFile(fid) {
        var row = $('#fileTable').bootstrapTable('getRowByUniqueId', fid);
        $('#ffname').val(row.fname);
        $('#ffsize').val(row.fsize / (1024 * 1024) + 'Mb');
        $('#ffsuffix').val(row.fsuffix);
        $('#ffpath').val(row.fpath);
        $('#fftime').val(row.ftime);
        $('#fileDetails').modal('show');
    }


    function deleteFile(fid) {
        swal({
            title: "是否确认?",
            text: "你将会删除这个文件！",
            type: "warning",
            showCancelButton: true,
            confirmButtonColor: "#DD6B55",
            confirmButtonText: "Yes, delete it!",
            closeOnConfirm: false
        }, function () {
            $.get('<%=path%>/file/deleteFile', {fid: fid}, function (data) {
                swal("已删除!", "这个文件已删除.", "success");
                $('#fileTable').bootstrapTable('refresh');
            }, 'json');
        });
    }

    function deleteFiles() {
        var rows = $('#fileTable').bootstrapTable('getSelections');
        if (rows.length == 0) {
            swal("请选择需要删除的文件 ... ");
            return;
        }
        var fids = '';
        for (var i = 0; i < rows.length; i++) {
            fids += ',' + rows[i].fid;
        }
        fids = fids.substring(1, fids.length); // 1,2,3,4,5,6
        swal({
            title: "是否确认?",
            text: "你将会删除选中的文件！",
            type: "warning",
            showCancelButton: true,
            confirmButtonColor: "#DD6B55",
            confirmButtonText: "Yes, delete them!",
            closeOnConfirm: false
        }, function () {
            $.get('<%=path%>/file/deleteFiles', {fids: fids}, function (data) {
                swal("已删除!", "选中文件已删除.", "success");
                $('#fileTable').bootstrapTable('refresh');
            }, 'json');
        });
    }

    function insertFile() {
        $.ajax({
            url: "<%=path%>/file/insertFile",
            type: "POST",
            data: new FormData($('#fileForm')[0]),
            processData: false,// 告诉jQuery不要去处理发送的数据(必须设置)
            contentType: false, // 告诉jQuery不要去设置Content-Type请求头（必须设置）
            dataType: "json",
            success: function (result) {
                swal("已上传!", result.msg, "success");
                $('#fileModal').modal('hide');  // $('#userModal').modal('show');
                $('#fileForm')[0].reset();
                $('#fileTable').bootstrapTable('refresh');
                $('#fpath').val(fpath);
                $('#ffolder').val(ffolder);
            }
        });
    }

    function insertDir() {
        $.ajax({
            url: "<%=path%>/file/insertDir",
            type: "POST",
            data: new FormData($('#dirForm')[0]),
            processData: false,// 告诉jQuery不要去处理发送的数据(必须设置)
            contentType: false, // 告诉jQuery不要去设置Content-Type请求头（必须设置）
            dataType: "json",
            success: function (result) {
                swal("已上传!", result.msg, "success");
                $('#dirModal').modal('hide');  // $('#userModal').modal('show');
                $('#dirForm')[0].reset();
                $('#fileTable').bootstrapTable('refresh');
                $('#fpathm').val(fpath);
                $('#ffolderm').val(ffolder);
            }
        });
    }

    function modifyFile(fid) {
        var row = $('#fileTable').bootstrapTable('getRowByUniqueId', fid);
        $('#mfname').val(row.fname.substring(0, row.fname.lastIndexOf('.')));
        $('#mfid').val(row.fid);
        $('#mfpath').val(row.fpath);
        $('#fileModify').modal('show');

    }

    function updateFile() {
        $.ajax({
            url: "<%=path%>/file/updateFile",
            type: "POST",
            data: new FormData($('#modifyForm')[0]),
            processData: false,// 告诉jQuery不要去处理发送的数据(必须设置)
            contentType: false, // 告诉jQuery不要去设置Content-Type请求头（必须设置）
            dataType: "json",
            success: function (result) {
                swal("已修改!", result.msg, "success");
                $('#fileModify').modal('hide');  // $('#userModal').modal('show');
                $('#fileTable').bootstrapTable('refresh');
            }
        });
    }

    function openDir(fid, fname, fpathm) {
        console.log("openDir1: upper:" + upper + "\nupperfpath" + upperfpath + "\nffolder" + ffolder);
        ffolder = fid;
        fpath = fpathm;
        upper.push(ffolder);
        upperfpath.push(fpath);
        $('#fpath').val(fpath);
        $('#ffolder').val(ffolder);
        $('#fpathm').val(fpath);
        $('#ffolderm').val(ffolder);
        $('#fileTable').bootstrapTable('refresh');
        console.log("openDir: upper:" + upper + "\nupperfpath" + upperfpath + "\nffolder" + ffolder);
    }

    function upperDir() {
        if (upper.length != 1) {
            console.log("进if了哦")

            var tempArray1 = upper.slice();
            tempArray1.pop();
            upper = tempArray1;
            var tempArray2 = upperfpath.slice();
            tempArray2.pop();
            upperfpath = tempArray2;
        }

        ffolder = upper[upper.length - 1];
        fpath = upperfpath[upperfpath.length - 1];
        $('#fpath').val(fpath);
        $('#ffolder').val(ffolder);
        $('#fpathm').val(fpath);
        $('#ffolderm').val(ffolder);
        $('#fileTable').bootstrapTable('refresh');
        console.log("upperDir: upper:" + upper + "\nupperfpath" + upperfpath + "\nffolder" + ffolder);


    }

    function deleteDir(fid, fpathz) {
        swal({
            title: "是否确认?",
            text: "你将会删除整个文件夹！（此操作不可恢复）",
            type: "warning",
            showCancelButton: true,
            confirmButtonColor: "#DD6B55",
            confirmButtonText: "Yes, delete it!",
            closeOnConfirm: false
        }, function () {
            $.get('<%=path%>/file/dropDir', {
                fid: fid,
                fpathz: fpathz
            }, function (data) {
                swal("已删除!", "这个文件已删除.", "success");
                $('#fileTable').bootstrapTable('refresh');
            }, 'json');
        });

    }

    function openFile() {
        $('#file').click();
    }
    function reFile(file) {
        var path = file.value;
        $('#refile').val(path.substring(path.lastIndexOf('\\') + 1));
        console.log("refile!!!")
        var filePath = file.value;
        var fileType = filePath.substring(filePath.lastIndexOf('.') + 1).toLowerCase();

        // 根据文件后缀名选择对应的文件类型
        switch (fileType) {
            case 'jpg':
            case 'jpeg':
            case 'png':
            case 'gif':
                document.getElementById('inlineRadio1').checked = true;
                break;
            case 'doc':
            case 'docx':
            case 'xls':
            case 'xlsx':
            case 'ppt':
            case 'pptx':
            case 'pdf':
            case 'txt':
                document.getElementById('inlineRadio2').checked = true;
                break;
            case 'mp3':
            case 'wav':
            case 'wma':
            case 'm4a':
                document.getElementById('inlineRadio3').checked = true;
                break;
            case 'mp4':
            case 'avi':
            case 'mov':
            case 'rmvb':
                document.getElementById('inlineRadio4').checked = true;
                break;
            default:
                document.getElementById('inlineRadio5').checked = true;
        }

        // 显示选择的文件名
        var arr = filePath.split('\\');
        var fileName = arr[arr.length - 1];
        document.getElementById('refile').value = fileName;
    }

</script>

</body>
</html>