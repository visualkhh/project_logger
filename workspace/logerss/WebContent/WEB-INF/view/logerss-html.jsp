<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="fluid"  uri="http://visualkhh.com/fluid"%>
<!DOCTYPE html>
<html lang="<fluid:insertString id="lang"/>">
<!-- 김현하 -->
  <head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<fluid:insertTag id="meta-viewport" attribute="name='viewport'" name="meta" target="content"></fluid:insertTag>
	<!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
	<fluid:insertTag id="meta-description" attribute="name='description'" name="meta" target="content"></fluid:insertTag>
	<fluid:insertTag id="meta-author" attribute="name='author'"  name="meta" target="content"></fluid:insertTag>
    
	<fluid:insertTag id="icon" name="link" attribute="rel='icon'" target="href"></fluid:insertTag>

	<title><fluid:insertString id="title"/></title>
    
	<!-- default-head-css -->
	<fluid:insertView id="default-head-css"/>
	<!-- page-head-css -->
	<fluid:insertTag id="page-head-css" name="link" attribute="rel='stylesheet'" target="href"></fluid:insertTag>
	
	<!-- default-head-javascript -->
	<fluid:insertView id="default-head-javascript"/>
	<!-- page-head-javascript -->
	<fluid:insertTag id="page-head-javascript" name="script" attribute="type='text/javascript'" target="src"></fluid:insertTag>
	
    <style type="text/css">
	html,
	body {
	  overflow-x: hidden; Prevent scroll on narrow devices
	}
	body {
/* 	  padding-top: 45px; */
	}
	footer {
	  padding: 30px 0;
	}
    </style>
	<%--START JAVASCRIPT GLOBAL--%>
	<script type="text/javascript">
	//$(document).ready(
	EventUtil.addOnloadEventListener(function(){
		//$('#task-container').modal('show');
		window.alert 	= alertDialog;
		window.confirm 	= confirmDialog;
	});
	
	//module....
	function ajax(param, title){
		var before = param.onBeforeProcess;
		var complet = param.onComplete;
		var error = param.onError;
		if(!param.data){
			param.data = {};
		}
		//param.data["REQUEST_KEY"] = param.data["REQUEST_KEY"]?param.data["REQUEST_KEY"]:JavaScriptUtil.getUniqueKey(); //유일한 값 
		param.data["REQUEST_KEY"] = JavaScriptUtil.getUniqueKey(); //유일한 값 
		if(!title){
			title=param.data.url+" loading...";
		}
		param.onBeforeProcess = function(aData){
			if(before)
				before(aData);
			addTask("fa-spinner fa-pulse",title,aData.data.REQUEST_KEY);
		}
		param.onError = function(data,readyState,status){
			if(error)
				error(data,readyState,status);
			alert("Server Communication ERROR("+status+")");
		}
		param.onComplete = function(aData){
			if(complet)
				complet(aData);
			removeTask(aData.data.REQUEST_KEY);
		}
		var ajax = new AjaxK(param);
	}
	function loadPage(url_oparam,successcallback,param){
		var aParam ={};
		if(JavaScriptUtil.isString(url_oparam)){
			aParam['url'] = url_oparam;
			aParam['type'] = 'POST';
			aParam['dataType'] = 'TEXT';
			aParam['onSuccess'] = successcallback;
		}else if(JavaScriptUtil.isObject(url_oparam)){
			aParam = url_oparam;
			aParam['dataType'] = aParam['dataType']?aParam['dataType']:'TEXT';
			aParam['onSuccess'] = aParam['onSuccess']?aParam['onSuccess']:successcallback;
		}
		ajax(aParam,"loadPage");
	}
	//module end...
	
	
	
	
	//dialog....
	function confirmDialog(msg, okCallBack, noCallBack, cancleCallBack){
		$("#confirm-container").unbind();
		$("#confirm-ok-btn").unbind();
		$("#confirm-no-btn").unbind();
		$("#confirm-cancle-btn").unbind();
		
		$("#confirm-container").click(function(event){	try{cancleCallBack(event);}catch (error){}	event.stopPropagation();	$('#confirm-container').modal('hide'); return false;});
		$("#confirm-ok-btn").click(function(event){		try{okCallBack(event);}catch (error){}		event.stopPropagation();	$('#confirm-container').modal('hide'); return true;});
		$("#confirm-no-btn").click(function(event){		try{noCallBack(event);}catch (error){}		event.stopPropagation();	$('#confirm-container').modal('hide'); return false;});
		$("#confirm-cancle-btn").click(function(event){	try{cancleCallBack(event);}catch (error){}	event.stopPropagation();	$('#confirm-container').modal('hide'); return false;});
		
		$('#confirm-info-container').html(msg);
		$('#confirm-container').modal('show');
	}
	
	function alertDialog(msg, okCallBack, cancleCallBack){
		$("#alert-container").unbind();
		$("#alert-ok-btn").unbind();
		$("#alert-cancle-btn").unbind();
		
		$("#alert-container").click(function(event){	try{cancleCallBack(event);}catch (error){}	event.stopPropagation();	$('#alert-container').modal('hide'); return false;});
		$("#alert-ok-btn").click(function(event){		try{okCallBack(event);}catch (error){}		event.stopPropagation();	$('#alert-container').modal('hide'); return true;});
		$("#alert-cancle-btn").click(function(event){	try{cancleCallBack(event);}catch (error){}	event.stopPropagation();	$('#alert-container').modal('hide'); return false;});
		
		$('#alert-info-container').html(msg);
		$('#alert-container').modal('show');
	}
	function addTask(type, msg, key){
		/*
		 type 은 fortawesome의 아이콘 이름을 넣는다 예로..fa-spinner 등
		 http://fortawesome.github.io/Font-Awesome/icon/spinner/
		 key는 유일한 키값을..
		 */
// 		 $('#task-list-container').append( "<h4><span class='fa fa-tasks' aria-hidden='true'></span> "+msg+"</h4>" );
		
		 $('#task-list-container').append( "<h4 id='"+key+"'><span class='fa "+type+"' aria-hidden='true'></span> "+msg+"</h4>" );
		 $('#task-container').modal('show');
	}
	function removeTask(key){
		$("#"+key).remove();
		var count = $("task-list-container").children().length;
		if(count<=0){
			$('#task-container').modal('hide');
		}
	}
	//dialog end......
	</script>
	<%--END JAVASCRIPT--%>
  </head>

<!-- hiden container -->
	<div id="task-container" class="modal fade bs-example-modal-lg" style="padding-right: 0px;background-color: rgba(4, 4, 4, 0.8); " tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
	  <div class="modal-dialog modal-lg" style="width: 100%;position: absolute;">
	    <div class="modal-content" style="border-radius: 0px;border: none;top: 40%;">
		    <div class="modal-header" style="background-color: #0f7755;color: white;">
		        <button type="button" class="close" data-dismiss="modal" aria-label="Close" style="color:white"><span aria-hidden="true">×</span></button>
		       <H2><span class="fa fa-tasks" aria-hidden="true"></span> Task List!</H2>
	      	</div>
	      <div id="task-list-container" class="modal-body" style="background-color: #0f9966;color: white;">
<!-- 	      <H2><span class="fa fa-tasks" aria-hidden="true"></span> Task List!</H2> -->
	<!-- 	      <h4>Your Laptop battery is less then 10%.Recharge the battery.</h4> -->
	<!-- 	      <h4>Your Laptop battery is less then 10%.Recharge the battery.</h4> -->
	      </div>
	    </div>
	  </div>
	</div>
	
		<div id="alert-container" class="modal fade bs-example-modal-md" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel">
		  <div class="modal-dialog modal-sm">
		    <div id="task-info-container" class="modal-content">
				<div class="modal-header">
					<button id="alert-cancle-btn" type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
					<h4 class="modal-title" ><span class="fa fa-info" aria-hidden="true"></span> <span id="alert-title-container">Alert</span></h4>
				</div>
				<div id="alert-info-container" class="modal-body" >
				....
				</div>
				<div class="modal-footer">
				  <button id="alert-ok-btn" type="button" class="btn btn-default" data-dismiss="modal">Ok</button>
				</div>
		    </div>
		  </div>
		</div>
		
		<div id="confirm-container" class="modal fade bs-example-modal-sm" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel">
		  <div class="modal-dialog modal-sm">
		    <div id="task-info-container" class="modal-content">
				<div class="modal-header">
					<button id="confirm-cancle-btn"  type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
					<h4 class="modal-title" ><span class="fa fa-question" aria-hidden="true"></span> <span id="confirm-title-container">Confirmt</span></h4>
				</div>
				<div id="confirm-info-container" class="modal-body" >
				.....
				</div>
				<div class="modal-footer">
				  <button id="confirm-ok-btn" type="button" class="btn btn-default" data-dismiss="modal">Ok</button>
				  <button id="confirm-no-btn" type="button" class="btn btn-default">No</button>
				</div>
		    </div>
		  </div>
		</div>
<!-- hiden container end -->	
		
  <!-- page-body -->
  <%--<body>--%>
	<fluid:insertView id="page-body" exception="true"/>
  <%--</body>--%>
  <!-- default-footer-javascript -->
  <fluid:insertView id="default-footer-javascript"/>
  <!-- page-footer-javascript -->
  <fluid:insertTag id="page-footer-javascript" name="script" attribute="type='text/javascript'" target="src"></fluid:insertTag>
  
</html>