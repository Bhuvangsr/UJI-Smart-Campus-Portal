<%@page import="java.util.Calendar"%>
<%
/**
 * Copyright (c) 2000-2013 Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
%>

<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>
<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui"%>
<%@ taglib uri="http://liferay.com/tld/portlet" prefix="liferay-portlet" %>
<%@ taglib uri="http://liferay.com/tld/theme" prefix="liferay-theme" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>
<%@ taglib uri="http://liferay.com/tld/util" prefix="liferay-util" %>
<%@ page import = "com.liferay.portal.kernel.util.WebKeys" %>
<%@ page import = "com.liferay.portal.theme.ThemeDisplay" %>

<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
<script src="http://js.arcgis.com/3.11/"></script>
  <link rel="stylesheet" href="http://js.arcgis.com/3.11/esri/css/esri.css">
  <link rel="stylesheet" href="http://js.arcgis.com/3.11/dijit/themes/claro/claro.css"> 

<portlet:defineObjects />
<liferay-theme:defineObjects/>
<%@page import="com.es.uji.init.portlets.IdentifyRoleByLocationPortlet"%>

<%
ThemeDisplay themeDisplay1 = (ThemeDisplay)request.getAttribute(WebKeys.THEME_DISPLAY);
String pageName = themeDisplay1.getLayout().getName(themeDisplay.getLocale());
String defaultBuild=IdentifyRoleByLocationPortlet.updateUserRoleOnLoad(user);
String userRole=IdentifyRoleByLocationPortlet.retrieveCurrentUserRole(user);
String organRole=IdentifyRoleByLocationPortlet.retrieveCurrentUserOrganisationRole(user);


pageContext.setAttribute("userRole", userRole);
pageContext.setAttribute("organRole", organRole);
pageContext.setAttribute("userID",user.getUserId());
pageContext.setAttribute("timeStamp",IdentifyRoleByLocationPortlet.getCurrentTime());
pageContext.setAttribute("pageName",pageName);%>
<portlet:actionURL var="changeUserRoleByLocation" name="changeUserRoleByLocation"></portlet:actionURL>

<div id="esrimap">

 	<!-- <link rel="stylesheet" type="text/css" href="http://serverapi.arcgisonline.com/jsapi/arcgis/1.1/js/dojo/dijit/themes/tundra/tundra.css">
 	//<script type="text/javascript" src="http://serverapi.arcgisonline.com/jsapi/arcgis/?v=1.1"></script>-->
 	

  <script type="text/JavaScript">
  
  
  var pvt1;
  var buildingid;
  
  
  //testpoint=-7742.213347049719,4865053.640755982;"{"+pvt1.x+","+pvt1.y+"}"
    function locinfo(location){
    	
  	  pvt1= esri.geometry.geographicToWebMercator(new esri.geometry.Point(location.coords.longitude, location.coords.latitude));
  	  //pvt1 = new esri.geometry.Point(-7742.213347049719,4865053.640755982);
  	identifyBuilding();
    }
    
    function identifyBuilding(){
    	var retObj;
		if(pvt1.x>=-8276.09427045286 && pvt1.y>=4864578.77192488 && pvt1.x<=-7062.62433847412 && pvt1.y<=4865538.06421562){    	    	
    	$.ajax({  
    		  url: "http://smartcampus.sg.uji.es:6080/arcgis/rest/services/SmartCampus/BuildingsNew/MapServer/identify",  
    		  data: { f: "json", geometryType: "esriGeometryPoint",geometry:"{"+pvt1.x+","+pvt1.y+"}",mapExtent:"-8276.09427045286, 4864578.77192488, -7062.62433847412, 4865538.06421562", 
    			  tolerance:"10",imageDisplay:"600,550,96",returnGeometry: true },  
    		  dataType: "text",  
    		  jsonpCallback: "callback",  
    		  success: function(response) {  
    		    console.log("got response: ", response); 
    		    retObj=$.parseJSON(''+response+'');
    		    //document.getElementById("p1").innerHTML=retObj.results[0].attributes['Building Identifier'].substring(0,2);
    		    buildingid=retObj.results[0].attributes['Building Identifier'].substring(0,2);
    		    if(buildingid!=$("#userRole").val()){
    		    	$("#locationNotice").show();
    		    	document.getElementById("p2").innerHTML="<p>Would You like to change your current location specific role to your current address "+buildingid+"<p><INPUT onclick=\"changeRole()\" type=\"button\" value=\" ChangeRole \" name=\"querybtn\"/>";
    		    }
    		    saveUserLocation(buildingid);
    		  }  
    		});
    	
		}
		else{
			$("#locationNotice").show();
			document.getElementById("p1").innerHTML = "Your current location is outside the campus, The role from your last session is being used to display location specific content. For changing your building specific content use the manual option";
		}
    	}
    
    function changeRole(){
    	$.ajax({
	       	 url:'<%=changeUserRoleByLocation%>',
	       	 data:{
	       		 <portlet:namespace/>location:buildingid},
	       	success: function(data){
	       		window.location.reload();
	       	}});	
    }
    
    function saveUserLocation(buildingId1){
        
  		if(pvt1.x>=-8276.09427045286 && pvt1.y>=4864578.77192488 && pvt1.x<=-7062.62433847412 && pvt1.y<=4865538.06421562){
      	$.ajax({  
      		  url: "http://services1.arcgis.com/k8WRSCmxGgCwZufI/ArcGIS/rest/services/UserLocationTracking/FeatureServer/0/addFeatures",  
      		  data: { f: "json", features: "[{'geometry':{'x':"+pvt1.x+",'y':"+pvt1.y+"},'attributes':{'UserID':"+$('#userID').val()+",'UserOrganisationRole':'"+$('#usrOrgRole').val()+"','UserRole':'"+buildingId1+"','TimeStamp':"+$('#timestamp').val()+"}}]",rollbackOnFailure:true},  
    			  dataType: "json",  
        		    
      		  type: 'POST', 
      		  //async:false,
      		  success: function(response) {  
      		    console.log(response); 
      		  //  alert(response);
      		 // window.location.reload();
      		  } , error: function (jqXHR, textStatus, errorThrown) {  
      			  console.log('error'); //<-- the response lands here ...  
                  console.log(jqXHR); //<-- the console logs the object  
                  console.log(textStatus); //<-- the console logs 'parsererror'  
                  console.log(errorThrown); //< -- the console logs 'SyntaxError {}'
                 // window.location.reload();
              }});
      	
  		}
  		else{
  			$("#locationNotice").show();
  			document.getElementById("p1").innerHTML = "You are outside the campus. Kindly click on buildings in Manual option to change the location specific content";
  		}
      	}
      
    
    function locationError(error) {
        switch (error.code) {
          case error.PERMISSION_DENIED:
            console.log("Location not provided");
            break;
          case error.POSITION_UNAVAILABLE:
            console.log("Current location not available");
            break;
          case error.TIMEOUT:
            console.log("Timeout");
            break;
          default:
            console.log("unknown error");
            break;
        }
      }

    /*AUI().use(
    		  'aui-carousel',
    		  function(Y) {
    			  if($("#userRole").val()=="CD"||$("#userRole").val()=="DB"||$("#userRole").val()=="UB"||$("#userRole").val()=="TD"||$("#userRole").val()=="GG"||$("#userRole").val()=="JA"){
    			  var divid="#"+$("#userRole").val()+"Carousel";
    			  //alert(divid);
    			  $(divid).show();
    			  $(divid+"1").show();
    		   new Y.Carousel(
    		     {
    		    	 activeIndex:'rand',
    		       contentBox: divid,
    		       intervalTime:10
    		       //height: 330,
    		       //width: 587,
    		     }
    		   ).render();
    		  }
    		  }
    		);
    
    YUI().ready('node', function (A) {
    	// Previous
    	A.all('#CDCarousel menu li').item(1).addClass('ts_prev');
    	//alert("abs");
    	// Next
    	A.all('#CDCarousel menu li').item(6).addClass('ts_next');
    	/* 	IE 8 won't support this, you can use some plugin to use this way
    		A.all('#myCarousel menu li:last-child').addClass('ts_next'); */
    	
    	/* DOT Icons
    	 	I have followed numerial order for CLASS_NAME, 
    		because I didn't have actual content. You can use naming convention as content 
    		
    		A.all('#myCarousel menu li').item(2).addClass('web_design');
    		A.all('#myCarousel menu li').item(3).addClass('web_marketing');
    		A.all('#myCarousel menu li').item(4).addClass('ts_three');
    		A.all('#myCarousel menu li').item(5).addClass('ts_four');	
    		*/
    	/*A.all('#CDCarousel menu li').item(2).addClass('ts_one');
    	A.all('#CDCarousel menu li').item(3).addClass('ts_two');
    	A.all('#CDCarousel menu li').item(4).addClass('ts_three');
    	A.all('#CDCarousel menu li').item(5).addClass('ts_four');
    });*/
	
    function getLocation1() {  	  
  	  if($("#pageName").val()=="LandingPage"){
  		  $("#LandingPage").show();
  		  $("#notLandingPage").hide();
  	  }else{
  		  $("#LandingPage").hide();
  		  $("#notLandingPage").show();
  	  }
  	var divid="#"+$("#userRole").val()+"Carousel";
	  //alert(divid);
	  $(divid).show();
	  $(divid+"1").show();
  	   if (navigator.geolocation) {      	  
          navigator.geolocation.getCurrentPosition(locinfo, locationError);
        }
  	   
  	   if($("#usrOrgRole").val()=="UJIVisitor"){
  			  $("#CustomSmartCampus").show();
  			  $("#UJINews").show();  	
			  $("#UserLocationAnalytics").hide();
			  $("#UJIWiki").hide();
			  $("#UJIMsgBoard").hide();
			  $("#UJICafeteria").hide();
			$("#UJIBlog").hide();
			$("#UJIPolls").hide();
			$("#UJIPollsList").hide();
			  $("#UJICalendar").hide();
			$("#UJISiteDirectory").hide();
			$("#UJIGeoTechStaff").hide();
		  
  		  }else if($("#usrOrgRole").val()=="UJIAcademic"){
  			  $("#CustomSmartCampus").show();
  			  $("#UserLocationAnalytics").show();
  			if($("#userRole").val()=="CD" || $("#userRole").val()=="UB" || $("#userRole").val()=="TD"){
  			  $("#UJIWiki").show();
  		  }
  	 if($("#userRole").val()=="CD" || $("#userRole").val()=="UB" || $("#userRole").val()=="TD" || $("#userRole").val()=="JA"){
  			  $("#UJIMsgBoard").show();
    }
  			  $("#UJICafeteria").show();
  			  
  			$("#UJIBlog").show();
  			$("#UJIPolls").show();
  			$("#UJIPollsList").show();
  			  $("#UJICalendar").show();
  			$("#UJISiteDirectory").show();
  			if($("#userRole").val()=="CD"){
  			$("#UJIGeoTechStaff").show();
  			}
  			$("#UJINews").show();
  		  }else if($("#usrOrgRole").val()=="UJIMaintenance"){
  			$("#CustomSmartCampus").show();
			  $("#UserLocationAnalytics").show();
			  $("#UJIWiki").hide();
			  $("#UJIMsgBoard").hide();
			  $("#UJICafeteria").show();
			$("#UJIBlog").hide();
			$("#UJIPolls").show();
			$("#UJIPollsList").show();
			  $("#UJICalendar").show();
			$("#UJISiteDirectory").show();
			$("#UJIGeoTechStaff").hide();
			$("#UJINews").show();
		  
  		  }else if($("#userRole").val()=="Administrator"){
  			$("#CustomSmartCampus").show();
			  $("#UserLocationAnalytics").show();
			  $("#UJIWiki").show();
			  $("#UJIMsgBoard").show();
			  $("#UJICafeteria").show();
			$("#UJIBlog").show();
			$("#UJIPolls").show();
			$("#UJIPollsList").show();
			  $("#UJICalendar").show();
			$("#UJISiteDirectory").show();
			$("#UJIGeoTechStaff").show();
			$("#UJINews").show();
		  
  		  }
      } 
    window.setInterval(function(){getLocation1()}, 60000);
    
    dojo.addOnLoad(getLocation1);
  </script>
  
  <input id="usrOrgRole" value="${organRole}" type="hidden"/>
  <input id="userRole" value="${userRole}" type="hidden"/>
  <input id="userID" value="${userID}" type="hidden"/>
  <input id="timestamp" value="${timeStamp}" type="hidden"/>
  <input id="pageName" value="${pageName}" type="hidden"/>
  <div id="LandingPage"style="display:none">
  <aui:container>
   <aui:fieldset label="You are in ${userRole} Building. Your role is ${organRole} in the University Jaume I">
  <aui:layout>
  <aui:column>
  <div id="CDCarousel" style="display:none">
  <img alt="CD Building" src="<%=request.getContextPath()%>/images/CD1.jpg" style="max-width:100%;height:auto;">
</div>
<div id="UBCarousel" style="display:none">
<img alt="CD Building" src="<%=request.getContextPath()%>/images/UBSide.jpg" style="max-width:100%;height:auto;">
</div>
<div id="TDCarousel" style="display:none">
<img alt="CD Building" src="<%=request.getContextPath()%>/images/TD.jpg" style="max-width:100%;height:auto;">
</div>
<div id="DBCarousel" style="display:none">
  <img alt="CD Building" src="<%=request.getContextPath()%>/images/TD.jpg" style="max-width:100%;height:auto;">
</div>
<div id="JACarousel" style="display:none">
  <img alt="CD Building" src="<%=request.getContextPath()%>/images/TD.jpg" style="max-width:100%;height:auto;">
</div>
<div id="GGCarousel" style="display:none">
  <img alt="CD Building" src="<%=request.getContextPath()%>/images/TD.jpg" style="max-width:100%;height:auto;">
</div>
  </aui:column>
  <aui:column>
  <div id="CDCarousel1" style="display:none">
  <iframe frameborder="0" src=http://www.youtube.com/embed/JPndaRUNqrE allowfullscreen="" style="width: 100%;height:auto;"></iframe>
</div>
<div id="UBCarousel1" style="display:none">
  <iframe frameborder="0" src=http://www.youtube.com/embed/3ExPGvZS6bQ allowfullscreen="" style="width: 100%;height:auto;"></iframe>
</div>
<div id="TDCarousel1" style="display:none">
  <iframe frameborder="0" src=http://www.youtube.com/embed/BAc_VwZ1zIE allowfullscreen="" style="width: 100%;height:auto;"></iframe>
</div>
<div id="DBCarousel1" style="display:none">
  <iframe frameborder="0" src=http://www.youtube.com/embed/L72BS5rgBbk allowfullscreen="" style="width: 100%;height:auto;"></iframe>
</div>
<div id="JACarousel1" style="display:none">
  <iframe frameborder="0" src=http://www.youtube.com/embed/BAc_VwZ1zIE allowfullscreen="" style="width: 100%;height:auto;"></iframe>
</div>
<div id="GGCarousel1" style="display:none">
  <iframe frameborder="0" src=http://www.youtube.com/embed/BAc_VwZ1zIE allowfullscreen="" style="width: 100%;height:auto;"></iframe>
</div>
  </aui:column>
  </aui:layout>
  </aui:fieldset>
  </aui:container>
  <aui:container>
  <aui:fieldset label="Applications For your Role">
  <aui:layout>
  <aui:column>
  <div id="CustomSmartCampus" style="display:none">
  <aui:a href="http://localhost:8080/web/guest/smartcampus1" cssClass="btn" label="Customized Smart Campus"></aui:a>
  </div>
  </aui:column>
  <aui:column>
  <div id="UserLocationAnalytics" style="display:none">
  <aui:a href="http://localhost:8080/web/guest/interactivetour" cssClass="btn" label="Location Analytics"></aui:a>
  </div>
  </aui:column>
  <aui:column>
  <div id="UJIWiki" style="display:none">
  <aui:a href="http://localhost:8080/web/guest/ujiwiki" cssClass="btn" label="Wiki"></aui:a></div>
  </aui:column>
  <aui:column>
  <div id="UJIMsgBoard" style="display:none">
  <aui:a href="http://localhost:8080/web/guest/ujimessageboards" cssClass="btn" label="Message Boards"></aui:a></div>
  </aui:column>
  <aui:column>
  <div id="UJICafeteria" style="display:none">
  <aui:a href="http://localhost:8080/web/guest/cafeteria-information" cssClass="btn" label="Cafeteria Information"></aui:a></div>
  </aui:column>
  <aui:column>
  <div id="UJIBlog" style="display:none">
  <aui:a href="http://localhost:8080/web/guest/ujiblog" cssClass="btn" label="Blogs"></aui:a></div>
  </aui:column>
  <aui:column>
  <div id="UJIPolls" style="display:none">
  <aui:a href="http://localhost:8080/web/guest/ujipolls" cssClass="btn" label="Live Polls"></aui:a></div>
  </aui:column>
  <aui:column>
  <div id="UJIPollsList" style="display:none">
  <aui:a label="Add/View Polls" href="http://localhost:8080/group/control_panel?refererPlid=16082&doAsGroupId=10184&controlPanelCategory=current_site.content&p_p_id=25" cssClass="btn"></aui:a></div>
  </aui:column>
  <aui:column>
  <div id="UJINews" style="display:none">
  <aui:a href="http://localhost:8080/web/guest/ujinews" cssClass="btn" label="News"></aui:a></div>
  </aui:column>
  <aui:column>
  <div id="UJICalendar" style="display:none">
  <aui:a href="http://localhost:8080/web/guest/calendar" cssClass="btn" label="Calendar"></aui:a></div>
  </aui:column>
  <aui:column>
  <div id="UJISiteDirectory" style="display:none">
  <aui:a label="Directory" href="http://localhost:8080/web/guest/ujidirectory?p_p_id=187&p_p_lifecycle=0&p_p_state=normal&p_p_mode=view&p_p_col_id=column-1&p_p_col_count=2&_187_struts_action=%2F187%2Fview&_187_tabs1=users" cssClass="btn"></aui:a>
  </div>
  </aui:column>
  <aui:column>
  <div id="UJIGeoTechStaff" style="display:none">
  <aui:a label="GeoTec Staff Info" href="http://localhost:8080/web/guest/geotecstaffinfo" cssClass="btn"></aui:a>
  </div>  
  </aui:column>
  </aui:layout>
  </aui:fieldset>
  </aui:container>
  </div>
  <div id="locationNotice" style="display:none">
  <aui:container>
  <aui:fieldset label="Important Notice Regarding Your Location">
  <aui:layout>
  <aui:column>
  <h5 id="p2"></h5>
  <h5 id="p1"></h5>
  </aui:column>
  </aui:layout>
  </aui:fieldset>
  <aui:fieldset label="If you want to change your building group manually click on the below button">
  <aui:layout>
  <aui:column>
  <aui:a cssClass="btn" href="http://localhost:8080/web/guest/locationset" label="Change Location Manually"></aui:a>
  </aui:column>
  </aui:layout>
  </aui:fieldset>
  </aui:container>
  </div>
  <div id="notLandingPage" style="display:none">
  <aui:container>
  <aui:fieldset label="Link To Home Page">
  <aui:layout>
    <aui:a class="btn" href="http://localhost:8080/web/guest/landingpage" label="Go To Home Page"></aui:a>
    </aui:layout>
    </aui:fieldset>
    </aui:container>
  </div>  
</div>
