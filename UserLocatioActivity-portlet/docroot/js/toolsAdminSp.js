	function setadminPoints(){
		//$('input[name=userIdRb]').attr("disabled",false);
	 		anChoice2="points";
	 	}
	 	function setadminBuildings(){
	 		//$('input[name=userIdRb]').attr("disabled",true);
	 		anChoice2="buildings";
	 		//alert(anChoice);
	 	}
	 	
	 	
	 	
	 	function displayadminMapBuildings(buildings4){
	 		//alert(adminfeaturesAnalytics.length);
	 		var featuresSelectBuildings=[];
 		  	dojo.forEach(adminfeaturesAnalytics,function(feature){
 		  		//alert($.inArray(feature.attributes.UserRole,buildings));
 		  		if($.inArray(feature.attributes.UserRole,buildings4)!=-1 )
 		  			{
 		  			featuresSelectBuildings.push(feature);
 		  			}
 		  	});
 		  	//alert(featuresSelectBuildings.length);
 		  	showAdminPointsOnMap(featuresSelectBuildings);
	 	}
	 	
	 	function showadminPolygonsOnMap(buildings){
	 		if(userIdSelect =="All"){
	 			displayPolygonsAdmin(buildings);
	 		}else{
	 			
	 			extractUserIdStats(userIdSelect);
	 			displayPolygonsAdminUser(buildings);
	 		}
	 		
	 	}
	 	
	 	function showAdminPointsOnMap(featuresSelectBuildings1){
	 		//alert(featuresSelectBuildings1.length);
	 		var symbol1  = new esri.symbol.SimpleMarkerSymbol().setSize(5).setColor(new dojo.Color([255,0,0]));
	         	var symbol2  = new esri.symbol.SimpleMarkerSymbol().setSize(8).setColor(new dojo.Color([55,102,164]));
	         	var compare_date = 0;
	         	var content2;
	         	var lastKnownFeature;
	         	//alert(userIdSelect);
	         	//QueryTask returns a featureSet.  Loop through features in the featureSet and add them to the map.
	         	if(userIdSelect =="All"){
	         	dojo.forEach(featuresSelectBuildings1,function(feature){ 
	         		//alert(feature.attributes.UserID);
		           // if(feature.attributes.UserID==$("#userID").val()){
		            	
		            
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
		        //    }
	         	});}else if(userIdSelect =="AllAcademic"){
	         		dojo.forEach(featuresSelectBuildings1,function(feature){ 
		         		
			            if($.inArray(feature.attributes.UserID,academicUsers)!=-1){		            
			            var graphicmis11 = new esri.Graphic(feature.geometry,null,feature.attributes);  
			          	graphicmis11.setSymbol(symbol1);  
			          	var infoTemplate21 = new esri.InfoTemplate();
			        	 infoTemplate21.setTitle(feature.attributes.UserID);
		          		var date_visit= new Date(feature.attributes.TimeStamp).toUTCString();
		          		var content11= "<b>User Role name: </b>"+feature.attributes.UserRole+
		          		"<br/><b>Organisation Role :</b>"+feature.attributes.UserOrganisationRole+
		          		"</b><br/><b>Visited Time :</b>"+date_visit+"</b>";
		          		var attributesGraphic11= {"User Role name":feature.attributes.UserRole,
		          		"Organisation Role":feature.attributes.UserOrganisationRole,
		          		"Visited Time":date_visit};
		          		infoTemplate21.setContent(content11);
		          		if(compare_date<feature.attributes.TimeStamp){
			          		compare_date=feature.attributes.TimeStamp;
			          		content2=infoTemplate21;
			          		lastKnownFeature = new esri.Graphic(feature.geometry,null,feature.attributes);
			          	}
		          		
		          		graphicmis11.setInfoTemplate(infoTemplate21);
		          		graphicmis11.setAttributes(attributesGraphic11);
		         		map2.graphics.add(graphicmis11);
		         		features.push(feature.geometry);
		          		featuresAnalytics.push(graphicmis11);  
			            }
		         	});
	         	}else if(userIdSelect =="AllMaintenance"){
	         		dojo.forEach(featuresSelectBuildings1,function(feature){ 
		         		//alert(feature.attributes.UserID);
		         		//alert(maintenanceUsers);
	         			if($.inArray(feature.attributes.UserID,maintenanceUsers)!=-1){
			            	
			            
			            var graphicmis12 = new esri.Graphic(feature.geometry,null,feature.attributes);  
			          	graphicmis12.setSymbol(symbol1);  
			          	var infoTemplate22 = new esri.InfoTemplate();
			        	 infoTemplate22.setTitle(feature.attributes.UserID);
		          		var date_visit= new Date(feature.attributes.TimeStamp).toUTCString();
		          		var content12= "<b>User Role name: </b>"+feature.attributes.UserRole+
		          		"<br/><b>Organisation Role :</b>"+feature.attributes.UserOrganisationRole+
		          		"</b><br/><b>Visited Time :</b>"+date_visit+"</b>";
		          		var attributesGraphic12= {"User Role name":feature.attributes.UserRole,
		          		"Organisation Role":feature.attributes.UserOrganisationRole,
		          		"Visited Time":date_visit};
		          		infoTemplate22.setContent(content12);
		          		if(compare_date<feature.attributes.TimeStamp){
			          		compare_date=feature.attributes.TimeStamp;
			          		content2=infoTemplate22;
			          		lastKnownFeature = new esri.Graphic(feature.geometry,null,feature.attributes);
			          	}
		          		
		          		graphicmis12.setInfoTemplate(infoTemplate22);
		          		graphicmis12.setAttributes(attributesGraphic12);
		         		map2.graphics.add(graphicmis12);
		         		features.push(feature.geometry);
		          		featuresAnalytics.push(graphicmis12);  
			            }
		         	});
	         	}else if(userIdSelect =="AllVisitor"){
	         		dojo.forEach(featuresSelectBuildings1,function(feature){ 
		         		//alert(feature.attributes.UserID);
	         			if($.inArray(feature.attributes.UserID,visitorUsers)!=-1){
			            	
			            
			            var graphicmis13 = new esri.Graphic(feature.geometry,null,feature.attributes);  
			          	graphicmis13.setSymbol(symbol1);  
			          	var infoTemplate23 = new esri.InfoTemplate();
			        	 infoTemplate23.setTitle(feature.attributes.UserID);
		          		var date_visit= new Date(feature.attributes.TimeStamp).toUTCString();
		          		var content13= "<b>User Role name: </b>"+feature.attributes.UserRole+
		          		"<br/><b>Organisation Role :</b>"+feature.attributes.UserOrganisationRole+
		          		"</b><br/><b>Visited Time :</b>"+date_visit+"</b>";
		          		var attributesGraphic13= {"User Role name":feature.attributes.UserRole,
		          		"Organisation Role":feature.attributes.UserOrganisationRole,
		          		"Visited Time":date_visit};
		          		infoTemplate23.setContent(content13);
		          		if(compare_date<feature.attributes.TimeStamp){
			          		compare_date=feature.attributes.TimeStamp;
			          		content2=infoTemplate23;
			          		lastKnownFeature = new esri.Graphic(feature.geometry,null,feature.attributes);
			          	}
		          		
		          		graphicmis13.setInfoTemplate(infoTemplate23);
		          		graphicmis13.setAttributes(attributesGraphic13);
		         		map2.graphics.add(graphicmis13);
		         		features.push(feature.geometry);
		          		featuresAnalytics.push(graphicmis13);  
			            }
		         	});
	         	}else{
	         		dojo.forEach(featuresSelectBuildings1,function(feature){ 
			            if(feature.attributes.UserID==userIdSelect){
			            	
			            
			            var graphicmis14 = new esri.Graphic(feature.geometry,null,feature.attributes);  
			          	graphicmis14.setSymbol(symbol1);  
			          	var infoTemplate24 = new esri.InfoTemplate();
			        	 infoTemplate24.setTitle(feature.attributes.UserID);
		          		var date_visit= new Date(feature.attributes.TimeStamp).toUTCString();
		          		var content14= "<b>User Role name: </b>"+feature.attributes.UserRole+
		          		"<br/><b>Organisation Role :</b>"+feature.attributes.UserOrganisationRole+
		          		"</b><br/><b>Visited Time :</b>"+date_visit+"</b>";
		          		var attributesGraphic14= {"User Role name":feature.attributes.UserRole,
		          		"Organisation Role":feature.attributes.UserOrganisationRole,
		          		"Visited Time":date_visit};
		          		infoTemplate24.setContent(content14);
		          		if(compare_date<feature.attributes.TimeStamp){
			          		compare_date=feature.attributes.TimeStamp;
			          		content2=infoTemplate24;
			          		lastKnownFeature = new esri.Graphic(feature.geometry,null,feature.attributes);
			          	}
		          		
		          		graphicmis14.setInfoTemplate(infoTemplate24);
		          		graphicmis14.setAttributes(attributesGraphic14);
		         		map2.graphics.add(graphicmis14);
		         		features.push(feature.geometry);
		          		featuresAnalytics.push(graphicmis14);  
			            }
		         	});
	         	}
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
	 	
	 	function displayPolygonsAdmin(buildings5){
	 		var maxNumVisits1=0;
	 		var maxVisitFeature1;
	 		var maxContent1;
	 		dojo.forEach(allBuildings,function(eachBuilding){
	 			if($.inArray(eachBuilding.attributes.BUILDINGID,buildings5)!=-1 )
	 				{
	 				numberOfVisitsByUserAdmin(eachBuilding.attributes.BUILDINGID);
	 				var userNumVisits1= numAdminVisits;
	 				
	 				var polySymbol1 = new esri.symbol.SimpleFillSymbol(
	 					       esri.symbol.SimpleLineSymbol.STYLE_SOLID,
	 					       new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID,
	 					         new dojo.Color([0, 0, 0, 1]), 1),
	 					       new dojo.Color([255, 0, 0, 0.2])
	 					     );
	 				var infoTemplate4 = new esri.InfoTemplate();
	 	        	 infoTemplate4.setTitle(eachBuilding.attributes.BUILDINGID);
	 	        	 var content4= "<b>Number Of Visits: </b>"+userNumVisits1;
	 	        	infoTemplate4.setContent(content4);
	 	        	if(maxNumVisits1<=userNumVisits1){
	 					maxNumVisits1=userNumVisits1;
	 					maxVisitFeature1=eachBuilding;
	 					maxContent1=infoTemplate4;
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
	 		if(maxVisitFeature1!=null && maxNumVisits1!=0){
	          	var graphicLocLast1 = maxVisitFeature1;
	          	graphicLocLast1.setSymbol(polySymbol2);
	          	graphicLocLast1.setInfoTemplate(maxContent1);
	          	map2.graphics.add(graphicLocLast1);
	        	 	}
	 		
	 	}
	 	
	 	function displayPolygonsAdminUser(buildings6){
	 		var maxNumVisits=0;
	 		var maxVisitFeature;
	 		var maxContent;
	 		dojo.forEach(allBuildings,function(eachBuilding){
	 			if($.inArray(eachBuilding.attributes.BUILDINGID,buildings6)!=-1 )
	 				{
	 				numberOfVisitsByUserIDAdmin(eachBuilding.attributes.BUILDINGID);
	 				var userNumVisits= numUserAdminVisits;
	 				
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
	 		if(maxVisitFeature!=null && maxNumVisits!=0){
	          	var graphicLocLast1 = maxVisitFeature;
	          	graphicLocLast1.setSymbol(polySymbol2);
	          	graphicLocLast1.setInfoTemplate(maxContent);
	          	map2.graphics.add(graphicLocLast1);
	        	 	}
	 		
	 	}
	 	
	 	
	 	function numberOfVisitsByUserAdmin(buildingID1){
	 		if(buildingID1=="JA"){
	 			numAdminVisits=adminfeaturesJA.length;
	   		}else if(buildingID1=="TD"){
	   			numAdminVisits=adminfeaturesTD.length;
	   		}else if(buildingID1=="UB"){
	   			numAdminVisits=adminfeaturesUB.length;
	   		}else if(buildingID1=="CD"){
	   			numAdminVisits=adminfeaturesCD.length;
	   		}else if(buildingID1=="DB"){
	   			numAdminVisits=adminfeaturesDB.length;
	   		}else if(buildingID1=="GG"){
	   			numAdminVisits=adminfeaturesGG.length;
	   		}
	 	}
	 	
	 	function numberOfVisitsByUserAdminDates(buildingID1){
	 		if(buildingID1=="JA"){
	 			numAdminVisits=adminfeaturesDatesJA.length;
	   		}else if(buildingID1=="TD"){
	   			numAdminVisits=adminfeaturesDatesTD.length;
	   		}else if(buildingID1=="UB"){
	   			numAdminVisits=adminfeaturesDatesUB.length;
	   		}else if(buildingID1=="CD"){
	   			numAdminVisits=adminfeaturesDatesCD.length;
	   		}else if(buildingID1=="DB"){
	   			numAdminVisits=adminfeaturesDatesDB.length;
	   		}else if(buildingID1=="GG"){
	   			numAdminVisits=adminfeaturesDatesGG.length;
	   		}
	 	}
	 	

	 	
	 	function numberOfVisitsByUserIDAdmin(buildingID1){
	 		if(buildingID1=="JA"){
	 			numUserAdminVisits=featuresJAID.length;
	 			//featuresJAID=[];
	   		}else if(buildingID1=="TD"){
	   			numUserAdminVisits=featuresTDID.length;
	   			//featuresTDID=[];
	   		}else if(buildingID1=="UB"){
	   			numUserAdminVisits=featuresUBID.length;
	   			//featuresUBID=[];
	   		}else if(buildingID1=="CD"){
	   			numUserAdminVisits=featuresCDID.length;
	   			//featuresCDID=[];
	   		}else if(buildingID1=="DB"){
	   			numUserAdminVisits=featuresDBID.length;
	   			//featuresDBID=[];
	   		}else if(buildingID1=="GG"){
	   			numUserAdminVisits=featuresGGID.length;
	   			//featuresGGID=[];
	   		}
	 	}
	 	
	 	function extractUserIdStats(userIdOption){
	 		var featuresSelectBuildings=[];
	 		featuresJAID=[];
	 		featuresTDID=[];
	 		featuresUBID=[];
	 		featuresCDID=[];
	 		featuresDBID=[];
	 		featuresGGID=[];
	 		//alert(userIdOption);
	 		//alert(academicUsers);
 		  	dojo.forEach(adminfeaturesAnalytics,function(feature){
 		  		if(userIdOption=="AllAcademic"){
 		  			if($.inArray(feature.attributes.UserID,academicUsers)!=-1)
		  			{
		  			featuresSelectBuildings.push(feature);
		  			if(feature.attributes.UserRole=="JA"){
		      			featuresJAID.push(feature);
		      		}else if(feature.attributes.UserRole=="TD"){
		      			//alert("123");
		      			featuresTDID.push(feature);
		      		}else if(feature.attributes.UserRole=="UB"){
		      			featuresUBID.push(feature);
		      		}else if(feature.attributes.UserRole=="CD"){
		      			featuresCDID.push(feature);
		      		}else if(feature.attributes.UserRole=="DB"){
		      			featuresDBID.push(feature);
		      		}else if(feature.attributes.UserRole=="GG"){
		      			featuresGGID.push(feature);
		      		}
		  			}
 		  		}else if(userIdOption=="AllMaintenance"){
 		  			if($.inArray(feature.attributes.UserID,maintenanceUsers)!=-1)
		  			{
		  			featuresSelectBuildings.push(feature);
		  			if(feature.attributes.UserRole=="JA"){
		      			featuresJAID.push(feature);
		      		}else if(feature.attributes.UserRole=="TD"){
		      			//alert("123");
		      			featuresTDID.push(feature);
		      		}else if(feature.attributes.UserRole=="UB"){
		      			featuresUBID.push(feature);
		      		}else if(feature.attributes.UserRole=="CD"){
		      			featuresCDID.push(feature);
		      		}else if(feature.attributes.UserRole=="DB"){
		      			featuresDBID.push(feature);
		      		}else if(feature.attributes.UserRole=="GG"){
		      			featuresGGID.push(feature);
		      		}
		  			}
 		  		}else if(userIdOption=="AllVisitor"){
 		  			if($.inArray(feature.attributes.UserID,visitorUsers)!=-1)
		  			{
		  			featuresSelectBuildings.push(feature);
		  			if(feature.attributes.UserRole=="JA"){
		      			featuresJAID.push(feature);
		      		}else if(feature.attributes.UserRole=="TD"){
		      			//alert("123");
		      			featuresTDID.push(feature);
		      		}else if(feature.attributes.UserRole=="UB"){
		      			featuresUBID.push(feature);
		      		}else if(feature.attributes.UserRole=="CD"){
		      			featuresCDID.push(feature);
		      		}else if(feature.attributes.UserRole=="DB"){
		      			featuresDBID.push(feature);
		      		}else if(feature.attributes.UserRole=="GG"){
		      			featuresGGID.push(feature);
		      		}
		  			}
 		  		}else{
 		  		if(feature.attributes.UserID==userIdOption )
		  			{
		  			featuresSelectBuildings.push(feature);
		  			if(feature.attributes.UserRole=="JA"){
		      			featuresJAID.push(feature);
		      		}else if(feature.attributes.UserRole=="TD"){
		      			//alert("123");
		      			featuresTDID.push(feature);
		      		}else if(feature.attributes.UserRole=="UB"){
		      			featuresUBID.push(feature);
		      		}else if(feature.attributes.UserRole=="CD"){
		      			featuresCDID.push(feature);
		      		}else if(feature.attributes.UserRole=="DB"){
		      			featuresDBID.push(feature);
		      		}else if(feature.attributes.UserRole=="GG"){
		      			featuresGGID.push(feature);
		      		}
		  			}
 		  		}
 		  		});
 		  	
 		  	
	 	}
	 	
	 	function displayadminMapBuildingsDates(buildings9){
	 		//alert(adminfeaturesAnalytics.length);
	 		var featuresSelectBuildings=[];
	 		//alert(startAdminDateTimeStamp);
	 		//alert(endAdminDateTimeStamp);
 		  	dojo.forEach(adminfeaturesAnalytics,function(feature){
 		  		
 		  		if($.inArray(feature.attributes.UserRole,buildings9)!=-1){
 		  			//alert(feature.attributes.TimeStamp);
 		  			if(feature.attributes.TimeStamp>=startAdminDateTimeStamp && feature.attributes.TimeStamp<=endAdminDateTimeStamp)
 		  			{
 		  			featuresSelectBuildings.push(feature);
 		  			}
 		  		}
 		  	});
 		  	
 		  	//alert(featuresSelectBuildings.length);
 		  	showAdminPointsOnMap(featuresSelectBuildings);
	 	}
	 	
	 	function showadminPolygonsOnMapDates(buildings){
	 		if(userIdSelect =="All"){
	 			extractUserIdStatsAdminDates();
	 			displayPolygonsAdminDates(buildings);
	 		}else{
	 			
	 			extractUserIdStatsDates(userIdSelect);
	 			displayPolygonsAdminUserDates(buildings);
	 		}
	 		
	 	}
	 	
	 	function extractUserIdStatsDates(userIdOption){
	 		var featuresSelectBuildings=[];
	 		featuresJAID=[];
	 		featuresTDID=[];
	 		featuresUBID=[];
	 		featuresCDID=[];
	 		featuresDBID=[];
	 		featuresGGID=[];
	 		//alert(userIdOption);
 		  	dojo.forEach(adminfeaturesAnalytics,function(feature){
 		  		if(userIdOption=="AllAcademic"){
 		  		if($.inArray(feature.attributes.UserID,academicUsers)!=-1 &&(feature.attributes.TimeStamp>=startAdminDateTimeStamp && feature.attributes.TimeStamp<=endAdminDateTimeStamp))
		  			{
		  			featuresSelectBuildings.push(feature);
		  			if(feature.attributes.UserRole=="JA"){
		      			featuresJAID.push(feature);
		      		}else if(feature.attributes.UserRole=="TD"){
		      			//alert("123");
		      			featuresTDID.push(feature);
		      		}else if(feature.attributes.UserRole=="UB"){
		      			featuresUBID.push(feature);
		      		}else if(feature.attributes.UserRole=="CD"){
		      			featuresCDID.push(feature);
		      		}else if(feature.attributes.UserRole=="DB"){
		      			featuresDBID.push(feature);
		      		}else if(feature.attributes.UserRole=="GG"){
		      			featuresGGID.push(feature);
		      		}
		  			}
 		  		}else if(userIdOption=="AllMaintenance"){
 		  		if($.inArray(feature.attributes.UserID,maintenanceUsers)!=-1 &&(feature.attributes.TimeStamp>=startAdminDateTimeStamp && feature.attributes.TimeStamp<=endAdminDateTimeStamp))
		  			{
		  			featuresSelectBuildings.push(feature);
		  			if(feature.attributes.UserRole=="JA"){
		      			featuresJAID.push(feature);
		      		}else if(feature.attributes.UserRole=="TD"){
		      			//alert("123");
		      			featuresTDID.push(feature);
		      		}else if(feature.attributes.UserRole=="UB"){
		      			featuresUBID.push(feature);
		      		}else if(feature.attributes.UserRole=="CD"){
		      			featuresCDID.push(feature);
		      		}else if(feature.attributes.UserRole=="DB"){
		      			featuresDBID.push(feature);
		      		}else if(feature.attributes.UserRole=="GG"){
		      			featuresGGID.push(feature);
		      		}
		  			}
 		  		}else if(userIdOption=="AllVisitor"){
 		  		if($.inArray(feature.attributes.UserID,visitorUsers)!=-1 &&(feature.attributes.TimeStamp>=startAdminDateTimeStamp && feature.attributes.TimeStamp<=endAdminDateTimeStamp))
		  			{
		  			featuresSelectBuildings.push(feature);
		  			if(feature.attributes.UserRole=="JA"){
		      			featuresJAID.push(feature);
		      		}else if(feature.attributes.UserRole=="TD"){
		      			//alert("123");
		      			featuresTDID.push(feature);
		      		}else if(feature.attributes.UserRole=="UB"){
		      			featuresUBID.push(feature);
		      		}else if(feature.attributes.UserRole=="CD"){
		      			featuresCDID.push(feature);
		      		}else if(feature.attributes.UserRole=="DB"){
		      			featuresDBID.push(feature);
		      		}else if(feature.attributes.UserRole=="GG"){
		      			featuresGGID.push(feature);
		      		}
		  			}
 		  		}else{
 		  		if(feature.attributes.UserID==userIdOption &&(feature.attributes.TimeStamp>=startAdminDateTimeStamp && feature.attributes.TimeStamp<=endAdminDateTimeStamp))
		  			{
		  			featuresSelectBuildings.push(feature);
		  			if(feature.attributes.UserRole=="JA"){
		      			featuresJAID.push(feature);
		      		}else if(feature.attributes.UserRole=="TD"){
		      			//alert("123");
		      			featuresTDID.push(feature);
		      		}else if(feature.attributes.UserRole=="UB"){
		      			featuresUBID.push(feature);
		      		}else if(feature.attributes.UserRole=="CD"){
		      			featuresCDID.push(feature);
		      		}else if(feature.attributes.UserRole=="DB"){
		      			featuresDBID.push(feature);
		      		}else if(feature.attributes.UserRole=="GG"){
		      			featuresGGID.push(feature);
		      		}
		  			}
 		  		}
		  	});
 		  	
 		  	
	 	}
	 	
	 	function extractUserIdStatsDates1(userIdOption){
	 		var featuresSelectBuildings=[];
	 		featuresJAID=[];
	 		featuresTDID=[];
	 		featuresUBID=[];
	 		featuresCDID=[];
	 		featuresDBID=[];
	 		featuresGGID=[];
 		  	dojo.forEach(adminfeaturesAnalytics,function(feature){
 		  		if(feature.attributes.UserID==userIdOption &&(feature.attributes.TimeStamp>=startUserDateTimeStamp && feature.attributes.TimeStamp<=endUserDateTimeStamp))
		  			{
		  			featuresSelectBuildings.push(feature);
		  			if(feature.attributes.UserRole=="JA"){
		      			featuresJAID.push(feature);
		      		}else if(feature.attributes.UserRole=="TD"){
		      			//alert("123");
		      			featuresTDID.push(feature);
		      		}else if(feature.attributes.UserRole=="UB"){
		      			featuresUBID.push(feature);
		      		}else if(feature.attributes.UserRole=="CD"){
		      			featuresCDID.push(feature);
		      		}else if(feature.attributes.UserRole=="DB"){
		      			featuresDBID.push(feature);
		      		}else if(feature.attributes.UserRole=="GG"){
		      			featuresGGID.push(feature);
		      		}
		  			}
		  	});
 		  	
	 	}
	 	
	 	function extractUserIdStatsAdminDates(){
	 		var featuresSelectBuildings=[];
	 		adminfeaturesDatesJA = [];
	 		adminfeaturesDatesTD = [];
	 		adminfeaturesDatesCD = [];
	 		adminfeaturesDatesGG = [];
	 		adminfeaturesDatesDB = [];
	 		adminfeaturesDatesUB = [];
	 		  
 		  	dojo.forEach(adminfeaturesAnalytics,function(feature){
 		  		if(feature.attributes.TimeStamp>=startAdminDateTimeStamp && feature.attributes.TimeStamp<=endAdminDateTimeStamp)
		  			{
		  			featuresSelectBuildings.push(feature);
		  			if(feature.attributes.UserRole=="JA"){
		  				adminfeaturesDatesJA.push(feature);
		      		}else if(feature.attributes.UserRole=="TD"){
		      			//alert("123");
		      			adminfeaturesDatesTD.push(feature);
		      		}else if(feature.attributes.UserRole=="UB"){
		      			adminfeaturesDatesUB.push(feature);
		      		}else if(feature.attributes.UserRole=="CD"){
		      			adminfeaturesDatesCD.push(feature);
		      		}else if(feature.attributes.UserRole=="DB"){
		      			adminfeaturesDatesDB.push(feature);
		      		}else if(feature.attributes.UserRole=="GG"){
		      			adminfeaturesDatesGG.push(feature);
		      		}
		  			}
		  	});
 		  	
	 	}
	 	
	 	function displayPolygonsAdminDates(buildings7){
	 		var maxNumVisits1=0;
	 		var maxVisitFeature1;
	 		var maxContentv1;
	 		dojo.forEach(allBuildings,function(eachBuilding){
	 			if($.inArray(eachBuilding.attributes.BUILDINGID,buildings7)!=-1 )
	 				{
	 				numberOfVisitsByUserAdminDates(eachBuilding.attributes.BUILDINGID);
	 				var userNumVisits3= numAdminVisits;				
	 				var polySymbol3 = new esri.symbol.SimpleFillSymbol(
	 					       esri.symbol.SimpleLineSymbol.STYLE_SOLID,
	 					       new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID,
	 					         new dojo.Color([0, 0, 0, 1]), 1),
	 					       new dojo.Color([255, 0, 0, 0.2])
	 					     );
	 				var infoTemplateV1 = new esri.InfoTemplate();
	 				infoTemplateV1.setTitle(eachBuilding.attributes.BUILDINGID);
	 	        	 var contentv1= "<b>Number Of Visits: </b>"+userNumVisits3;
	 	        	infoTemplateV1.setContent(contentv1);
	 	        	if(maxNumVisits1<=userNumVisits3){
	 					maxNumVisits1=userNumVisits3;
	 					maxVisitFeature1=eachBuilding;
	 					maxContentv1=infoTemplateV1;
	 				}
	 				var polyGraphic = new esri.Graphic(eachBuilding.geometry,null,eachBuilding.attributes);;
	 				
	 				polyGraphic.setInfoTemplate(infoTemplateV1);
	 				polyGraphic.setSymbol(polySymbol3);
	 				map2.graphics.add(polyGraphic);
	 				}
	 		});
	 		var polySymbol2 = new esri.symbol.SimpleFillSymbol(
	 			       esri.symbol.SimpleLineSymbol.STYLE_SOLID,
	 			       new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID,
	 			         new dojo.Color([0, 0, 0, 1]), 1),
	 			       new dojo.Color([125, 20, 225, 0.6])
	 			     );
	 		if(maxVisitFeature1!=null && maxNumVisits1!=0){
	          	var graphicLocLast1 = maxVisitFeature1;
	          	graphicLocLast1.setSymbol(polySymbol2);
	          	graphicLocLast1.setInfoTemplate(maxContentv1);
	          	map2.graphics.add(graphicLocLast1);
	        	 	}
	 		
	 	}
	 	
	 	function displayPolygonsAdminUserDates(buildings8){
	 		var maxNumVisits=0;
	 		var maxVisitFeature;
	 		var maxContentv2;
	 		dojo.forEach(allBuildings,function(eachBuilding){
	 			if($.inArray(eachBuilding.attributes.BUILDINGID,buildings8)!=-1 )
	 				{
	 				numberOfVisitsByUserIDAdmin(eachBuilding.attributes.BUILDINGID);
	 				var userNumVisits4= numUserAdminVisits;
	 				
	 				var polySymbol1 = new esri.symbol.SimpleFillSymbol(
	 					       esri.symbol.SimpleLineSymbol.STYLE_SOLID,
	 					       new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID,
	 					         new dojo.Color([0, 0, 0, 1]), 1),
	 					       new dojo.Color([255, 0, 0, 0.2])
	 					     );
	 				var infoTemplatev2 = new esri.InfoTemplate();
	 				infoTemplatev2.setTitle(eachBuilding.attributes.BUILDINGID);
	 	        	 var contentv2= "<b>Number Of Visits: </b>"+userNumVisits4;
	 	        	infoTemplatev2.setContent(contentv2);
	 	        	if(maxNumVisits<=userNumVisits4){
	 					maxNumVisits=userNumVisits4;
	 					maxVisitFeature=eachBuilding;
	 					maxContentv2=infoTemplatev2;
	 				}
	 				var polyGraphic = new esri.Graphic(eachBuilding.geometry,null,eachBuilding.attributes);;
	 				
	 				polyGraphic.setInfoTemplate(infoTemplatev2);
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
	 		if(maxVisitFeature!=null && maxNumVisits!=0){
	          	var graphicLocLast1 = maxVisitFeature;
	          	graphicLocLast1.setSymbol(polySymbol2);
	          	graphicLocLast1.setInfoTemplate(maxContentv2);
	          	map2.graphics.add(graphicLocLast1);
	        	 	}
	 		
	 	}
	 	
	 	
	 	function generateHeatMap(){
	 		var infoTemplate31 = new esri.InfoTemplate("Attributes",
	          "BuildingName: ${UserRole}");
	 		var serviceURL = "http://services1.arcgis.com/k8WRSCmxGgCwZufI/ArcGIS/rest/services/UserLocationTracking/FeatureServer/0";
	        var heatmapFeatureLayerOptions = {
	          mode: esri.layers.FeatureLayer.MODE_SNAPSHOT,
	          outFields: ["*"],
	          infoTemplate: infoTemplate31
	        };
	        var heatmapFeatureLayer = new esri.layers.FeatureLayer(serviceURL, heatmapFeatureLayerOptions);

	        var heatmapRenderer = new esri.renderers.HeatmapRenderer({
	          blurRadius: 10,
	          maxPixelIntensity: 100,
	          minPixelIntensity: 0
	        });

	        heatmapFeatureLayer.setRenderer(heatmapRenderer);
	        map2.addLayer(heatmapFeatureLayer);

	 	}
	 	
