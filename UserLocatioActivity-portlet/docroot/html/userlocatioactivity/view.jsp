<%@page import="com.liferay.portal.model.User"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@page import="java.util.List"%>
<%@page import="com.liferay.portal.service.UserGroupRoleLocalServiceUtil"%>
<%@page import="com.liferay.portal.model.UserGroupRole"%>
<%@page import="com.liferay.portal.service.UserLocalServiceUtil"%>
<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>
<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui"%>
<%@ taglib uri="http://liferay.com/tld/portlet" prefix="liferay-portlet" %>
<%@ taglib uri="http://liferay.com/tld/theme" prefix="liferay-theme" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>
<%@ taglib uri="http://liferay.com/tld/util" prefix="liferay-util" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
<script src="http://js.arcgis.com/3.12/"></script>
<!--Load the AJAX API-->
<script type="text/javascript" src="https://www.google.com/jsapi"></script>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

  <link rel="stylesheet" href="http://js.arcgis.com/3.11/esri/css/esri.css">
  <link rel="stylesheet" href="http://js.arcgis.com/3.11/dijit/themes/claro/claro.css"> 

<portlet:defineObjects />
<liferay-theme:defineObjects/>
<%@page import="com.es.uji.init.portlets.UserLocatioActivityPortlet"%>

<%String userRole=UserLocatioActivityPortlet.retrieveCurrentUserRole(user);
String organRole=UserLocatioActivityPortlet.retrieveCurrentUserOrganisationRole(user);
List<UserGroupRole> userGroups = UserGroupRoleLocalServiceUtil.getUserGroupRolesByGroup(11782);
List<UserGroupRole> ujiAcademic =new ArrayList<UserGroupRole>();
List<UserGroupRole> ujiMaintenance=new ArrayList<UserGroupRole>();
List<Long> academicUsers = new ArrayList<Long>();
List<Long> maintenanceUsers = new ArrayList<Long>();
List<Long> visitorUsers = new ArrayList<Long>();
//List<UserGroupRole> ujiVisitor;
for(UserGroupRole ujiRole: userGroups){
	
	if(ujiRole.getRole().getName().equalsIgnoreCase("UJIAcademic")){
		ujiAcademic.add(ujiRole);
		academicUsers.add(ujiRole.getUser().getUserId());
		
	}else if(ujiRole.getRole().getName().equalsIgnoreCase("UJIMaintenance")){
		ujiMaintenance.add(ujiRole);
		maintenanceUsers.add(ujiRole.getUser().getUserId());
	}else if(ujiRole.getRole().getName().equalsIgnoreCase("UJIVisitor")){
		visitorUsers.add(ujiRole.getUser().getUserId());
	}
}
//System.out.println("size"+ujiAcademic.size());
//System.out.println(ujiMaintenance.size());
pageContext.setAttribute("userRole", userRole);
pageContext.setAttribute("organRole", organRole);
pageContext.setAttribute("userID",user.getUserId());
pageContext.setAttribute("timeStamp",UserLocatioActivityPortlet.getCurrentTime());
pageContext.setAttribute("usersList",UserGroupRoleLocalServiceUtil.getUserGroupRolesByGroup(11782) );
pageContext.setAttribute("usersAcademicList",ujiAcademic);
pageContext.setAttribute("usersMaintenanceList",ujiMaintenance);
pageContext.setAttribute("userIdsAcademic",academicUsers);
pageContext.setAttribute("userIdsMaintenance",maintenanceUsers);
pageContext.setAttribute("userIdsVisitor",visitorUsers);


%>
<portlet:actionURL var="changeUserRoleByLocation" name="changeUserRoleByLocation"></portlet:actionURL>
<portlet:actionURL var="retrieveCurrentUserOrganisationRole" name="retrieveCurrentUserOrganisationRole"></portlet:actionURL>

<script type="text/JavaScript">

google.load('visualization', '1.0', {'packages':['corechart']});

   var configOptions;
  
  var map2;
  var userIdSelect = "";
  var features = [];
  var featuresAnalytics = [];
  var allfeaturesAnalytics = [];
  var adminfeaturesAnalytics = [];
  var buildingChoices=[];
  var buildingChoices1=[];
  var allBuildings=[];
  var anChoice;
  var anChoice2;
  var featuresJA = [];
  var featuresTD = [];
  var featuresCD = [];
  var featuresGG = [];
  var featuresDB = [];
  var featuresUB = [];
  var featuresJAID = [];
  var featuresTDID = [];
  var featuresCDID = [];
  var featuresGGID = [];
  var featuresDBID = [];
  var featuresUBID = [];
  var adminfeaturesJA = [];
  var adminfeaturesTD = [];
  var adminfeaturesCD = [];
  var adminfeaturesGG = [];
  var adminfeaturesDB = [];
  var adminfeaturesUB = [];
  var adminfeaturesDatesJA = [];
  var adminfeaturesDatesTD = [];
  var adminfeaturesDatesCD = [];
  var adminfeaturesDatesGG = [];
  var adminfeaturesDatesDB = [];
  var adminfeaturesDatesUB = [];
  var numVisits;
  var numAdminVisits;
  var numUserAdminVisits;
  var simpleDatepicker1;
  var startAdminDate;
  var endAdminDate;
  var startAdminDateTimeStamp;
  var endAdminDateTimeStamp;
  var startUserDate;
  var endUserDate;
  var startUserDateTimeStamp;
  var endUserDateTimeStamp;
  var userChartStats;
  var data;
  var graphBuildings;
  var academicUsers=[];
  var maintenanceUsers=[];
  var visitorUsers=[];
  
  
  function pointsbased(){
		map2.graphics.clear();
		$("#pointAnalysis").show();
		$("#PointsBased").hide();
		$("#BuildingsBased").show();
		$("#builingAnalysis").hide();
		$("#ShowCharts").show();
		$("#generateCharts").hide();
		//$("<portlet:namespace/>").show();
	}
 
	function buildingsbased(){
		map2.graphics.clear();
		$("#builingAnalysis").show();
		$("#PointsBased").show();
		$("#BuildingsBased").hide();
		$("#pointAnalysis").hide();
		$("#ShowCharts").show();
		$("#generateCharts").hide();
		//$("<portlet:namespace/>").show();
	}
	
	  
  function init() {
	  
    	
	//  try{
		  
	esriConfig.defaults.io.corsEnabledServers.push("http://uji.maps.arcgis.com");

    	startExtent = new esri.geometry.Extent(-8276.09427045286, 4864578.77192488, -7062.62433847412, 4865538.06421562,
    	       	new esri.SpatialReference({wkid:3857}) );
      map2 = new esri.Map("<portlet:namespace/>",{extent:startExtent});
     // map2.addLayer(new esri.layers.ArcGISDynamicMapServiceLayer("http://smartcampus.sg.uji.es:6080/arcgis/rest/services/SmartCampus/BuildingsNew/MapServer"));
     map2.addLayer(new esri.layers.ArcGISTiledMapServiceLayer("http://services.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer"));
         
     var queryTask = new esri.tasks.QueryTask("http://services1.arcgis.com/k8WRSCmxGgCwZufI/ArcGIS/rest/services/UserLocationTracking/FeatureServer/0");  
     
   	//build query filter  
   	var query = new esri.tasks.Query();  
   	query.returnGeometry = true;  
  	 //query.where = "UserID="+$('#userID').val(); 
  	  query.where = "1=1";
  	 query.outFields=["UserID","UserOrganisationRole","TimeStamp","UserRole"];
  	 dojo.connect(queryTask, "onComplete", function(featureSet) {  
  	 //try{  
      	//QueryTask returns a featureSet.  Loop through features in the featureSet and add them to the map.  
      	dojo.forEach(featureSet.features,function(feature){
      		adminfeaturesAnalytics.push(feature); 
      		if(feature.attributes.UserRole=="JA"){
      			adminfeaturesJA.push(feature);
      		}else if(feature.attributes.UserRole=="TD"){
      			adminfeaturesTD.push(feature);
      		}else if(feature.attributes.UserRole=="UB"){
      			adminfeaturesUB.push(feature);
      		}else if(feature.attributes.UserRole=="CD"){
      			adminfeaturesCD.push(feature);
      		}else if(feature.attributes.UserRole=="DB"){
      			adminfeaturesDB.push(feature);
      		}else if(feature.attributes.UserRole=="GG"){
      			adminfeaturesGG.push(feature);
      		}
      		if(feature.attributes.UserID==$("#userID").val()){
      		allfeaturesAnalytics.push(feature); 
      		if(feature.attributes.UserRole=="JA"){
      			featuresJA.push(feature);
      		}else if(feature.attributes.UserRole=="TD"){
      			featuresTD.push(feature);
      		}else if(feature.attributes.UserRole=="UB"){
      			featuresUB.push(feature);
      		}else if(feature.attributes.UserRole=="CD"){
      			featuresCD.push(feature);
      		}else if(feature.attributes.UserRole=="DB"){
      			featuresDB.push(feature);
      		}else if(feature.attributes.UserRole=="GG"){
      			featuresGG.push(feature);
      		}
      		}
     		});
   });
  	typeOfUsers();
  	var queryTask1 = new esri.tasks.QueryTask("http://smartcampus.sg.uji.es:6080/arcgis/rest/services/SmartCampus/BuildingsNew/MapServer/0");  
    
   	//build query filter  
   	var query1 = new esri.tasks.Query();  
   	query1.returnGeometry = true;  
  	 //query.where = "UserID="+$('#userID').val(); 
  	  query1.where = "1=1";
  	query1.outFields = ["BUILDINGID"];
  	dojo.connect(queryTask1, "onComplete", function(featureSet) {  
  	  	 //try{  
  	      	//QueryTask returns a featureSet.  Loop through features in the featureSet and add them to the map.  
  	      	dojo.forEach(featureSet.features,function(feature){  
  	      		allBuildings.push(feature);  
  	     		});
  	   });
  queryTask.execute(query);
  queryTask1.execute(query1);
  if($("#userRole").val()=="Administrator"){
	  $("#AdminUser").show();
	  $("#normalUser").hide();
  }else{
	  $("#AdminUser").hide();
	  $("#normalUser").show();
  }
  
 var academicUsers1=$.makeArray($("#academicUsers").val());
 var maintenanceUsers1=$.makeArray($("#maintenanceUsers").val());
 var visitorUsers1=$.makeArray($("#visitorUsers").val());
 var ad1=academicUsers1[0];
 var ad2=ad1.slice(1,-1);
 academicUsers=ad2.split(',').map(Number);
 var ad3=maintenanceUsers1[0];
 var ad4=ad3.slice(1,-1);
 maintenanceUsers=ad4.split(',').map(Number);
 var ad5=visitorUsers1[0];
 var ad6=ad5.slice(1,-1);
 visitorUsers=ad6.split(',').map(Number);
  
  $(window).resize(function(){
	 // alert('resize');
		createLineChart();
	});
	
  /*AUI().use('aui-datepicker', function(A) {
	  simpleDatepicker1 = new A.DatePicker({
	  trigger: '#<portlet:namespace />startDate' }).render('#<portlet:namespace />startDatePicker');});
  
	  } catch(e){  
        console.log(" exception occured"+e);  
    } */
    
 }    

  function showAggregatedBuildingsData(){
		map2.graphics.clear();
		if(document.getElementById("<portlet:namespace />includeUserDateCheckbox").checked){
			var globalhour2=parseInt(jQuery('#<portlet:namespace />hour3').val());
			
		if(jQuery('#<portlet:namespace />type3').val()==1){
			globalhour2=globalhour2+12;
		}
		
			startUserDate=new Date(jQuery('#<portlet:namespace />y3').val(),jQuery('#<portlet:namespace />m3').val(),jQuery('#<portlet:namespace />d3').val(),globalhour2,jQuery('#<portlet:namespace />minute3').val());
			startUserDateTimeStamp=Date.parse(startUserDate);
			
			var globalhour3=parseInt(jQuery('#<portlet:namespace />hour2').val());
			
		if(jQuery('#<portlet:namespace />type4').val()==1){
			globalhour3=globalhour3+12;
		}
		
			endUserDate=new Date(jQuery('#<portlet:namespace />y4').val(),jQuery('#<portlet:namespace />m4').val(),jQuery('#<portlet:namespace />d4').val(),globalhour3,jQuery('#<portlet:namespace />minute4').val());
			endUserDateTimeStamp=Date.parse(endUserDate);
			
		}
		
		//document.getElementById("p5").innerHTML = "Your Choices are: ";
		if(document.getElementById("<portlet:namespace />JACheckbox").checked){
			buildingChoices.push("JA");
			//document.getElementById("<portlet:namespace />JACheckbox").checked=false;
			//document.getElementById("p5").innerHTML = "JA";
		}
		if(document.getElementById("<portlet:namespace />UBCheckbox").checked){
			buildingChoices.push("UB");
			//document.getElementById("<portlet:namespace />UBCheckbox").checked=false;
			//document.getElementById("p5").innerHTML = "UB";
		}
		if(document.getElementById("<portlet:namespace />TDCheckbox").checked){
			buildingChoices.push("TD");
			//document.getElementById("<portlet:namespace />TDCheckbox").checked==false;
			//document.getElementById("p5").innerHTML = "TD";
		}
		if(document.getElementById("<portlet:namespace />CDCheckbox").checked){
			buildingChoices.push("CD");
			//document.getElementById("<portlet:namespace />CDCheckbox").checked=false;
			//document.getElementById("p5").innerHTML = "CD";
		}
		if(document.getElementById("<portlet:namespace />DBCheckbox").checked){
			buildingChoices.push("DB");
			//document.getElementById("<portlet:namespace />DBCheckbox").checked=false;
			//document.getElementById("p5").innerHTML = "DB";
		}
		if(document.getElementById("<portlet:namespace />GGCheckbox").checked){
			buildingChoices.push("GG");
			//document.getElementById("<portlet:namespace />GGCheckbox").checked=false;
			//document.getElementById("p5").innerHTML = "GG";
		}
		$("#trackPathText").hide();
		$("#trackPath").hide();
		
		if(!document.getElementById("<portlet:namespace />includeUserDateCheckbox").checked){
			if(anChoice == "points"){
				displayMapBuildings(buildingChoices);
				}else if(anChoice=="buildings"){
					showPolygonsOnMap(buildingChoices);
				}
			}else{
				if(anChoice == "points"){
					displayMapBuildingsDates(buildingChoices);
				}else if(anChoice=="buildings"){
					showPolygonsOnMapDates(buildingChoices);
			}
			}
		
		buildingChoices=[];
		
	}
  
  function adminShowAggregatedBuildingsData(){
		map2.graphics.clear();
		
		if(document.getElementById("<portlet:namespace />includeDateCheckbox").checked){
			var globalhour=parseInt(jQuery('#<portlet:namespace />hour1').val());
			
		if(jQuery('#<portlet:namespace />type1').val()==1){
			globalhour=globalhour+12;
		}
		
			startAdminDate=new Date(jQuery('#<portlet:namespace />y1').val(),jQuery('#<portlet:namespace />m1').val(),jQuery('#<portlet:namespace />d1').val(),globalhour,jQuery('#<portlet:namespace />minute1').val());
			startAdminDateTimeStamp=Date.parse(startAdminDate);
			
			var globalhour1=parseInt(jQuery('#<portlet:namespace />hour2').val());
			
		if(jQuery('#<portlet:namespace />type2').val()==1){
			globalhour1=globalhour1+12;
		}
		
			endAdminDate=new Date(jQuery('#<portlet:namespace />y2').val(),jQuery('#<portlet:namespace />m2').val(),jQuery('#<portlet:namespace />d2').val(),globalhour1,jQuery('#<portlet:namespace />minute2').val());
			endAdminDateTimeStamp=Date.parse(endAdminDate);
			
		}
		//document.getElementById("p5").innerHTML = "Your Choices are: ";
		//alert(document.getElementById("<portlet:namespace />adminJACheckbox").checked);
		if(document.getElementById("<portlet:namespace />adminJACheckbox").checked){
			buildingChoices1.push("JA");
			//document.getElementById("<portlet:namespace />JACheckbox").checked=false;
			//document.getElementById("p5").innerHTML = "JA";
		}
		if(document.getElementById("<portlet:namespace />adminUBCheckbox").checked){
			buildingChoices1.push("UB");
			//document.getElementById("<portlet:namespace />UBCheckbox").checked=false;
			//document.getElementById("p5").innerHTML = "UB";
		}
		if(document.getElementById("<portlet:namespace />adminTDCheckbox").checked){
			buildingChoices1.push("TD");
			//document.getElementById("<portlet:namespace />TDCheckbox").checked==false;
			//document.getElementById("p5").innerHTML = "TD";
		}
		if(document.getElementById("<portlet:namespace />adminCDCheckbox").checked){
			buildingChoices1.push("CD");
			//document.getElementById("<portlet:namespace />CDCheckbox").checked=false;
			//document.getElementById("p5").innerHTML = "CD";
		}
		if(document.getElementById("<portlet:namespace />adminDBCheckbox").checked){
			buildingChoices1.push("DB");
			//document.getElementById("<portlet:namespace />DBCheckbox").checked=false;
			//document.getElementById("p5").innerHTML = "DB";
		}
		if(document.getElementById("<portlet:namespace />adminGGCheckbox").checked){
			buildingChoices1.push("GG");
			//document.getElementById("<portlet:namespace />GGCheckbox").checked=false;
			//document.getElementById("p5").innerHTML = "GG";
		}
		$("#trackPathText").hide();
		$("#trackPath").hide();
		
		
	
		//alert(buildingChoices1.length);
		//alert(document.getElementById("<portlet:namespace />groupSelect1"));
		//alert($("#points"));
		//alert(anChoice);
		if(!document.getElementById("<portlet:namespace />includeDateCheckbox").checked){
		if(anChoice2 == "points"){
		displayadminMapBuildings(buildingChoices1);
		}else if(anChoice2=="buildings"){
			showadminPolygonsOnMap(buildingChoices1);
		}
		}else{
			if(anChoice2 == "points"){
				displayadminMapBuildingsDates(buildingChoices1);
				}else if(anChoice2=="buildings"){
					showadminPolygonsOnMapDates(buildingChoices1);
				}
		}
		buildingChoices1=[];
		
	}
  
  function setincludeDates(){
		 if(document.getElementById("<portlet:namespace />includeDateCheckbox").checked){
			 $("#includeDates").show();
		 }else{
			 $("#includeDates").hide();
			 startAdminDateTimeStamp=0;
			 endAdminDateTimeStamp=0;
		 }
	 }

  function setincludeDatesUser(){
		 if(document.getElementById("<portlet:namespace />includeUserDateCheckbox").checked){
			 $("#includeUserDates").show();
		 }else{
			 $("#includeUserDates").hide();
			 startUserDateTimeStamp=0;
			 endUserDateTimeStamp=0;
		 }
	 }
  
  function graphDatesUser(){
		 if(document.getElementById("<portlet:namespace />graphUserDateCheckbox").checked){
			 $("#graphUserDates").show();
		 }else{
			 $("#graphUserDates").hide();
			 startUserDateTimeStamp=0;
			 endUserDateTimeStamp=0;
		 }
	 }

  
  function setUserIdAnalysisAcademic(){
		
		var userSelected = document.getElementById("<portlet:namespace />userAcademicIdRb").value;
		//alert(userSelected);
			userIdSelect = userSelected;
		
		
	}
	
	function setUserIdAnalysisMaintenance(){
		
		var userSelected1 = document.getElementById("<portlet:namespace />userMaintenanceIdRb").value;
		//alert(userSelected1);
			userIdSelect = userSelected1;
		
		
	}
	
	function typeOfUsers(){
		var roleSelect = document.getElementById("<portlet:namespace />userRoleRb").value;
		//alert(roleSelect);
		//if (roleSelect.length > 0) {
			
			if(roleSelect=="UJIAcademic"){
				//alert(roleSelect.val());
				$("#ujiAcademicUserList").show();
				setUserIdAnalysisAcademic();
				$("#ujiMaintenanceUserList").hide();
			}else if(roleSelect=="UJIMaintenance"){
				$("#ujiMaintenanceUserList").show();
				setUserIdAnalysisMaintenance();
				$("#ujiAcademicUserList").hide();
			}else if(roleSelect=="UJIVisitor"){
				userIdSelect="AllVisitor";
				$("#ujiAcademicUserList").hide();
				$("#ujiMaintenanceUserList").hide();
			}else{
				userIdSelect="All";
				$("#ujiAcademicUserList").hide();
				$("#ujiMaintenanceUserList").hide();
			}
		//}
	}
	
	function graphCheckDates(){
		if(document.getElementById("<portlet:namespace />graphUserDateCheckbox").checked){
			var globalhour4=parseInt(jQuery('#<portlet:namespace />hour5').val());
			
		if(jQuery('#<portlet:namespace />type5').val()==1){
			globalhour4=globalhour4+12;
		}
		
			startUserDate=new Date(jQuery('#<portlet:namespace />y5').val(),jQuery('#<portlet:namespace />m5').val(),jQuery('#<portlet:namespace />d5').val(),globalhour4,jQuery('#<portlet:namespace />minute5').val());
			startUserDateTimeStamp=Date.parse(startUserDate);
			
			var globalhour5=parseInt(jQuery('#<portlet:namespace />hour6').val());
			
		if(jQuery('#<portlet:namespace />type6').val()==1){
			globalhour5=globalhour5+12;
		}
		
			endUserDate=new Date(jQuery('#<portlet:namespace />y6').val(),jQuery('#<portlet:namespace />m6').val(),jQuery('#<portlet:namespace />d6').val(),globalhour5,jQuery('#<portlet:namespace />minute6').val());
			endUserDateTimeStamp=Date.parse(endUserDate);
			
		}
	}
	
	function graphAdminCheckDates(){
		if(document.getElementById("<portlet:namespace />includeDateCheckbox").checked){
			var globalhour=parseInt(jQuery('#<portlet:namespace />hour1').val());
			
		if(jQuery('#<portlet:namespace />type1').val()==1){
			globalhour=globalhour+12;
		}
		
			startAdminDate=new Date(jQuery('#<portlet:namespace />y1').val(),jQuery('#<portlet:namespace />m1').val(),jQuery('#<portlet:namespace />d1').val(),globalhour,jQuery('#<portlet:namespace />minute1').val());
			startAdminDateTimeStamp=Date.parse(startAdminDate);
			
			var globalhour1=parseInt(jQuery('#<portlet:namespace />hour2').val());
			
		if(jQuery('#<portlet:namespace />type2').val()==1){
			globalhour1=globalhour1+12;
		}
		
			endAdminDate=new Date(jQuery('#<portlet:namespace />y2').val(),jQuery('#<portlet:namespace />m2').val(),jQuery('#<portlet:namespace />d2').val(),globalhour1,jQuery('#<portlet:namespace />minute2').val());
			endAdminDateTimeStamp=Date.parse(endAdminDate);
			
		}
	}

	function createPieChart() {
		graphCheckDates();
		for (i=0; i<graphBuildings.length; i++) {
			var buildingName = graphBuildings[i];
			var featureVisit;
			if(document.getElementById("<portlet:namespace />graphUserDateCheckbox").checked){
				extractUserIdStatsDates1($("#userID").val());
				numberOfVisitsByUserIDAdmin(buildingName);
				featureVisit=numUserAdminVisits;
			}else{
			numberOfVisitsByUser(buildingName);
			featureVisit=numVisits;
			}
			
			//alert(featureVisit);
			userChartStats[i] = [buildingName,featureVisit];
			}
		//alert(featuresCD.length);

	    // Create the data table.
	    data = new google.visualization.DataTable();
	    data.addColumn('string', 'BuildingID');
	    data.addColumn('number', 'Number Of Visits');
	    
	    //alert(userChartStats);
	    data.addRows(userChartStats);

	    // Instantiate and draw our chart, passing in some options.
	    var chart = new google.visualization.PieChart(document.getElementById('chart_div'));
	    chart.draw(data);
	  
	}


	function createBarChart() {
		graphCheckDates();
	
		for (i=0; i<graphBuildings.length; i++) {
			var buildingName = graphBuildings[i];
			var featureVisit;
			if(document.getElementById("<portlet:namespace />graphUserDateCheckbox").checked){
				extractUserIdStatsDates1($("#userID").val());
				numberOfVisitsByUserIDAdmin(buildingName);
				featureVisit=numUserAdminVisits;
			}else{
			numberOfVisitsByUser(buildingName);
			featureVisit=numVisits;
			}
			
			//alert(featureVisit);
			userChartStats[i] = [buildingName,featureVisit];
			}
		//alert(featuresCD.length);

	    // Create the data table.
	    data = new google.visualization.DataTable();
	    data.addColumn('string', 'BuildingID');
	    data.addColumn('number', 'Number Of Visits');
	    
	    //alert(userChartStats);
	    data.addRows(userChartStats);

	    // Instantiate and draw our chart, passing in some options.
	    var chart = new google.visualization.BarChart(document.getElementById('chart_div'));
	    chart.draw(data);
	  
	}

	function createLineChart() {
		graphCheckDates();
		var userChartStats=[];
		graphBuildings=["JA","UB","DB","CD","TD","GG"];
		for (i=0; i<graphBuildings.length; i++) {
			var buildingName = graphBuildings[i];
			var featureVisit;
			if(document.getElementById("<portlet:namespace />graphUserDateCheckbox").checked){
				extractUserIdStatsDates1($("#userID").val());
				numberOfVisitsByUserIDAdmin(buildingName);
				featureVisit=numUserAdminVisits;
			}else{
			numberOfVisitsByUser(buildingName);
			featureVisit=numVisits;
			}
			userChartStats[i] = [buildingName,featureVisit];
			}
		//alert(featuresCD.length);

	    // Create the data table.
	    data = new google.visualization.DataTable();
	    data.addColumn('string', 'BuildingID');
	    data.addColumn('number', 'Number Of Visits');
	    
	    //alert(userChartStats);
	    data.addRows(userChartStats);

			    // Instantiate and draw our chart, passing in some options.
	    var chart = new google.visualization.LineChart(document.getElementById('chart_div'));
	    chart.draw(data);
	  
	}
	
	function createColumnChart1() {
		var userChartStats2=new Array();
		var buildingName=document.getElementById("<portlet:namespace />buildSelect").value;
		var k=0;
			for (i=0; i<allfeaturesAnalytics.length; i++) {
				var feature = allfeaturesAnalytics[i];
				if(feature.attributes.UserRole==buildingName && feature.attributes.UserID==$("#userID").val()){
				var featureVisit =1;
				var featureDate = new Date(feature.attributes.TimeStamp);
				userChartStats2[k] = [new Date(featureDate.getFullYear(),featureDate.getMonth(),featureDate.getDate()),featureVisit];
				k++;
				}}
			//alert(featuresCD.length);

		    // Create the data table.
		    data = new google.visualization.DataTable();
		    data.addColumn('date', 'Date');
		    data.addColumn('number', 'Number Of Visits');
		    
		    //alert(userChartStats);
		    data.addRows(userChartStats2);
		    
		    var grouped_data = google.visualization.data.group(data, [0],[{ 'column': 1, 'aggregation':
		        google.visualization.data.sum, 'type': 'number'}]);
		    //alert(grouped_data);
		    var dataView = new google.visualization.DataView(grouped_data);
      dataView.setColumns([{calc: function(data, row) { return data.getFormattedValue(row, 0); }, type:'string'}, 1]);

		    var options={'title': 'Historical Data for Building '+buildingName, legend:'none'};

		    // Instantiate and draw our chart, passing in some options.
		    var chart = new google.visualization.ColumnChart(document.getElementById('chart_div'));
		    chart.draw(dataView,options);
		  
		}

	function createAdminColumnChart1() {
		var userChartStats5=new Array();
		var buildingName=document.getElementById("<portlet:namespace />buildSelect1").value;
		var k=0;
			for (i=0; i<adminfeaturesAnalytics.length; i++) {
				var feature = adminfeaturesAnalytics[i];
				if(feature.attributes.UserRole==buildingName){
				var featureVisit =1;
				var featureDate = new Date(feature.attributes.TimeStamp);
				userChartStats5[k] = [new Date(featureDate.getFullYear(),featureDate.getMonth(),featureDate.getDate()),featureVisit];
				k++;
				}}
			//alert(featuresCD.length);

		    // Create the data table.
		    var data1 = new google.visualization.DataTable();
		    data1.addColumn('date', 'Date');
		    data1.addColumn('number', 'Number Of Visits');
		    
		    //alert(userChartStats);
		    data1.addRows(userChartStats5);
		    
		    var grouped_data = google.visualization.data.group(data1, [0],[{ 'column': 1, 'aggregation':
		        google.visualization.data.sum, 'type': 'number'}]);
		    //alert(grouped_data);
		    var dataView = new google.visualization.DataView(grouped_data);
      dataView.setColumns([{calc: function(data, row) { return data.getFormattedValue(row, 0); }, type:'string'}, 1]);

		    var options={'title': 'Historical Data for Building '+buildingName};

		    // Instantiate and draw our chart, passing in some options.
		    var chart = new google.visualization.ColumnChart(document.getElementById('chart_div1'));
		    chart.draw(dataView,options);
		  
		}

	function createAdminColumnChart2() {
		var userChartStats4=new Array();
		var buildingName=document.getElementById("<portlet:namespace />buildSelect1").value;
		var k=0;
			for (i=0; i<adminfeaturesAnalytics.length; i++) {
				var feature = adminfeaturesAnalytics[i];
				if(feature.attributes.UserRole==buildingName && (feature.attributes.UserID!=11741 && feature.attributes.UserID!=12)){
				var featureVisit =1;
				//var featureDate = new Date(feature.attributes.TimeStamp);
				userChartStats4[k] = [feature.attributes.UserID,featureVisit];
				k++;
				}}
			//alert(featuresCD.length);

		    // Create the data table.
		   var data2 = new google.visualization.DataTable();
		    data2.addColumn('number', 'UserID');
		    data2.addColumn('number', 'Number Of Visits');
		    
		    //alert(userChartStats4.length);
		    data2.addRows(userChartStats4);
		    
		    var grouped_data = google.visualization.data.group(data2, [0],[{ 'column': 1, 'aggregation':
		        google.visualization.data.sum, 'type': 'number'}]);
		    //alert(grouped_data);
		    var dataView = new google.visualization.DataView(grouped_data);
      dataView.setColumns([{calc: function(data, row) { return data.getFormattedValue(row, 0); }, type:'string'}, 1]);

		    var options={'title': 'Different Users Visiting Building '+buildingName};

		    // Instantiate and draw our chart, passing in some options.
		    var chart = new google.visualization.ColumnChart(document.getElementById('chart_div1'));
		    chart.draw(dataView,options);
		  
		}
	
	function createAdminEnergyChart() {
		var userChartStats5=new Array();
		var buildingName=document.getElementById("<portlet:namespace />buildSelect1").value;
		var k=0;
		var energyCD;
		var energyTD;
		var energyDB;
		var energyGG;
		var energyUB;
		var energyJA;
		graphBuildings=["JA","UB","DB","CD","TD","GG"];
		var queryTask2 = new esri.tasks.QueryTask("http://smart.uji.es/adaptor/rest/services/Energy/Resources_Consumption/MapServer/1");  
	    
	   	//build query filter  
	   	var query3 = new esri.tasks.Query();  
	   	query3.returnGeometry = true;  
	  	 //query.where = "UserID="+$('#userID').val(); 
	  	  query3.where = "1=1";
	  	query3.outFields = ["*"];
	  	dojo.connect(queryTask2, "onComplete", function(featureSet) {  
	  	  	 //try{  
	  	      	//QueryTask returns a featureSet.  Loop through features in the featureSet and add them to the map.  
	  	      	dojo.forEach(featureSet.features,function(feature){  
//	  	      	energydata.push(feature);
				if(feature.attributes["GeoEnergyConsumption.DBO.ServiceAreas.BUILDINGID"]=="CD"){
					energyCD=feature.attributes["EnergyConsumption.DBO.%Datos.ENERGIA"];
				}else if(feature.attributes["GeoEnergyConsumption.DBO.ServiceAreas.BUILDINGID"]=="TD"){
					energyTD=feature.attributes["EnergyConsumption.DBO.%Datos.ENERGIA"];
				}else if(feature.attributes["GeoEnergyConsumption.DBO.ServiceAreas.BUILDINGID"]=="DB"){
					energyDB=feature.attributes["EnergyConsumption.DBO.%Datos.ENERGIA"];
				}else if(feature.attributes["GeoEnergyConsumption.DBO.ServiceAreas.BUILDINGID"]=="GG"){
					energyGG=feature.attributes["EnergyConsumption.DBO.%Datos.ENERGIA"];
				}else if(feature.attributes["GeoEnergyConsumption.DBO.ServiceAreas.BUILDINGID"]=="UB"){
					energyUB=feature.attributes["EnergyConsumption.DBO.%Datos.ENERGIA"];
				}else if(feature.attributes["GeoEnergyConsumption.DBO.ServiceAreas.BUILDINGID"]=="JA"){
					energyJA=feature.attributes["EnergyConsumption.DBO.%Datos.ENERGIA"];
				}
					 });
	  	  });
	  queryTask2.execute(query3);
		
	  for (i=0; i<graphBuildings.length; i++) {
			var buildingName = graphBuildings[i];
			var featureVisit;
			numberOfVisitsByUserAdmin(buildingName);
			featureVisit=numAdminVisits;
			
			//alert(featureVisit);
			if(buildingName=="CD"){
			userChartStats5[i] = [buildingName,energyCD,featureVisit];
			}else if(buildingName=="TD"){
			userChartStats5[i] = [buildingName,energyTD,featureVisit];
			}else if(buildingName=="DB"){
			userChartStats5[i] = [buildingName,energyDB,featureVisit];
			}else if(buildingName=="GG"){
			userChartStats5[i] = [buildingName,energyGG,featureVisit];
			}else if(buildingName=="UB"){
			userChartStats5[i] = [buildingName,energyUB,featureVisit];
			}else if(buildingName=="JA"){
			userChartStats5[i] = [buildingName,energyJA,featureVisit];
			}
	  }
			//alert(userChartStats5);

		    // Create the data table.
		   var data2 = new google.visualization.DataTable();
		   data2.addColumn('string', 'BuildingID');
		   data2.addColumn('number','Energy Consumption');
		    data2.addColumn('number', 'Number Of User Visits');
		    
		    
		    
		    //alert(userChartStats4.length);
		    data2.addRows(userChartStats5);
		    
		   
		    var options={'title': 'Energy Vs Users Visiting all Buildings '};
		    		/*,
		    
		    		 vAxis: {title: 'Number Of User Visits'},
		    	        hAxis: {title: 'Energy Consumption'},
		    	        bubble: {textStyle: {fontSize: 11}}};*/

		    // Instantiate and draw our chart, passing in some options.
		    var chart = new google.visualization.BubbleChart(document.getElementById('chart_div1'));
		    chart.draw(data2,options);
		  
		}

		

	
	function showCharts(){
		//map2.graphics.clear();
		//$("<portlet:namespace/>").hide();
		$("#builingAnalysis").hide();
		$("#PointsBased").show();
		$("#BuildingsBased").show();
		$("#pointAnalysis").hide();
		$("#generateCharts").show();
		$("#ShowCharts").hide();
		userChartStats= new Array();
		graphBuildings=["JA","UB","DB","CD","TD","GG"];
		
	}

	
	function chartsAllBuilds(){
		$("#chartsAllBuilds").show();
		$("#chartsEachBuilds").hide();
	}
	
	function chartsEachBuilds(){
		$("#chartsAllBuilds").hide();
		$("#chartsEachBuilds").show();
	}


	function createAdminPieChart() {
		graphAdminCheckDates();
		var userChartStats=[];
		var graphBuildings=[];
		if(document.getElementById("<portlet:namespace />adminJACheckbox").checked){
			graphBuildings.push("JA");
			//document.getElementById("<portlet:namespace />JACheckbox").checked=false;
			//document.getElementById("p5").innerHTML = "JA";
		}
		if(document.getElementById("<portlet:namespace />adminUBCheckbox").checked){
			graphBuildings.push("UB");
			//document.getElementById("<portlet:namespace />UBCheckbox").checked=false;
			//document.getElementById("p5").innerHTML = "UB";
		}
		if(document.getElementById("<portlet:namespace />adminTDCheckbox").checked){
			graphBuildings.push("TD");
			//document.getElementById("<portlet:namespace />TDCheckbox").checked==false;
			//document.getElementById("p5").innerHTML = "TD";
		}
		if(document.getElementById("<portlet:namespace />adminCDCheckbox").checked){
			graphBuildings.push("CD");
			//document.getElementById("<portlet:namespace />CDCheckbox").checked=false;
			//document.getElementById("p5").innerHTML = "CD";
		}
		if(document.getElementById("<portlet:namespace />adminDBCheckbox").checked){
			graphBuildings.push("DB");
			//document.getElementById("<portlet:namespace />DBCheckbox").checked=false;
			//document.getElementById("p5").innerHTML = "DB";
		}
		if(document.getElementById("<portlet:namespace />adminGGCheckbox").checked){
			graphBuildings.push("GG");
			//document.getElementById("<portlet:namespace />GGCheckbox").checked=false;
			//document.getElementById("p5").innerHTML = "GG";
		}
		for (i=0; i<graphBuildings.length; i++) {
			var buildingName = graphBuildings[i];
			var featureVisit;
			//alert(userIdSelect);
			if(document.getElementById("<portlet:namespace />includeDateCheckbox").checked){
				if(userIdSelect=="All"){
					extractUserIdStatsAdminDates();
					numberOfVisitsByUserAdminDates(buildingName);
					featureVisit=numAdminVisits;	
				}else{
					extractUserIdStatsDates1(userIdSelect);
					numberOfVisitsByUserIDAdmin(buildingName);
					featureVisit=numUserAdminVisits;
				}
				
			}else{
				if(userIdSelect=="All"){
					numberOfVisitsByUserAdmin(buildingName);
					featureVisit=numAdminVisits;
				}else{
					extractUserIdStats(userIdSelect);
					numberOfVisitsByUserIDAdmin(buildingName);
				featureVisit=numUserAdminVisits;
				}
			}
			
			
			userChartStats[i] = [buildingName,featureVisit];
			}
		//alert(featuresCD.length);

	    // Create the data table.
	    data = new google.visualization.DataTable();
	    data.addColumn('string', 'BuildingID');
	    data.addColumn('number', 'Number Of Visits');
	    
	    //alert(userChartStats);
	    data.addRows(userChartStats);
	    var options={'title': 'Pie Chart for Selected Building Visits '};
	    // Instantiate and draw our chart, passing in some options.
	    var chart = new google.visualization.PieChart(document.getElementById('chart_div1'));
	    chart.draw(data,options);
	  
	}


	function createAdminBarChart() {
		graphAdminCheckDates();
		var userChartStats=[];
		var graphBuildings=[];
		if(document.getElementById("<portlet:namespace />adminJACheckbox").checked){
			graphBuildings.push("JA");
			//document.getElementById("<portlet:namespace />JACheckbox").checked=false;
			//document.getElementById("p5").innerHTML = "JA";
		}
		if(document.getElementById("<portlet:namespace />adminUBCheckbox").checked){
			graphBuildings.push("UB");
			//document.getElementById("<portlet:namespace />UBCheckbox").checked=false;
			//document.getElementById("p5").innerHTML = "UB";
		}
		if(document.getElementById("<portlet:namespace />adminTDCheckbox").checked){
			graphBuildings.push("TD");
			//document.getElementById("<portlet:namespace />TDCheckbox").checked==false;
			//document.getElementById("p5").innerHTML = "TD";
		}
		if(document.getElementById("<portlet:namespace />adminCDCheckbox").checked){
			graphBuildings.push("CD");
			//document.getElementById("<portlet:namespace />CDCheckbox").checked=false;
			//document.getElementById("p5").innerHTML = "CD";
		}
		if(document.getElementById("<portlet:namespace />adminDBCheckbox").checked){
			graphBuildings.push("DB");
			//document.getElementById("<portlet:namespace />DBCheckbox").checked=false;
			//document.getElementById("p5").innerHTML = "DB";
		}
		if(document.getElementById("<portlet:namespace />adminGGCheckbox").checked){
			graphBuildings.push("GG");
			//document.getElementById("<portlet:namespace />GGCheckbox").checked=false;
			//document.getElementById("p5").innerHTML = "GG";
		}
		
		for (i=0; i<graphBuildings.length; i++) {
			var buildingName = graphBuildings[i];
			var featureVisit;
			if(document.getElementById("<portlet:namespace />includeDateCheckbox").checked){
				if(userIdSelect=="All"){
					extractUserIdStatsAdminDates();
					numberOfVisitsByUserAdminDates(buildingName);
					featureVisit=numAdminVisits;	
				}else{
					extractUserIdStatsDates1(userIdSelect);
					numberOfVisitsByUserIDAdmin(buildingName);
					featureVisit=numUserAdminVisits;
				}
				
			}else{
				if(userIdSelect=="All"){
					numberOfVisitsByUserAdmin(buildingName);
					featureVisit=numAdminVisits;
				}else{
					extractUserIdStats(userIdSelect);
					numberOfVisitsByUserIDAdmin(buildingName);
				featureVisit=numUserAdminVisits;
				}
			}
			
			//alert(featureVisit);
			userChartStats[i] = [buildingName,featureVisit];
			}
		//alert(featuresCD.length);

	    // Create the data table.
	    data = new google.visualization.DataTable();
	    data.addColumn('string', 'BuildingID');
	    data.addColumn('number', 'Number Of Visits');
	    
	    //alert(userChartStats);
	    data.addRows(userChartStats);
	    var options={'title': 'Bar Chart for Selected Building Visits '};
	    // Instantiate and draw our chart, passing in some options.
	    var chart = new google.visualization.BarChart(document.getElementById('chart_div1'));
	    chart.draw(data,options);
	  
	}

	function createAdminLineChart() {
		graphCheckDates();
		var userChartStats=[];
		var graphBuildings=[];
		if(document.getElementById("<portlet:namespace />adminJACheckbox").checked){
			graphBuildings.push("JA");
			//document.getElementById("<portlet:namespace />JACheckbox").checked=false;
			//document.getElementById("p5").innerHTML = "JA";
		}
		if(document.getElementById("<portlet:namespace />adminUBCheckbox").checked){
			graphBuildings.push("UB");
			//document.getElementById("<portlet:namespace />UBCheckbox").checked=false;
			//document.getElementById("p5").innerHTML = "UB";
		}
		if(document.getElementById("<portlet:namespace />adminTDCheckbox").checked){
			graphBuildings.push("TD");
			//document.getElementById("<portlet:namespace />TDCheckbox").checked==false;
			//document.getElementById("p5").innerHTML = "TD";
		}
		if(document.getElementById("<portlet:namespace />adminCDCheckbox").checked){
			graphBuildings.push("CD");
			//document.getElementById("<portlet:namespace />CDCheckbox").checked=false;
			//document.getElementById("p5").innerHTML = "CD";
		}
		if(document.getElementById("<portlet:namespace />adminDBCheckbox").checked){
			graphBuildings.push("DB");
			//document.getElementById("<portlet:namespace />DBCheckbox").checked=false;
			//document.getElementById("p5").innerHTML = "DB";
		}
		if(document.getElementById("<portlet:namespace />adminGGCheckbox").checked){
			graphBuildings.push("GG");
			//document.getElementById("<portlet:namespace />GGCheckbox").checked=false;
			//document.getElementById("p5").innerHTML = "GG";
		}
		
		for (i=0; i<graphBuildings.length; i++) {
			var buildingName = graphBuildings[i];
			var featureVisit;
			if(document.getElementById("<portlet:namespace />includeDateCheckbox").checked){
				if(userIdSelect=="All"){
					extractUserIdStatsAdminDates();
					numberOfVisitsByUserAdminDates(buildingName);
					featureVisit=numAdminVisits;	
				}else{
					extractUserIdStatsDates1(userIdSelect);
					numberOfVisitsByUserIDAdmin(buildingName);
					featureVisit=numUserAdminVisits;
				}
				
			}else{
				if(userIdSelect=="All"){
					numberOfVisitsByUserAdmin(buildingName);
					featureVisit=numAdminVisits;
				}else{
					extractUserIdStats(userIdSelect);
					numberOfVisitsByUserIDAdmin(buildingName);
				featureVisit=numUserAdminVisits;
				}
			}
						userChartStats[i] = [buildingName,featureVisit];
			}
		//alert(featuresCD.length);

	    // Create the data table.
	    data = new google.visualization.DataTable();
	    data.addColumn('string', 'BuildingID');
	    data.addColumn('number', 'Number Of Visits');
	    
	    //alert(userChartStats);
	    data.addRows(userChartStats);
	    var options={'title': 'Line  Chart for Selected Building Visits '};
			    // Instantiate and draw our chart, passing in some options.
	    var chart = new google.visualization.LineChart(document.getElementById('chart_div1'));
	    chart.draw(data,options);
	  
	}

	
  
  dojo.addOnLoad(init);
  </script>
  <div id="esrimap">
  
  <input id="usrOrgRole" value="${organRole}" type="hidden"/>
  <input id="userRole" value="${userRole}" type="hidden"/>
  <input id="userID" value="${userID}" type="hidden"/>
  <input id="timestamp" value="${timeStamp}" type="hidden"/>
  <input id="userList" value="${usersList}" type="hidden"/>
  <input id="userAcademicList" value="${usersAcademicList}" type="hidden"/>
  <input id="userMaintenanceList" value="${usersMaintenanceList}" type="hidden"/>
  <input id="academicUsers" value="${userIdsAcademic}" type="hidden"/>
  <input id="maintenanceUsers" value="${userIdsMaintenance}" type="hidden"/>
  <input id="visitorUsers" value="${userIdsVisitor}" type="hidden"/>
  <div id="<portlet:namespace/>" dojotype="dijit.layout.ContentPane" class="tundra" style="width:100%; height:0.72 * width; border:1px solid #000;"></div>
  <div id="myTableNode"></div></div>
  <div id="normalUser" style="display:none">
  <aui:fieldset label="Location Analytics User Tool">
  <aui:nav-bar>
  <aui:button type="button" id="BuildingsBased" value="GoTo Location Analytics Tool" onclick="buildingsbased()"></aui:button>
  <aui:button type="button" id="PointsBased" value="GoTo Track All Locations" onclick="pointsbased()"></aui:button>
  <aui:button type="button" id="ShowCharts" value="GoTo Generate Charts" onclick="showCharts()"></aui:button>
  </aui:nav-bar>
  </aui:fieldset>
  <aui:fieldset>
  <aui:layout>
  <aui:column>
  <div id="builingAnalysis" style="display:none">
  <aui:fieldset label="User Location Analytics">
  <aui:layout>
  <aui:column>
  <aui:row>Select Buildings</aui:row>
  <aui:input name="JA" label="JA" type="checkbox"></aui:input>
  <aui:input name="UB" label="UB" type="checkbox"></aui:input>
  <aui:input name="CD" label="CD" type="checkbox"></aui:input>
  <aui:input name="DB" label="DB" type="checkbox"></aui:input>
  <aui:input name="TD" label="TD" type="checkbox"></aui:input>
  <aui:input name="GG" label="GG" type="checkbox"></aui:input>
  </aui:column>
  <aui:column>
  <aui:row>Visualization</aui:row>
  <aui:input name="groupSelect" label="Points" type="radio" value="points" onClick="setPoints()"></aui:input>
  <aui:input name="groupSelect" label="Polygons" type="radio" value="buildings" onClick="setBuildings()"></aui:input>
  </aui:column>
  <aui:column>
  <aui:input name="includeUserDate" label="Include Dates" type="checkbox" onClick="setincludeDatesUser()"></aui:input>
  <div id="includeUserDates" style="display:none">
  <aui:row>Select Dates</aui:row>
  <aui:row>Start Date</aui:row>
  <liferay-ui:input-date name="userStartdate" yearValue="2015" monthValue="" dayValue="01"
          dayParam="d3" monthParam="m3" yearParam="y3"/>
          <liferay-ui:input-time name="StartDateTime" minuteParam="minute3" amPmParam="type3" hourParam="hour3"></liferay-ui:input-time>
        <br />
        <aui:row>End Date</aui:row>
  <liferay-ui:input-date name="userEnddate" yearValue="2015" monthValue="" dayValue="22"
          dayParam="d4" monthParam="m4" yearParam="y4"/>
          <liferay-ui:input-time name="EndDateTime" hourValue="0" minuteValue="0" minuteParam="minute4" amPmParam="type4" hourParam="hour4"></liferay-ui:input-time>
        </div>
  </aui:column>
  <aui:button-row>
  <aui:button type="button" value="Show On Map" onClick="showAggregatedBuildingsData();"/>
  </aui:button-row>
  </aui:layout>
  </aui:fieldset> 
  </div> 
  
  </aui:column>
  <aui:column>
  <div id="pointAnalysis" style="display:none">
  <aui:row>Track Your movement around Campus</aui:row>
  <h6>Show all the places visited in the campus on Map</h6><aui:button name="ShowPoints" value="ShowPoints" onClick="showAllPointsOnMap();"></aui:button>
  <h6 id="trackPathText" style="display:none">Track the places visited in the campus on Map according to time visited</h6><aui:button id="trackPath" style="display:none" value="TrackPath" onClick="trackPathPoints();"></aui:button>
  </div>
 
  </aui:column>
  
  </aui:layout>
  </aui:fieldset>
  <div id="generateCharts" style="display:none">
  <aui:fieldset>
  <aui:layout>
  <aui:nav-bar>
  <aui:button type="button" value="All Buildings Stats" onclick="chartsAllBuilds()"></aui:button>
  <aui:button type="button" value="Individual Building Stats" onclick="chartsEachBuilds()"></aui:button>
  </aui:nav-bar>
  <div id="chartsAllBuilds" style="display:none">
   <aui:column>
  <aui:button type="button" name="chartsCreate" value="Create Pie Chart" onClick="createPieChart();"></aui:button>
  <aui:button type="button" name="chartsCreate" value="Create Line Chart" onClick="createLineChart();"></aui:button>
  <aui:button type="button" name="chartsCreate" value="Create Bar Chart" onClick="createBarChart();"></aui:button>
  </aui:column>
  <aui:column>
  <aui:input name="graphUserDate" label="Include Dates" type="checkbox" onClick="graphDatesUser()"></aui:input>
  <div id="graphUserDates" style="display:none">
  <aui:row>Select Dates</aui:row>
  <aui:row>Start Date</aui:row>
  <liferay-ui:input-date name="userStartdate" yearValue="2015" monthValue="" dayValue="01"
          dayParam="d5" monthParam="m5" yearParam="y5"/>
          <liferay-ui:input-time name="StartDateTime" minuteParam="minute5" amPmParam="type5" hourParam="hour5"></liferay-ui:input-time>
        <br />
        <aui:row>End Date</aui:row>
  <liferay-ui:input-date name="userEnddate" yearValue="2015" monthValue="" dayValue="22"
          dayParam="d6" monthParam="m6" yearParam="y6"/>
          <liferay-ui:input-time name="EndDateTime" hourValue="0" minuteValue="0" minuteParam="minute6" amPmParam="type6" hourParam="hour6"></liferay-ui:input-time>
        </div>
  </aui:column>
  </div>
  <div id="chartsEachBuilds" style="display:none">
  <aui:column>
  <aui:select name="buildSelect" label="Select Building">
  	<aui:option value="JA" selected="true">JA</aui:option>
  	<aui:option value="DB">DB</aui:option>
  	<aui:option value="UB">UB</aui:option>
  	<aui:option value="CD">CD</aui:option>
  	<aui:option value="TD">TD</aui:option>
  	<aui:option value="GG">GG</aui:option>
  </aui:select>
  <aui:button type="button" name="chartsCreate" value="Create Column Chart" onClick="createColumnChart1();"></aui:button>
  </aui:column></div>
  
  </aui:layout>
  </aui:fieldset>
  <aui:fieldset label="Chart">
  <aui:layout>
  <aui:column>
  <div id="chart_div" style="width:100%; height:100%"></div>
  </aui:column>
  </aui:layout>
  </aui:fieldset>
  
  </div>
</div>



<div id="AdminUser" style="display:none">
<div id="IndividualBuildingsStats">
<aui:fieldset label="Location Analytics Admin Tool Menu">
  <aui:layout>
  <aui:column>
  <aui:row>Select Buildings</aui:row>
  <aui:input name="adminJA" label="JA" type="checkbox"></aui:input>
  <aui:input name="adminUB" label="UB" type="checkbox"></aui:input>
  <aui:input name="adminCD" label="CD" type="checkbox"></aui:input>
  <aui:input name="adminDB" label="DB" type="checkbox"></aui:input>
  <aui:input name="adminTD" label="TD" type="checkbox"></aui:input>
  <aui:input name="adminGG" label="GG" type="checkbox"></aui:input>
  </aui:column>
  <aui:column>
  <aui:select name="userRoleRb" label="Select User Type" onChange="typeOfUsers();">
    <aui:option value="UJIAcademic" label="UJIAcademic"></aui:option>
    <aui:option value="UJIMaintenance" label="UJIMaintenance"></aui:option>
    <aui:option value="UJIVisitor" label="UJIVisitor"></aui:option>
    <aui:option value="All" selected="true" label="All Types of users"></aui:option>
    </aui:select>
    <div id="ujiAcademicUserList" style="display:none">
    <aui:select name="userAcademicIdRb" label="Select Academic User" onChange="setUserIdAnalysisAcademic();">
    <aui:option value="AllAcademic" label="All Academic users" selected="true"></aui:option>
    <c:forEach var='user1' items="${usersAcademicList}">
    <aui:option value="${user1.userId}" label="${user1.user.firstName}"></aui:option>
    </c:forEach>
    </aui:select>
     </div>
     <div id="ujiMaintenanceUserList" style="display:none">
    <aui:select name="userMaintenanceIdRb" label="Select Maintenance User" onChange="setUserIdAnalysisMaintenance();">
    <aui:option value="AllMaintenance" label="All Maintenance users" selected="true"></aui:option>
    <c:forEach var='user1' items="${usersMaintenanceList}">
    <aui:option value="${user1.userId}" label="${user1.user.firstName}"></aui:option>
    </c:forEach>
    </aui:select>
 	</div>
 	</aui:column>
   <aui:column>
   <aui:row>Type of Visualization</aui:row>
  <aui:input name="groupSelect" label="Points" type="radio" value="points" onClick="setadminPoints()"></aui:input>
  <aui:input name="groupSelect" label="Polygons" type="radio" value="buildings" onClick="setadminBuildings()"></aui:input>
  </aui:column>
  <aui:column>
  <aui:input name="includeDate" label="Include Dates" type="checkbox" onClick="setincludeDates()"></aui:input>
  <div id="includeDates" style="display:none">
  <aui:row>Select Dates</aui:row>
  <liferay-ui:input-date name="Startdate" yearValue="2015" monthValue="" dayValue="01"
          dayParam="d1" monthParam="m1" yearParam="y1"/>
          <liferay-ui:input-time name="StartDateTime" minuteParam="minute1" amPmParam="type1" hourParam="hour1"></liferay-ui:input-time>Start Date
        <br />
  <liferay-ui:input-date name="Enddate" yearValue="2015" monthValue="" dayValue="22"
          dayParam="d2" monthParam="m2" yearParam="y2"/>
          <liferay-ui:input-time name="EndDateTime" hourValue="0" minuteValue="0" minuteParam="minute2" amPmParam="type2" hourParam="hour2"></liferay-ui:input-time>End Date
        </div>
  </aui:column>
  <aui:column>
  <aui:button type="button" value="Show Results On Map" onClick="adminShowAggregatedBuildingsData();"/><br/><br/>
  <aui:button type="button" value="Generate Heat Map of All the Visited Points" onClick="generateHeatMap();"/>
  </aui:column>
  </aui:layout>
  </aui:fieldset> 
  <aui:fieldset label="Chart">
  <aui:layout>
  <aui:column>
  <div id="chart_div1" style="width:100%; height:100%"></div>
  </aui:column>
  <aui:column>
  <aui:fieldset label="Generate Charts from the above menu Selection">
   <aui:button type="button" name="chartsCreate" value="Pie Chart" onClick="createAdminPieChart();"></aui:button>
  <aui:button type="button" name="chartsCreate" value="Line Chart" onClick="createAdminLineChart();"></aui:button>
  <aui:button type="button" name="chartsCreate" value="Bar Chart" onClick="createAdminBarChart();"></aui:button>
  </aui:fieldset>
  </aui:column>
  <aui:column>
  <aui:fieldset label="Generate Generic Chart independent of Above Menu Selection">
  <aui:select name="buildSelect1" label="Select Building For Building Specific Charts">
  	<aui:option value="JA" selected="true">JA</aui:option>
  	<aui:option value="DB">DB</aui:option>
  	<aui:option value="UB">UB</aui:option>
  	<aui:option value="CD">CD</aui:option>
  	<aui:option value="TD">TD</aui:option>
  	<aui:option value="GG">GG</aui:option>
  </aui:select>
  <aui:button type="button" name="chartsCreate" value="Column Chart with Dates" onClick="createAdminColumnChart1();"></aui:button>
  <aui:button type="button" name="chartsCreate" value="Column Chart for Users" onClick="createAdminColumnChart2();"></aui:button>
   </aui:fieldset>
  </aui:column>
  </aui:layout>
  </aui:fieldset>
  
  </div>
  
</div>
</div>
  