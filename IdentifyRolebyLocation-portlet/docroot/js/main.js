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
