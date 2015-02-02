
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
		 dojo.require("esri.layers.FeatureLayer");
	      dojo.require("dijit.form.Button");
	      dojo.require("dijit.Dialog");
	      dojo.require("esri.InfoTemplate");
	      dojo.require("esri.dijit.FeatureTable");
	      dojo.require("dojo.number");
	      dojo.require("dojo.domReady!");
	      dojo.require("esri.renderers.HeatmapRenderer");
	     
	      
	      
	   	 function showAllPointsOnMap(){
	   		map2.graphics.clear();
	   	 
	   		showPointsOnMap(allfeaturesAnalytics);
	   		$("#trackPathText").show();
	 		$("#trackPath").show();
	   	 }
	   
	 	function showPointsOnMap(featuresAnalytics1){
	 		//map2.graphics.clear();
	 			//alert(featuresAnalytics1.length);
	 		 	 //try{  
	 	         	var symbol1  = new esri.symbol.SimpleMarkerSymbol().setSize(5).setColor(new dojo.Color([255,0,0]));
	 	         	var symbol2  = new esri.symbol.SimpleMarkerSymbol().setSize(8).setColor(new dojo.Color([55,102,164]));
	 	         	var compare_date = 0;
	 	         	var content2;
	 	         	var lastKnownFeature;
	 	         	//QueryTask returns a featureSet.  Loop through features in the featureSet and add them to the map.  
	 	         	dojo.forEach(featuresAnalytics1,function(feature){ 
	 	         		//alert(feature.attributes.UserID);
	 		            if(feature.attributes.UserID==$("#userID").val()){
	 		            	
	 		            
	 		            var graphicmis = new esri.Graphic(feature.geometry,null,feature.attributes);  
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
	 	          		infoTemplate2.setContent(content1);
	 	          		if(compare_date<feature.attributes.TimeStamp){
	 		          		compare_date=feature.attributes.TimeStamp;
	 		          		content2=infoTemplate2;
	 		          		lastKnownFeature = new esri.Graphic(feature.geometry,null,feature.attributes);
	 		          	}
	 	          		
	 	          		graphicmis.setInfoTemplate(infoTemplate2);
	 	          		graphicmis.setAttributes(attributesGraphic);
	 	         		map2.graphics.add(graphicmis);
	 	         		features.push(feature.geometry);
	 	          		featuresAnalytics.push(graphicmis);  
	 		            }});
	 	         	//var infoTemplate3 = new esri.InfoTemplate();
	 	       	 	//infoTemplate3.setTitle("${UserID}");
	 	       	 	if(lastKnownFeature!=null){
	 	         	var graphicLocLast = lastKnownFeature;
	 	         	graphicLocLast.setSymbol(symbol2);
	 	         	graphicLocLast.setInfoTemplate(content2);
	 	         	map2.graphics.add(graphicLocLast);
	 	       	 	}
	 	         	//infoTemplate3.setContent(content2);
	 	      		//graphicmis.setInfoTemplate(infoTemplate3);
	 	     		//map2.graphics.add(graphicLocLast);
	 	     		
	 	         	
	 	         	  //add graphic to map
	 	         	 // map2.graphics.add(graphicLine);	
	 	     	 /*}catch(e){  
	 	    	   console.log(" exception occured"+e);
	 	       }  */
	 	      	
	 		
	 		 	 }
	 	
	 	
	 	function trackPathPoints(){
	 		//map2.graphics.clear();
	 		 //create polyline
	    	  var polyline = new esri.geometry.Polyline(map2.spatialReference);
	    	  polyline.addPath(features);
	 			//alert(polyline);
	    	  //create graphic
	    	  var graphicLine = polyline;
	    	 var line = new esri.Graphic(polyline, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SHORTDASHDOTDOT, new dojo.Color([225,155,0]), 3));
	        map2.graphics.add(line);

	 	}

	 	
	 	function displayMapBuildings(buildings){
	 		 // alert(buildings.length);
	 		 //map2.graphics.clear();
	 		  	var featuresSelectBuildings=[];
	 		  	dojo.forEach(allfeaturesAnalytics,function(feature){
	 		  		//alert($.inArray(feature.attributes.UserRole,buildings));
	 		  		if($.inArray(feature.attributes.UserRole,buildings)!=-1 )
	 		  			{
	 		  			featuresSelectBuildings.push(feature);
	 		  			}
	 		  	});
	 		  	
	 		  	showPointsOnMap(featuresSelectBuildings);
	 		
	 	}
	 	
	 	function displayMapBuildingsDates(buildings){
	 		 // alert(buildings.length);
	 		 //map2.graphics.clear();
	 		  	var featuresSelectBuildings=[];
	 		  	dojo.forEach(allfeaturesAnalytics,function(feature){
	 		  		//alert($.inArray(feature.attributes.UserRole,buildings));
	 		  		if($.inArray(feature.attributes.UserRole,buildings)!=-1 )
	 		  			{
	 		  			if(feature.attributes.TimeStamp>=startUserDateTimeStamp && feature.attributes.TimeStamp<=endUserDateTimeStamp){
	 		  			featuresSelectBuildings.push(feature);
	 		  			}
	 		  		}
	 		  	});
	 		  	
	 		  	showPointsOnMap(featuresSelectBuildings);
	 		
	 	}
	 	
	 	function showPolygonsOnMap(buildings){
	 		var maxNumVisits=0;
	 		var maxVisitFeature;
	 		var maxContent;
	 		dojo.forEach(allBuildings,function(eachBuilding){
	 			if($.inArray(eachBuilding.attributes.BUILDINGID,buildings)!=-1 )
	 				{
	 				numberOfVisitsByUser(eachBuilding.attributes.BUILDINGID);
	 				var userNumVisits= numVisits;
	 				
	 				var polySymbol1 = new esri.symbol.SimpleFillSymbol(
	 					       esri.symbol.SimpleLineSymbol.STYLE_SOLID,
	 					       new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID,
	 					         new dojo.Color([0, 0, 0, 1]), 1),
	 					       new dojo.Color([255, 0, 0, 0.2])
	 					     );
	 				var infoTemplate4 = new esri.InfoTemplate();
	 	        	 infoTemplate4.setTitle(eachBuilding.attributes.BUILDINGID);
	 	        	 var content4= "<b>Number Of Visits: </b>"+userNumVisits;
	 	        	infoTemplate4.setContent(content4);
	 	        	if(maxNumVisits<=userNumVisits){
	 					maxNumVisits=userNumVisits;
	 					maxVisitFeature=eachBuilding;
	 					maxContent=infoTemplate4;
	 				}
	 				var polyGraphic = new esri.Graphic(eachBuilding.geometry,null,eachBuilding.attributes);;
	 				
	 				polyGraphic.setInfoTemplate(infoTemplate4);
	 				polyGraphic.setSymbol(polySymbol1);
	 				map2.graphics.add(polyGraphic);
	 				}
	 		});
	 		var polySymbol2 = new esri.symbol.SimpleFillSymbol(
	 			       esri.symbol.SimpleLineSymbol.STYLE_SOLID,
	 			       new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID,
	 			         new dojo.Color([0, 0, 0, 1]), 1),
	 			       new dojo.Color([125, 20, 225, 0.6])
	 			     );
	 		if(maxVisitFeature!=null){
	          	var graphicLocLast1 = maxVisitFeature;
	          	graphicLocLast1.setSymbol(polySymbol2);
	          	graphicLocLast1.setInfoTemplate(maxContent);
	          	map2.graphics.add(graphicLocLast1);
	        	 	}
	 	}
	 	
	 	function showPolygonsOnMapDates(buildings){
	 		extractUserIdStatsDates1($("#userID").val());
	 		var maxNumVisits4=0;
	 		var maxVisitFeature;
	 		var maxContentv3;
	 		dojo.forEach(allBuildings,function(eachBuilding){
	 			if($.inArray(eachBuilding.attributes.BUILDINGID,buildings)!=-1 )
	 				{
	 				numberOfVisitsByUserIDAdmin(eachBuilding.attributes.BUILDINGID);
	 				//alert(numUserAdminVisits);
	 				var userNumVisits4= numUserAdminVisits;
	 				
	 				var polySymbol1 = new esri.symbol.SimpleFillSymbol(
	 					       esri.symbol.SimpleLineSymbol.STYLE_SOLID,
	 					       new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID,
	 					         new dojo.Color([0, 0, 0, 1]), 1),
	 					       new dojo.Color([255, 0, 0, 0.2])
	 					     );
	 				var infoTemplate8 = new esri.InfoTemplate();
	 	        	 infoTemplate8.setTitle(eachBuilding.attributes.BUILDINGID);
	 	        	 var contentv4= "<b>Number Of Visits: </b>"+userNumVisits4;
	 	        	infoTemplate8.setContent(contentv4);
	 	        	if(maxNumVisits4<=userNumVisits4){
	 	        		maxNumVisits4=userNumVisits4;
	 					maxVisitFeature=eachBuilding;
	 					maxContentv3=infoTemplate8;
	 				}
	 				var polyGraphic = new esri.Graphic(eachBuilding.geometry,null,eachBuilding.attributes);;
	 				
	 				polyGraphic.setInfoTemplate(infoTemplate8);
	 				polyGraphic.setSymbol(polySymbol1);
	 				map2.graphics.add(polyGraphic);
	 				}
	 		});
	 		var polySymbol2 = new esri.symbol.SimpleFillSymbol(
	 			       esri.symbol.SimpleLineSymbol.STYLE_SOLID,
	 			       new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID,
	 			         new dojo.Color([0, 0, 0, 1]), 1),
	 			       new dojo.Color([125, 20, 225, 0.6])
	 			     );
	 		if(maxVisitFeature!=null && maxNumVisits4>0){
	          	var graphicLocLast1 = maxVisitFeature;
	          	graphicLocLast1.setSymbol(polySymbol2);
	          	graphicLocLast1.setInfoTemplate(maxContentv3);
	          	map2.graphics.add(graphicLocLast1);
	        	 	}
	 	}
	 	
	 	
	 	function numberOfVisitsByUser(buildingID1){
	 		if(buildingID1=="JA"){
	   			numVisits=featuresJA.length;
	   		}else if(buildingID1=="TD"){
	   			numVisits=featuresTD.length;
	   		}else if(buildingID1=="UB"){
	   			numVisits=featuresUB.length;
	   		}else if(buildingID1=="CD"){
	   			numVisits=featuresCD.length;
	   		}else if(buildingID1=="DB"){
	   			numVisits=featuresDB.length;
	   		}else if(buildingID1=="GG"){
	   			numVisits=featuresGG.length;
	   		}
	 		
	 	}
	 	
	 	function setPoints(){
	 		anChoice="points";
	 	}
	 	function setBuildings(){
	 		anChoice="buildings";
	 		//alert(anChoice);
	 	}
	 	
	 	
	 	
			 	
		
	 	
	   
	 	
	    
	      
	      
