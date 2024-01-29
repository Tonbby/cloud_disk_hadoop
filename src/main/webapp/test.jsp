<!DOCTYPE html>
<html>
<%
    String path = request.getContextPath();
%>
<head>
    <meta charset="UTF-8">
    <title>PDF Preview</title>
    <style>
        .modal {
            display: none; /* Hidden by default */
            position: fixed; /* Stay in place */
            z-index: 1; /* Sit on top */
            left: 0;
            top: 0;
            width: 100%; /* Full width */
            height: 100%; /* Full height */
            overflow: auto; /* Enable scroll if needed */
            background-color: rgb(0, 0, 0); /* Fallback color */
            background-color: rgba(0, 0, 0, 0.9); /* Black w/ opacity */
        }

        .modal-content {
            background-color: #fefefe;
            margin: 15% auto; /* 15% from the top and centered */
            padding: 5px;
            border: 1px solid #888;
            width: 80%; /* Could be more or less, depending on screen size */
            height: 70%;
        }
    </style>
</head>
<body>
<button onclick="preview()">Preview PDF</button>

<div id="pdfModal" class="modal">
    <div class="modal-content">
        <span class="close">&times;</span>
        <embed id="pdf" type="application/pdf" width="100%" height="100%"/>
    </div>
</div>

<script>
    // Get the modal
    var modal = document.getElementById("pdfModal");

    // Get the <span> element that closes the modal
    var span = document.getElementsByClassName("close")[0];

    // When the user clicks on <span> (x), close the modal
    span.onclick = function () {
        modal.style.display = "none";
    }

    // When the user clicks anywhere outside of the modal, close it
    window.onclick = function (event) {
        if (event.target == modal) {
            modal.style.display = "none";
        }
    }

    function preview() {
        var xhr = new XMLHttpRequest();
        xhr.open('GET', '/hdfs/preview?fileName=/hdfs/hc/2.基于Hadoop的校园云盘信息管理系统设计_刘晓莉.pdf', true);
        xhr.responseType = 'arraybuffer';
        xhr.onload = function () {
            if (this.status == 200) {
                var blob = new Blob([this.response], {type: 'application/pdf'});
                var url = URL.createObjectURL(blob);
                var embed = document.getElementById('pdf');
                embed.src = url;
                modal.style.display = "block";
            }
        };
        xhr.send();
    }
</script>
</body>
</html>
