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
		 dojo.require("esri.graphic");
		 dojo.require("esri.symbols.SimpleMarkerSymbol");
		 dojo.require("dojo.on");
		 dojo.require("dojo._base.Color");
	    

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

	
	 