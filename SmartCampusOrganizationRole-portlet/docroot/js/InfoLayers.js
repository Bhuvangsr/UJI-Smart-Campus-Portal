
var layers;
var smartCampusMap;
var ids = new Array();
var layersVisibility = new Array();
var facilitiesLayer;
var featureFacilities;
var layersVisibilityFacilities = new Array();

var urlFacilities = "http://smart.uji.es/adaptor/rest/services/SmartCampus/Facilities_by_floor/MapServer/";


function  loadSmartCampusMap(){
	smartCampusMap = new esri.layers.ArcGISDynamicMapServiceLayer(
		"http://smart.uji.es/adaptor/rest/services/SmartCampus/SmartCampus/MapServer");
	//array de visibilidad de la capa smartCampus
	layersVisibility[0] = -1;//containers
	//layersVisibility[1] = 1;//facilities group layer
	//layersVisibility[2] = 2;//facilities 2256
	//layersVisibility[3] = 3;//facilities
	layersVisibility[1] = -1;//parking points
	layersVisibility[2] = -1;//parking area
	layersVisibility[3] = 3;//buildings
	
	document.getElementById("FacilitiesCheckbox").checked = true;

 	//legendCampus.push({layer:smartCampusMap, title:'SmartCampus'});

	smartCampusMap.setVisibleLayers(layersVisibility);

	map1.addLayer(smartCampusMap);

	
}


function loadFacilities(){
	  //se define las layers de facilities por planta
  facilitiesLayer = new esri.layers.ArcGISDynamicMapServiceLayer("http://smart.uji.es/adaptor/rest/services/SmartCampus/Facilities_by_floor/MapServer");
  
  /*layersVisibilityFacilities[0] = 0;
  layersVisibilityFacilities[1] = -1;//floor -1
  layersVisibilityFacilities[2] = 2;//floor 0
  layersVisibilityFacilities[3] = -1;//floor 1
  layersVisibilityFacilities[4] = -1;//floor 2
  layersVisibilityFacilities[5] = -1;//floor 3
  layersVisibilityFacilities[6] = -1;//floor 4
  layersVisibilityFacilities[7] = -1;//floor 5
  layersVisibilityFacilities[8] = -1;//floor 6
  layersVisibilityFacilities[9] = 9;
  layersVisibilityFacilities[10] = 10;
  layersVisibilityFacilities[11] = 11;*/


  
 // legendCampus.push({layer:facilitiesLayer, title:'Facilities'});
  //facilitiesLayer.setVisibleLayers(layersVisibilityFacilities);
  map1.addLayer(facilitiesLayer);
  
}

function viewFacilitiesByFloor(floor){
  var layerCode = floor + 1;
  //facilitiesLayer.setVisibility(true);
 /* layersVisibilityFacilities = new Array();
  layersVisibilityFacilities[0] = 0;
  layersVisibilityFacilities[1] = floor + 2;
  layersVisibilityFacilities[2]=9;
  layersVisibilityFacilities[3]=10;
  layersVisibilityFacilities[4]=11;*/
  layersVisibilityFacilities = new Array();
   for (var i = 0; i < 10; i++) {
    if(i == layerCode){
      layersVisibilityFacilities[i] = i;
    } else{
      layersVisibilityFacilities[i] = -1;
    }
  };
  facilitiesLayer.setVisibleLayers(layersVisibilityFacilities);
  loadPopupFacilityByFloor(layerCode);

  //featureBuildings.setVisibility(true);

}

function loadPopupFacilityByFloor(layerCode){
  map1.removeLayer(featureFacilities);

  url = urlFacilities + layerCode;

  featureFacilities = new esri.layers.FeatureLayer(url,{
    mode: esri.layers.FeatureLayer.MODE_ONDEMAND,
    outFields: ["*"],
    infoTemplate:popupFacilitiesTemp
  });
  map1.addLayer(featureFacilities);
  leadEventFacilities();
}

function viewFacilitiesExterior(){
  //featureBuildings.setVisibility(true);
  layersVisibilityFacilities = new Array();
  /*layersVisibilityFacilities[0] = 0;
  layersVisibilityFacilities[1] = 2;
  layersVisibilityFacilities[2] = 9;
  layersVisibilityFacilities[3] = 10;
  layersVisibilityFacilities[4] = 11;*/

  for (var i = 0; i < 8; i++) {
    layersVisibilityFacilities[i] = -1;
  };
  layersVisibilityFacilities[8] = 8;
  layersVisibilityFacilities[9] = 9;

  facilitiesLayer.setVisibleLayers(layersVisibilityFacilities);
  loadPopupFacilityExterior();
}

function loadPopupFacilityExterior(){
  map1.removeLayer(featureFacilities);
  featureFacilities = new esri.layers.FeatureLayer("http://smart.uji.es/adaptor/rest/services/SmartCampus/FacilitiesPointsNew/MapServer/0",{
    mode: esri.layers.FeatureLayer.MODE_ONDEMAND,
    outFields: ["*"],
    infoTemplate:popupFacilitiesTemp
  });
 featureFacilities.setOpacity(0);
 featureFacilities.setVisibility(true);

 map1.addLayer(featureFacilities);
}

function leadEventFacilities(){
   dojo.connect(featureFacilities,"onClick",function(evt){
     //map.infoWindow.setFeatures([evt.graphic]);
     //map.infoWindow.show(evt.mapPoint);
     //eventFacilities = evt;
     featureFacilitiesEvent(evt);
 }); 
}


var parking;
var container;
var facilities;
var ilVisible = new Array();
ilVisible[0] = "no";
ilVisible[1] = "no";
ilVisible[2] = "no";

var legendInfoLayers = [];

function setParking(){
    viewParking();
    document.getElementById("ParkingCheckbox").checked = true;
}
function setContainers(){
    viewContainers();
    document.getElementById("ContainersCheckbox").checked = true;
}
function setFacilities(){
    viewFacilities();
    document.getElementById("FacilitiesCheckbox").checked = true;
}

function viewParking(){
    layersVisibility[1]=1;
    layersVisibility[2]=2;
    smartCampusMap.setVisibleLayers(layersVisibility);
    ilVisible[0]="si";
}
function hideParking(){
    layersVisibility[1]=-1;
    layersVisibility[2]=-1;
    smartCampusMap.setVisibleLayers(layersVisibility);
    ilVisible[0]="no";
}
function viewContainers(){
    layersVisibility[0]=0;
    smartCampusMap.setVisibleLayers(layersVisibility);
    ilVisible[1]="si";
}
function hideContainers(){
    layersVisibility[0]=-1;
    smartCampusMap.setVisibleLayers(layersVisibility);
    ilVisible[1]="no";
}
function viewFacilities(){
    facilitiesLayer.setVisibility(true);
   // layersVisibilityFacilities[0] = 0;
   // facilitiesCompleteLayer.setVisibleLayers(layersVisibilityFacilities);
    //layersVisibility[1]=1;
    //layersVisibility[2] = 2;
    //layersVisibility[3] = 3;
    //smartCampusMap.setVisibleLayers(layersVisibility);
    
    featureFacilities.setVisibility(true);

    ilVisible[2]="si";
}
function hideFacilities(){
    facilitiesLayer.setVisibility(false);
   // layersVisibilityFacilities[0] = 0;
   // facilitiesCompleteLayer.setVisibleLayers(layersVisibilityFacilities);
    //layersVisibility[1]=-1;
    //layersVisibility[2] = -1;
    //layersVisibility[3] = -1;
    //smartCampusMap.setVisibleLayers(layersVisibility);

    featureFacilities.setVisibility(false);
    ilVisible[2]="no";
}