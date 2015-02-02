/**
 * Smart UJI
 */

//document.write('<scr'+'ipt type="text/javascript" src="Locator.js" ></scr'+'ipt>');

AUI().use('viewport');
  dojo.require("dijit.dijit"); // optimize: load dijit layer
  dojo.require("dijit.layout.BorderContainer");
  dojo.require("dijit.layout.ContentPane");
  dojo.require("dijit.layout.StackContainer");
  dojo.require("esri.map"); 
  dojo.require("esri.tasks.locator"); 
  dojo.require("dojo.number"); 
  dojo.require("dijit.form.Button"); 
  dojo.require("dijit.form.Textarea");
	  //added for highlighting clicked parcel
		dojo.require("esri.tasks.query");
		dojo.require("esri.geometry.webMercatorUtils");
		dojo.require("esri.tasks.geometry");
		 dojo.require("esri.config");

		 
var meter;
var consumtion;
var energyLayer;
var energyLayersVisibility = new Array();
var eneryMeterFeatureLayer;
var energyConsumFeatureLayer;
var elecrticityMeterLayer;
var gasMeterLayer;
var waterMeterLayer;
var elecrticityConsumLayer;
var gasConsumLayer;
var waterConsumLayer;

var fl_electMeter;
var fl_waterMeter;
var fl_gasMeter;

var fl_electConsum;
var fl_waterConsum;
var fl_gasConsum;

//var uriEnergyLayer = "http://mastergeotech.dlsi.uji.es:6080/arcgis/rest/services/Energy/Resources_Consumption/MapServer";
var uriEnergyLayer = "http://smart.uji.es/adaptor/rest/services/Energy/Resources_Consumption/MapServer";

function loadEneryLayers(){
	
	energyLayer = new esri.layers.ArcGISDynamicMapServiceLayer(uriEnergyLayer);
	//vector de visibilidad del mapserver de energ�a
	energyLayersVisibility[0] = -1;//energy meters
	energyLayersVisibility[1] = -1;//energy consum
	energyLayersVisibility[2] = -1;//gas meter
	energyLayersVisibility[3] = -1;//gas consum
	energyLayersVisibility[4] = -1;//water meter
	energyLayersVisibility[5] = -1;//water consum
	energyLayer.setVisibleLayers(energyLayersVisibility);
	//legendCampus.push({layer:energyLayer, title:'Facilities Consumption'});
	//loadLegend();
	//alert(energyLayersVisibility);
	//alert(energyLayer);
	map1.addLayer(energyLayer);

	//cargar todas las capas independientemente
	loadAllEnergyPopups();

}

function loadAllEnergyPopups(){

	popupElectMeter = new esri.dijit.PopupTemplate({
   		title: "Electricity Meter",
    	highlight : "false",
   		description:"ID Meter: {GeoEnergyConsumption.STUDENT.Meters.ID_Contador}<br>Location: {EnergyConsumption.DBO.%Relacion.ruta_Objeto}<br>Type: {EnergyConsumption.DBO.%Relacion.tipo}"
  	});

  	popupGasMeter = new esri.dijit.PopupTemplate({
   		title: "Gas Meter",
    	highlight : "false",
   		description:"ID Meter: {GeoEnergyConsumption.STUDENT.Meters.ID_Contador}<br>Location: {EnergyConsumption.DBO.%Relacion.ruta_Objeto}<br>Type: {EnergyConsumption.DBO.%Relacion.tipo}"    
  	});

  	popupWaterMeter = new esri.dijit.PopupTemplate({
   		title: "Water Meter",
    	highlight : "false",
   		description:"ID Meter: {GeoEnergyConsumption.STUDENT.Meters.ID_Contador}<br>Location: {EnergyConsumption.DBO.%Relacion.ruta_Objeto}<br>Type: {EnergyConsumption.DBO.%Relacion.tipo}"    
  	});

  	popupElectConsum = new esri.dijit.PopupTemplate({
   		title: "Electricity Consumption",
    	highlight : "false",
   		description:"Building: {GeoEnergyConsumption.STUDENT.ServiceAreas.LONGNAME}<br>Type: {GeoEnergyConsumption.STUDENT.ServiceAreas.BLDGTYPE}<br>kWh: {EnergyConsumption.DBO.%Datos.ENERGIA}"    
  	});

  	popupGasConsum = new esri.dijit.PopupTemplate({
   		title: "Gas Consumption",
    	highlight : "false",
   		description:"Building: {GeoEnergyConsumption.STUDENT.ServiceAreas.LONGNAME}<br>Type: {GeoEnergyConsumption.STUDENT.ServiceAreas.BLDGTYPE}<br>m3: {EnergyConsumption.DBO.%Datos.GAS}"    
  	});

  	popupWaterConsum = new esri.dijit.PopupTemplate({
   		title: "Water Consumption",
    	highlight : "false",
   		description:"Building: {GeoEnergyConsumption.STUDENT.ServiceAreas.LONGNAME}<br>Type: {GeoEnergyConsumption.STUDENT.ServiceAreas.BLDGTYPE}<br>m3: {EnergyConsumption.DBO.%Datos.AGUA_POTABLE}"    
  	});

 	
 	fl_electConsum = new esri.layers.FeatureLayer(uriEnergyLayer+"/1",{
    	mode: esri.layers.FeatureLayer.MODE_ONDEMAND,
    	outFields: ["*"],
    	infoTemplate:popupElectConsum
  	});

 	fl_electConsum.setOpacity(0);
 	fl_electConsum.setVisibility(false);
 	map1.addLayer(fl_electConsum);
	

	fl_gasConsum = new esri.layers.FeatureLayer(uriEnergyLayer+"/3",{
    	mode: esri.layers.FeatureLayer.MODE_ONDEMAND,
    	outFields: ["*"],
    	infoTemplate:popupGasConsum
  	});

 	fl_gasConsum.setOpacity(0);
 	fl_gasConsum.setVisibility(false);
 	map1.addLayer(fl_gasConsum);
	

	fl_waterConsum = new esri.layers.FeatureLayer(uriEnergyLayer+"/5",{
    	mode: esri.layers.FeatureLayer.MODE_ONDEMAND,
    	outFields: ["*"],
    	infoTemplate:popupWaterConsum
  	});

 	fl_waterConsum.setOpacity(0);
 	fl_waterConsum.setVisibility(false);
 	map1.addLayer(fl_waterConsum);

 	fl_electMeter = new esri.layers.FeatureLayer(uriEnergyLayer+"/0",{
    	mode: esri.layers.FeatureLayer.MODE_ONDEMAND,
    	outFields: ["*"],
    	infoTemplate:popupElectMeter
  	});

 	fl_electMeter.setOpacity(0);
 	fl_electMeter.setVisibility(false);
 	map1.addLayer(fl_electMeter);

 

 	fl_gasMeter = new esri.layers.FeatureLayer(uriEnergyLayer+"/2",{
    	mode: esri.layers.FeatureLayer.MODE_ONDEMAND,
    	outFields: ["*"],
    	infoTemplate:popupGasMeter
  	});

 	fl_gasMeter.setOpacity(0);
 	fl_gasMeter.setVisibility(false);
 	map1.addLayer(fl_gasMeter);
	
	
	fl_waterMeter = new esri.layers.FeatureLayer(uriEnergyLayer+"/4",{
    	mode: esri.layers.FeatureLayer.MODE_ONDEMAND,
    	outFields: ["*"],
    	infoTemplate:popupWaterMeter
  	});

 	fl_waterMeter.setOpacity(0);
 	fl_waterMeter.setVisibility(false);
 	map1.addLayer(fl_waterMeter);
}


function hideEnergyMeter(){
	energyLayersVisibility[0] = -1;
	energyLayersVisibility[2] = -1;
	energyLayersVisibility[4] = -1;
	fl_electMeter.setVisibility(false);
	fl_gasMeter.setVisibility(false);
	fl_waterMeter.setVisibility(false);
	energyLayer.setVisibleLayers(energyLayersVisibility);
	document.getElementById("MeterCheckbox").checked = false;
}

function meterRadioActive(){
	var value;
	if(document.getElementById("ElectMeterRadio").checked){
		value = "Electricity";
		showElectricityMeter();
	}else if(document.getElementById("GasMeterRadio").checked){
		value = "Gas";
		showGasMeter();
	}else if(document.getElementById("WaterMeterRadio").checked){
		value = "Water";
		showWaterMeter();
	}

}
function changeBaseMap(value){
	viewBasemap(value);
	if(value=="gray"){
		document.getElementById("GrayRadio").checked = true;
	} else if(value=="color"){
		document.getElementById("ColorRadio").checked = true;
	}
}

function showElectricityMeter(){
	if(document.getElementById("MeterCheckbox").checked){
		hideGasMeter();
		hideWaterMeter();
		//Encender la capa de ElectricityMeter Layer
		energyLayersVisibility[0] = 0;
		energyLayer.setVisibleLayers(energyLayersVisibility);
		fl_electMeter.setVisibility(true);
	}
}

function hideElectricityMeter(){
	energyLayersVisibility[0] = -1;
	energyLayer.setVisibleLayers(energyLayersVisibility);
	fl_electMeter.setVisibility(false);
}

function showGasMeter(){
	if(document.getElementById("MeterCheckbox").checked){
		hideElectricityMeter();
		hideWaterMeter();
		//Encender la capa de GasMeter Layer
		energyLayersVisibility[2] = 2;
		energyLayer.setVisibleLayers(energyLayersVisibility);
		fl_gasMeter.setVisibility(true);
	}
}

function hideGasMeter(){
	energyLayersVisibility[2] = -1;
	energyLayer.setVisibleLayers(energyLayersVisibility);
	fl_gasMeter.setVisibility(false);
}
function showWaterMeter(){
	if(document.getElementById("MeterCheckbox").checked){
		hideElectricityMeter();
		hideGasMeter();
		//Encender la capa de WaterMeter Layer
		energyLayersVisibility[4] = 4;
		energyLayer.setVisibleLayers(energyLayersVisibility);
		fl_waterMeter.setVisibility(true);
	}

}

function hideWaterMeter(){
	energyLayersVisibility[4] = -1;
	energyLayer.setVisibleLayers(energyLayersVisibility);
	fl_waterMeter.setVisibility(false);
}

function hideEnergyConsum(){
	energyLayersVisibility[1] = -1;
	energyLayersVisibility[3] = -1;
	energyLayersVisibility[5] = -1;
	fl_electConsum.setVisibility(false);
	fl_gasConsum.setVisibility(false);
	fl_waterConsum.setVisibility(false);
	energyLayer.setVisibleLayers(energyLayersVisibility);

}

function consumRadioActive(){
	var value;
	if(document.getElementById("ElectConsumRadio").checked){
		value = "Electricity";
		showElectricityConsum();
	}else if(document.getElementById("GasConsumRadio").checked){
		value = "Gas";
		showGasConsum();
	}else if(document.getElementById("WaterConsumRadio").checked){
		value = "Water";
		showWaterConsum();
	}
}

function showElectricityConsum(){
	if(document.getElementById("ConsumptionCheckbox").checked){
		hideGasConsum();
		hideWaterConsum();
		//Encender la capa de ElectricityMeter Layer
		energyLayersVisibility[1] = 1;
		energyLayer.setVisibleLayers(energyLayersVisibility);
		fl_electConsum.setVisibility(true);
	}
}

function hideElectricityConsum(){
	energyLayersVisibility[1] = -1;
	energyLayer.setVisibleLayers(energyLayersVisibility);
	fl_electConsum.setVisibility(false);
}

function showGasConsum(){
	if(document.getElementById("ConsumptionCheckbox").checked){
		hideElectricityConsum();
		hideWaterConsum();
		//Encender la capa de GasMeter Layer
		energyLayersVisibility[3] = 3;
		energyLayer.setVisibleLayers(energyLayersVisibility);
		fl_gasConsum.setVisibility(true);
	}
}

function hideGasConsum(){
	energyLayersVisibility[3] = -1;
	energyLayer.setVisibleLayers(energyLayersVisibility);
	fl_gasConsum.setVisibility(false);

}
function showWaterConsum(){
	if(document.getElementById("ConsumptionCheckbox").checked){
		hideElectricityConsum();
		hideGasConsum();
		//Encender la capa de WaterMeter Layer
		energyLayersVisibility[5] = 5;
		energyLayer.setVisibleLayers(energyLayersVisibility);
		fl_waterConsum.setVisibility(true);

	}
}

function hideWaterConsum(){
	energyLayersVisibility[5] = -1;
	energyLayer.setVisibleLayers(energyLayersVisibility);
	fl_waterConsum.setVisibility(false);

}
