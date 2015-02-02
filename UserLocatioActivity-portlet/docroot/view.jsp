<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>
<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui"%>
<%@ taglib uri="http://liferay.com/tld/portlet" prefix="liferay-portlet" %>
<%@ taglib uri="http://liferay.com/tld/theme" prefix="liferay-theme" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>
<%@ taglib uri="http://liferay.com/tld/util" prefix="liferay-util" %>
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
<script src="http://js.arcgis.com/3.12/"></script>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

  <link rel="stylesheet" href="http://js.arcgis.com/3.11/esri/css/esri.css">
  <link rel="stylesheet" href="http://js.arcgis.com/3.11/dijit/themes/claro/claro.css"> 

<portlet:defineObjects />
<liferay-theme:defineObjects/>
<%@page import="com.es.uji.init.portlets.UserLocatioActivityPortlet"%>

<%String userRole=UserLocatioActivityPortlet.retrieveCurrentUserRole(user);
String organRole=UserLocatioActivityPortlet.retrieveCurrentUserOrganisationRole(user);
pageContext.setAttribute("userRole", userRole);
pageContext.setAttribute("organRole", organRole);
pageContext.setAttribute("userID",user.getUserId());
pageContext.setAttribute("timeStamp",UserLocatioActivityPortlet.getCurrentTime());%>
<portlet:actionURL var="changeUserRoleByLocation" name="changeUserRoleByLocation"></portlet:actionURL>
<portlet:actionURL var="retrieveCurrentUserOrganisationRole" name="retrieveCurrentUserOrganisationRole"></portlet:actionURL>

<script type="text/JavaScript">

   var configOptions;
  
  var map2;
  
  function init() {
	  
    	
	//  try{
		  var features = [];
	esriConfig.defaults.io.corsEnabledServers.push("http://uji.maps.arcgis.com");

    	startExtent = new esri.geometry.Extent(-8276.09427045286, 4864578.77192488, -7062.62433847412, 4865538.06421562,
    	       	new esri.SpatialReference({wkid:3857}) );
      map2 = new esri.Map("<portlet:namespace/>",{extent:startExtent});
     // map2.addLayer(new esri.layers.ArcGISDynamicMapServiceLayer("http://smartcampus.sg.uji.es:6080/arcgis/rest/services/SmartCampus/BuildingsNew/MapServer"));
     map2.addLayer(new esri.layers.ArcGISTiledMapServiceLayer("http://services.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer"));
       dojo.connect(map2, "onLoad", function() {
     	 var queryTask = new esri.tasks.QueryTask("http://services1.arcgis.com/k8WRSCmxGgCwZufI/ArcGIS/rest/services/UserLocationTracking/FeatureServer/0");  
      
      	//build query filter  
      	var query = new esri.tasks.Query();  
      	query.returnGeometry = true;  
     	 query.where = "UserID="+$('#userID').val(); 
     	 query.outFields=["UserID","UserOrganisationRole","TimeStamp","UserRole"];
     	 dojo.connect(queryTask, "onComplete", function(featureSet) {  
     	 //try{  
         	var symbol1  = new esri.symbol.SimpleMarkerSymbol().setSize(5).setColor(new dojo.Color([255,0,0]));
         	var symbol2  = new esri.symbol.SimpleMarkerSymbol().setSize(8).setColor(new dojo.Color([55,102,164]));
         	var compare_date = 0;
         	//var content2;
         	var lastKnownFeature;
         	//QueryTask returns a featureSet.  Loop through features in the featureSet and add them to the map.  
         	dojo.forEach(featureSet.features,function(feature){  
	            
          		var graphicmis = feature;  
	          	graphicmis.setSymbol(symbol1);  
	          	var infoTemplate2 = new esri.InfoTemplate();
	        	 infoTemplate2.setTitle(feature.attributes.UserID);
          		var date_visit= new Date(feature.attributes.TimeStamp).toUTCString();
          		var content1= "<b>User Role name: </b>"+feature.attributes.UserRole+
          		"<br/><b>Organisation Role :</b>"+feature.attributes.UserOrganisationRole+
          		"</b><br/><b>Visited Time :</b>"+date_visit+"</b>";
          		var attributesGraphic= {"User Role name":feature.attributes.UserRole,
          		"Organisation Role":feature.attributes.UserOrganisationRole,
          		"Visited Time":date_visit};
          		
          		if(compare_date<feature.attributes.TimeStamp){
	          		compare_date=feature.attributes.TimeStamp;
	          		content2=content1;
	          		lastKnownFeature = feature;
	          	}
          		infoTemplate2.setContent(content1);
          		graphicmis.setInfoTemplate(infoTemplate2);
          		graphicmis.setAttributes(attributesGraphic);
         		map2.graphics.add(graphicmis);
          		features.push(feature.geometry);
		          
        		});
         	//var infoTemplate3 = new esri.InfoTemplate();
       	 	//infoTemplate3.setTitle("${UserID}");
         	var graphicLocLast = lastKnownFeature;
         	graphicLocLast.setSymbol(symbol2);
         	//infoTemplate3.setContent(content2);
      		//graphicmis.setInfoTemplate(infoTemplate3);
     		//map2.graphics.add(graphicLocLast);
     		
         	 //create polyline
         	  var polyline = new esri.geometry.Polyline(map2.spatialReference);
         	  polyline.addPath(features);
				//alert(polyline);
         	  //create graphic
         	  var graphicLine = polyline;
         	 var line = new esri.Graphic(polyline, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SHORTDASHDOTDOT, new dojo.Color([225,155,0]), 3));
             map2.graphics.add(line);

         	  //add graphic to map
         	 // map2.graphics.add(graphicLine);	
     	 /*}catch(e){  
    	   console.log(" exception occured"+e);
       }  */
      });  
     queryTask.execute(query); });
     /*dojo.connect(map2, "onLoad", function() {  
     	   map2.addLayer(selLayer);  
     	});*/
         
     /*myTable = new esri.dijit.FeatureTable({
         "featureLayer" : featureLayer,
         "map" : map2  // field that end-user can show, but is hidden on startup
       }, 'myTableNode');
       myTable.startup();*/
     
      
    /*} catch(e){  
        console.log(" exception occured"+e);  
    } */
    
 }    
  

  
  
   
  
  dojo.addOnLoad(init);
  </script>
  <div id="esrimap">
  <input id="usrOrgRole" value="${organRole}" type="hidden"/>
  <input id="userRole" value="${userRole}" type="hidden"/>
  <input id="userID" value="${userID}" type="hidden"/>
  <input id="timestamp" value="${timeStamp}" type="hidden"/>
  <div id="<portlet:namespace/>" dojotype="dijit.layout.ContentPane" class="tundra" style="width:100%; height:0.72 * width; border:1px solid #000;"></div>
  <div id="myTableNode"></div>
</div>
  