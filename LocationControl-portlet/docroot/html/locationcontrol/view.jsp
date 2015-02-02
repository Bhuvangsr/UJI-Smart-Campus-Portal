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
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
<script src="http://js.arcgis.com/3.11/"></script>
  <link rel="stylesheet" href="http://js.arcgis.com/3.11/esri/css/esri.css">
  <link rel="stylesheet" href="http://js.arcgis.com/3.11/dijit/themes/claro/claro.css"> 

<portlet:defineObjects />
<liferay-theme:defineObjects/>
<%@page import="com.es.uji.init.portlets.LocationControlPortlet"%>

<%String userRole=LocationControlPortlet.retrieveCurrentUserRole(user);
String organRole=LocationControlPortlet.retrieveCurrentUserOrganisationRole(user);
pageContext.setAttribute("userRole", userRole);
pageContext.setAttribute("organRole", organRole);
pageContext.setAttribute("userID",user.getUserId());
pageContext.setAttribute("timeStamp",LocationControlPortlet.getCurrentTime());%>
<portlet:actionURL var="changeUserRoleByLocation" name="changeUserRoleByLocation"></portlet:actionURL>

 	<!-- <link rel="stylesheet" type="text/css" href="http://serverapi.arcgisonline.com/jsapi/arcgis/1.1/js/dojo/dijit/themes/tundra/tundra.css">
 	//<script type="text/javascript" src="http://serverapi.arcgisonline.com/jsapi/arcgis/?v=1.1"></script>-->
 	

  <script type="text/JavaScript">
   var configOptions;
  var locator;
  var map;
  var startExtent;
  var pt;
  var pt1;
  var graphicLoc;
   

        function executeQueryTask(evt) {
        //onClick event returns the evt point where the user clicked on the map.
        //This is contains the mapPoint (esri.geometry.point) and the screenPoint (pixel xy where the user clicked).
        //set query geometry = to evt.mapPoint Geometry
        query.geometry = evt.mapPoint;
        pt1 = evt.mapPoint;
        graphicLoc = new esri.Graphic(evt.mapPoint.geometry);  
        var symbol0 = new esri.symbol.SimpleMarkerSymbol().setColor(new dojo.Color([255, 0, 0, 0.9]));  
        
        // add symbol to the graphic  
        graphicLoc.setSymbol(symbol0);  
      // alert(evt.mapPoint.x+':'+evt.mapPoint.y);
        //alert(query.geometry.x);

        //Execute task and call showResults on completion
        queryTask.execute(query, showResults);
      }
			
      function showResults(featureSet) {
    	  //alert(typeof(featureSet));
        //remove all graphics on the maps graphics layer
       // map.graphics.clear();
				//remove just the ones made in here - actually this part doesn't work...
				//map.graphics.remove(graphic);

        //QueryTask returns a featureSet.  Loop through features in the featureSet and add them to the map.
        dojo.forEach(featureSet.features,function(feature){
          //var graphic = feature;
          //graphic.setSymbol(symbol);
          
          //alert(feature.attributes.OBJECTID);
          //alert(feature.attributes.BUILDINGID);
         // var portclass = Packages.com.es.uji.portlets.UserRolePortlet();
          //alert(portclass.retrieveCurrentUserRole());
          //alert(pt1);
         $.ajax({
        	 url:'<%=changeUserRoleByLocation%>',
        	 data:{
        		 <portlet:namespace/>location:feature.attributes.BUILDINGID},
        	success: function(data){
        		//map.setExtent(feature.geometry.getExtent(), true);
        		saveUserLocation(feature.attributes.BUILDINGID);
        		//savelocationApply(feature.attributes.BUILDINGID);
        		//$('#userCurrentRole').val(feature.attributes.BUILDINGID);
        		//window.location.reload();
        	}
        		 });
         
           
        });
        map.setExtent(startExtent);
              }	
      var location;
      var gsvc;
      var posGraphic;
      var bufferGraphic;
      var geoLocate;

      function initLocator(){
      	locator = new esri.tasks.Locator("http://sampleserver1.arcgisonline.com/ArcGIS/rest/services/Locators/ESRI_Geocode_USA/GeocodeServer");
        bufferGraphics = new esri.layers.GraphicsLayer();
        map.addLayer(bufferGraphics);
       // alert(bufferGraphics);
      }



      
      

     

      function getLocation() {
        if (navigator.geolocation) {
      	  
          navigator.geolocation.getCurrentPosition(zoomToLocation, locationError);
        }
      }

      function init() {
      	//popup = new esri.dijit.Popup(null, dojo.create("div"));
      	
      	 
			 esriConfig.defaults.io.corsEnabledServers.push("http://uji.maps.arcgis.com");

      	startExtent = new esri.geometry.Extent(-8276.09427045286, 4864578.77192488, -7062.62433847412, 4865538.06421562,
      	       	new esri.SpatialReference({wkid:3857}) );
      	
        map = new esri.Map("<portlet:namespace/>",{extent:startExtent});
       // dojo.place(popup.domNode,map.root);
        
        map.addLayer(new esri.layers.ArcGISTiledMapServiceLayer("http://services.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer"));
        map.addLayer(new esri.layers.ArcGISDynamicMapServiceLayer("http://smartcampus.sg.uji.es:6080/arcgis/rest/services/SmartCampus/BuildingsNew/MapServer"));
        dojo.connect(map, "onLoad", function() {
        getLocation();
        });
        dojo.connect(map,"onClick",executeQueryTask);
        queryTask = new esri.tasks.QueryTask("http://smartcampus.sg.uji.es:6080/arcgis/rest/services/SmartCampus/BuildingsNew/MapServer/0");
        //build query filter
  		query = new esri.tasks.Query();//("http://smartcampus.sg.uji.es:6080/arcgis/rest/services/SmartCampus/BuildingsNew/MapServer/0");
  		query.returnGeometry = true;
  		query.outFields = ["*"];
  		//var role=$('#userRole').val();
  		//alert($('#userRole').val());
       }
      
      function locationUpdate(location){
    	   pt = esri.geometry.geographicToWebMercator(new esri.geometry.Point(location.coords.longitude, location.coords.latitude));
          map.centerAndZoom(pt, 2);

      }
      
      function saveUserLocation(buildingId1){
      
  		if(pt1.x>=-8276.09427045286 && pt1.y>=4864578.77192488 && pt1.x<=-7062.62433847412 && pt1.y<=4865538.06421562){
  			
      	$.ajax({  
      		  url: "http://services1.arcgis.com/k8WRSCmxGgCwZufI/ArcGIS/rest/services/UserLocationTracking/FeatureServer/0/addFeatures",  
      		  data: { f: "json", features: "[{'geometry':{'x':"+pt1.x+",'y':"+pt1.y+"},'attributes':{'UserID':"+$('#userID').val()+",'UserOrganisationRole':'"+$('#usrOrgRole').val()+"','UserRole':'"+buildingId1+"','TimeStamp':"+$('#timestamp').val()+"}}]",rollbackOnFailure:true},  
    			  dataType: "json",  
        		    
      		  type: 'POST', 
      		 // async:false,
      		  success: function(response) {  
      		    console.log(response); 
      		  //  alert(response);
      		  window.location.reload();
      		  } , error: function (jqXHR, textStatus, errorThrown) {  
      			  console.log('error'); //<-- the response lands here ...  
                  console.log(jqXHR); //<-- the console logs the object  
                  console.log(textStatus); //<-- the console logs 'parsererror'  
                  console.log(errorThrown); //< -- the console logs 'SyntaxError {}'
                 // window.location.reload();
              }});
      	
  		}
  		else{
  			document.getElementById("p1").innerHTML = "You clicked outside the campus. Kindly click on buildings to change the location specific content";
  		}
      	}
      
      function savelocationApply(buildingId2){
          var featureLayer = new esri.layers.FeatureLayer("http://services1.arcgis.com/k8WRSCmxGgCwZufI/ArcGIS/rest/services/UserLocationTracking/FeatureServer/0",{
              mode: esri.layers.FeatureLayer.MODE_ONDEMAND,
              outFields: ["*"]        
            });
		var graphicApply = new esri.Graphic(pt1);
		var symbol0 =new esri.symbol.PictureMarkerSymbol("images/bluedot.png",10,10);
		graphicApply.setSymbol(symbol0);
          graphicApply.attributes = {"UserID":$('#userID').val(),"UserOrganisationRole":$('#usrOrgRole').val(),"UserRole":buildingId2,"TimeStamp":$('#timestamp').val()};
          featureLayer.applyEdits(null,[graphicApply],null,true,null);
      }
      
      function zoomToLocation(location){
        	 pt = esri.geometry.geographicToWebMercator(new esri.geometry.Point(location.coords.longitude, location.coords.latitude));
          map.centerAndZoom(pt, 2);

          var symbol = new esri.symbol.PictureMarkerSymbol("/LocationControl-portlet/docroot/blue-dot.png",10,10);
          if(posGraphic != null ){
          map.graphics.remove(posGraphic);
          }
          if(bufferGraphic!=null){
          map.graphics.remove(bufferGraphic);
          }
          posGraphic = new esri.Graphic(pt,symbol);
          if(posGraphic==null){
				if (navigator.geolocation) {
			      	  
			          navigator.geolocation.getCurrentPosition(locationUpdate, locationError);
			        }
				posGraphic = new esri.Graphic(pt,symbol);
				map.graphics.add(posGraphic);
          		}
	          
          //uncomment to add a graphic at the current location
          var params = new esri.tasks.BufferParameters();
          params.geometries = [pt];
          params.distances = [ 10 ];
          params.outSpatialReference = map.spatialReference;
          params.unit = esri.tasks.GeometryService.UNIT_METER;
          
          gsvc = new esri.tasks.GeometryService("http://smart.uji.es/adaptor/rest/services/Utilities/Geometry/GeometryServer");

          gsvc.buffer(params,showBuffer);

          function showBuffer(buffer) {
            // Add the buffer graphic to the map
            var polySym = new esri.symbol.SimpleFillSymbol()
              .setColor(new dojo.Color([56, 102, 164, 0.4]))
              .setOutline(
                new esri.symbol.SimpleLineSymbol()
                  .setColor(new dojo.Color([56, 102, 164, 0.8]))
              );
            bufferGraphic = new esri.Graphic(buffer[0], polySym);
            
            //bufferGraphics.add(bufferGraphic);
            map.setExtent(startExtent);
            if(bufferGraphic!=null){
            map.graphics.add(bufferGraphic);}
          }
        }

      
         dojo.addOnLoad(init);
  </script>
  
  <div id="esrimap">
  <div id="<portlet:namespace/>" dojotype="dijit.layout.ContentPane" class="tundra" style="width:100%; height:0.72 * width; border:1px solid #000;"></div>
  
  <input id="usrOrgRole" value="${organRole}" type="hidden"/>
  <input id="userRole" value="${userRole}" type="hidden"/>
  <input id="userID" value="${userID}" type="hidden"/>
  <input id="timestamp" value="${timeStamp}" type="hidden"/>
  <h3>You're currently in ${userRole} Building</h3>
  <h5>For Testing Purpose use the following buildings with: "TD","JA","CD","GG","UB","DB"</h5>
  <h3 id="p1"></h3>
</div>
