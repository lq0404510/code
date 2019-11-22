<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Insert title here</title>
    <script  src="${pageContext.request.contextPath}/js/jquery-3.1.0.js" ></script>
</head>

<body>

<form id="codeform">

    <input type="text" placeholder="填写手机号" name="phone">
    <button type="button" id="sendCode">发送验证码</button><br>
    <font id="daojishi" color="red" ></font>
    <br>

    <input type="text" placeholder="填写验证码" name="verify_code">
    <button type="button" id="verifyCode">确定</button>
    <font id="result" color="green" ></font><font id="error" color="red" ></font>

</form>


</body>
<script type="text/javascript">

    var t=20;//设定倒计时的时间
    var id;
    function refer(){

        $("#daojishi").text("请于"+t+"秒内填写验证码 "); // 显示倒计时
        t--; // 计数器递减
        if(t<=0){
            clearInterval(id);
            $("#daojishi").text("验证码已失效，请重新发送！ ");
        }
    }

    $(function(){
        $("#sendCode").click( function () {

            $.post("${pageContext.request.contextPath}/sendCode",$("#codeform").serialize(),function(data){
                if(data=="success"){
                    t=20;
                    clearInterval(id);
                    id= setInterval("refer()",1000);//启动1秒定时
                } else if (data == "num") {
                    $("#sendCode").attr("disabled","disabled");
                    clearInterval(id);
                    $("#daojishi").text("24小时之内只能发送3次");
                }
            });
        });

        $("#verifyCode").click( function () {

            $.post("${pageContext.request.contextPath}/verifiCode",$("#codeform").serialize(),function(data){
                if(data=="success"){
                    $("#result").attr("color","green");
                    $("#result").text("验证成功");
                    clearInterval(id);
                    $("#daojishi").text("")
                }else{
                    $("#result").attr("color","red");
                    $("#result").text("验证失败");
                }
            });
        });
    });
</script>
</html>