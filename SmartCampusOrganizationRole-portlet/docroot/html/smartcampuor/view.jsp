<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>
<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui"%>
<%@ taglib uri="http://liferay.com/tld/portlet" prefix="liferay-portlet" %>
<%@ taglib uri="http://liferay.com/tld/theme" prefix="liferay-theme" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>
<%@ taglib uri="http://liferay.com/tld/util" prefix="liferay-util" %>
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
<script src="http://js.arcgis.com/3.11/"></script>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
  <link rel="stylesheet" href="http://js.arcgis.com/3.11/esri/css/esri.css">
  <link rel="stylesheet" href="http://js.arcgis.com/3.11/dijit/themes/claro/claro.css"> 

<portlet:defineObjects />
<liferay-theme:defineObjects/>
<%@page import="com.es.uji.init.portlets.SmartCampuORPortlet"%>

<%String userRole=SmartCampuORPortlet.retrieveCurrentUserRole(user);
String organRole=SmartCampuORPortlet.retrieveCurrentUserOrganisationRole(user);
pageContext.setAttribute("userRole", userRole);
pageContext.setAttribute("organRole", organRole);%>
<portlet:actionURL var="changeUserRoleByLocation" name="changeUserRoleByLocation"></portlet:actionURL>
<portlet:actionURL var="retrieveCurrentUserOrganisationRole" name="retrieveCurrentUserOrganisationRole"></portlet:actionURL>

<script type="text/JavaScript">
   var configOptions;
  
  var map1;
  
  function init() {
    	//popup = new esri.dijit.Popup(null, dojo.create("div"));
    	 
	esriConfig.defaults.io.corsEnabledServers.push("http://uji.maps.arcgis.com");

    	startExtent = new esri.geometry.Extent(-8276.09427045286, 4864578.77192488, -7062.62433847412, 4865538.06421562,
    	       	new esri.SpatialReference({wkid:3857}) );
    	
      map1 = new esri.Map("<portlet:namespace/>",{extent:startExtent});
     // dojo.place(popup.domNode,map.root);
      
      map1.addLayer(new esri.layers.ArcGISTiledMapServiceLayer("http://services.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer"));
      //map1.addLayer(new esri.layers.ArcGISDynamicMapServiceLayer("http://smart.uji.es/adaptor/rest/services/Energy/Resources_Consumption/MapServer/1"));
     // map1.addLayer(new esri.layers.ArcGISDynamicMapServiceLayer("http://smartcampus.sg.uji.es:6080/arcgis/rest/services/SmartCampus/BuildingsNew/MapServer"));
      var jas=$("#usrOrgRole").val();
      //alert(jas);
      if(jas=="UJIMaintenance"){
    	  loadEneryLayers();
    	  $("#EnergyOn").show();
    	  $("#rightPane").hide();
      } else if(jas=="UJIAcademic"){
    	  loadSmartCampusMap();
    	  loadFacilities();
    	  loadEneryLayers();
    	  $("#EnergyOn").show();
    	  $("#rightPane").show();
    	  
      } else if(jas=="UJIVisitor"){
    	  loadSmartCampusMap();
    	  loadFacilities();
    	  $("#EnergyOn").hide();
    	  $("#rightPane").show();
    	  
      }else if($("#userRole").val()=="Administrator"){
    	  loadSmartCampusMap();
    	  loadFacilities();
    	  loadEneryLayers();
    	  $("#EnergyOn").show();
    	  $("#rightPane").show();
      }
    }
  var location;
  var gsvc;
  var posGraphic;
  var bufferGraphic;
  
  function getLocation() {
      if (navigator.geolocation) {
    	  
        navigator.geolocation.getCurrentPosition(zoomToLocation, locationError);
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
  
  function zoomToLocation(location){
 	 var pt = esri.geometry.geographicToWebMercator(new esri.geometry.Point(location.coords.longitude, location.coords.latitude));
   map1.centerAndZoom(pt, 2);

   var symbol = new esri.symbol.PictureMarkerSymbol("/SmartCampusOrganizationRole-portlet/docroot/blue-dot.png",10,10);
   if(posGraphic != null ){
   map1.graphics.remove(posGraphic);
   }
   if(bufferGraphic!=null){
   map1.graphics.remove(bufferGraphic);
   }
   posGraphic = new esri.Graphic(pt,symbol);
   if(posGraphic==null){
			if (navigator.geolocation) {
		      	  
		          navigator.geolocation.getCurrentPosition(locationUpdate, locationError);
		        }
			posGraphic = new esri.Graphic(pt,symbol);
			map1.graphics.add(posGraphic);
   		}
       
   //uncomment to add a graphic at the current location
   var params = new esri.tasks.BufferParameters();
   params.geometries = [pt];
   params.distances = [ 10 ];
   params.outSpatialReference = map1.spatialReference;
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
     map1.setExtent(startExtent);
     if(bufferGraphic!=null){
     map1.graphics.add(bufferGraphic);}
   }
 }

  
  
  
  dojo.addOnLoad(init);
  </script>
  <div id="esrimap">
  <input id="usrOrgRole" value="${organRole}" type="hidden"/>
  <input id="userRole" value="${userRole}" type="hidden"/>
  <div id="<portlet:namespace/>" dojotype="dijit.layout.ContentPane" class="tundra" style="width:100%; height:0.72 * width; border:1px solid #000;"></div>
    
  <aui:button type="button" value="Show My Location" onClick="getLocation()"></aui:button>
  <!--Energy menu-->
        <div id="EnergyOn" style="display:none">
    <h3>Facilities Consumption</h3>
    <div id="LayersRightPane" style="display:block;">
            <div id="MetersForm">
                <form>
                    <div id="fMeterOn"  style="display:block;">
                        <a href="javascript: expandCollapse('innerFormEneMeterOn','innerFormEneMeterOff');"><img src="http://smart.uji.es/menu/img/upbutton.png"/></a><input type="checkbox" id="MeterCheckbox" name="Meter" value="Meter" onClick="if(this.checked == true){meterRadioActive()} else{hideEnergyMeter()};"><b>Meter</b><br>
                        <div id="innerFormEne2">
                            
                        </div>  
                        <div id="innerFormEneMeterOn">
                            <input type="radio" id="ElectMeterRadio" name="Meter" class="styled" value="Electricity" onClick="showElectricityMeter()" checked="checked">Electricity<br>
                            <input type="radio" id="GasMeterRadio" name="Meter" class="styled" value="Gas" onClick="showGasMeter()">Gas<br>
                            <input type="radio" id="WaterMeterRadio" name="Meter" class="styled" value="Water" onClick="showWaterMeter()">Water<br>
                        </div>
                    </div>
                    <div id="fMeterOff"  style="display:none;">
                        <a href="javascript: expandCollapse('innerFormEneMeterOn','innerFormEneMeterOff');"><img src="http://smart.uji.es/menu/img/downbutton.png"/></a>
                        <div id="innerFormEneMeterOff">
                        </div>
                    </div>
                </form>
            </div>
            <div id="ConsumptionForm">
                <form>
                    <div id="fConsumptionOn"  style="display:block;">
                        <a href="javascript: expandCollapse('innerFormEneConsumOn','innerFormEneConsumOff');"><img src="http://smart.uji.es/menu/img/upbutton.png"/></a><input type="checkbox" id="ConsumptionCheckbox" name="Consumption" value="Consumption" onClick="if(this.checked == true){consumRadioActive()} else{hideEnergyConsum()}"><b>Consumption</b><br>
                        <div id="innerFormEne2">
   
                        </div>
                        <div id="innerFormEneConsumOn">
                            <input type="radio" id="ElectConsumRadio" name="Consumption" class="styled" value="Electricity" onClick="showElectricityConsum()" checked="checked">Electricity<br>
                            <input type="radio" id="GasConsumRadio" name="Consumption" class="styled" value="Gas" onClick="showGasConsum()">Gas<br>
                            <input type="radio" id="WaterConsumRadio" name="Consumption" class="styled" value="Water" onClick="showWaterConsum()">Water<br>
                        </div>
                    </div>
                    <div id="fConsumptionOff"  style="display:none;">
                        <a href="javascript: expandCollapse('innerFormEneConsumOn','innerFormEneConsumOff');"><img src="http://smart.uji.es/menu/img/downbutton.png"/></a>
                        <div id="innerFormEneConsumOff">
                        </div>
                    </div>
                </form>
            </div>
  </div>
  </div>
  
  
  <div id="rightPane" class="roundedCorners" style="display: none;">

        <!--Layers menu-->
        <div id="LayersOn" style="display: block;">
    <h3>Layers</h3>
    <div id="LayersRightPane" style="display:block;">

        <!--InfoLayers form-->
        <div id="LayersForm">
            <form class="ng-pristine ng-valid">
                <div id="fInfoLayersOn" style="display:block;">
                    <a href="javascript: expandCollapse('fInfoLayersOn','fInfoLayersOff');"><img src="http://smart.uji.es/menu/img/upbutton.png"></a><b>InfoLayers</b><br>
                    <div id="innerForm">
                        <input id="ParkingCheckbox" name="Parking" value="Parking" onclick="if(this.checked == true){viewParking()} else{hideParking()}" type="checkbox">Parking<br>
                        <input id="ContainersCheckbox" name="Containers" value="Container" onclick="if(this.checked == true){viewContainers()} else{hideContainers()}" type="checkbox">Containers<br>
                        <input id="FacilitiesCheckbox" name="Facilities" value="Facilities" onclick="if(this.checked == true){viewFacilities()} else{hideFacilities()}" type="checkbox">Facilities<br>
                    </div>
                </div>
                <div id="fInfoLayersOff" style="display:none;">
                    <a href="javascript: expandCollapse('fInfoLayersOn','fInfoLayersOff');"><img src="http://smart.uji.es/menu/img/downbutton.png"></a><b>InfoLayers</b><br>
                </div>
            </form>
        </div>

        <!--Buildings form-->
        <!--<div id="LayersForm">
            <form>
                <div id="fBuildingsOn"  style="display:block;">
                    <a href="javascript: expandCollapse('fBuildingsOn','fBuildingsOff');"><img src="menu/img/upbutton.png"/></a><b>Buildings</b><br>
                    <div id="innerForm">
                        <input type="radio" id="ExteriorRadio" name="Building" class="styled" value="Exterior" onClick="viewBuildingsLayers(value),hideFloorControls(), clearMapGraphics()" checked>Exterior<br>
                        <input type="radio" id="InteriorRadio" name="Building" class="styled" value="Interior" onClick="viewBuildingsLayers(value),showFloorControls()">Interior<br>
                    </div>
                </div>
                <div id="fBuildingsOff"  style="display:none;">
                    <a href="javascript: expandCollapse('fBuildingsOn','fBuildingsOff');"><img src="menu/img/downbutton.png"/></a><b>Buindings</b><br>
                </div>
            </form>
        </div>-->

     </div>
</div>        
  </div>
  