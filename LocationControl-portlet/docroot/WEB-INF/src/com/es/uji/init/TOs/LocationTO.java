package com.es.uji.init.TOs;

import java.awt.Point;
import java.util.Calendar;


public class LocationTO {
	private long userID;
	private String userRole;
	private String userOrganisationRole;
	private Calendar TimeStamp;
	private String point;
	public long getUserID() {
		return userID;
	}
	public void setUserID(long l) {
		this.userID = l;
	}
	public String getUserRole() {
		return userRole;
	}
	public void setUserRole(String userRole) {
		this.userRole = userRole;
	}
	public String getUserOrganisationRole() {
		return userOrganisationRole;
	}
	public void setUserOrganisationRole(String userOrganisationRole) {
		this.userOrganisationRole = userOrganisationRole;
	}
	public Calendar getTimeStamp() {
		return TimeStamp;
	}
	public void setTimeStamp(Calendar timeStamp) {
		TimeStamp = timeStamp;
	}
	public String getPoint() {
		return point;
	}
	public void setPoint(String point) {
		this.point = point;
	}
	
	
}
