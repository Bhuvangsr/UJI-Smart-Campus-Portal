package com.es.uji.init.portlets;

import java.io.IOException;

import com.es.uji.init.TOs.LocationTO;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.PortletException;
import javax.portlet.PortletRequestDispatcher;
import javax.portlet.ProcessAction;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import com.liferay.portal.kernel.cache.CacheRegistryUtil;
import com.liferay.portal.kernel.cache.MultiVMPoolUtil;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.kernel.webcache.WebCachePoolUtil;
import com.liferay.portal.model.Group;
import com.liferay.portal.model.Role;
import com.liferay.portal.model.RoleConstants;
import com.liferay.portal.model.User;
import com.liferay.portal.model.UserGroup;
import com.liferay.portal.model.UserGroupRole;
import com.liferay.portal.service.GroupLocalServiceUtil;
import com.liferay.portal.service.RoleLocalServiceUtil;
import com.liferay.portal.service.UserGroupRoleLocalServiceUtil;
import com.liferay.portal.service.UserLocalServiceUtil;
import com.liferay.portal.service.persistence.RoleUtil;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.util.bridges.mvc.MVCPortlet;

/**
 * Portlet implementation class LocationControlPortlet
 */
public class LocationControlPortlet extends MVCPortlet {
 
	public static String location;
	public static User userloc;
	public ThemeDisplay themeDisplay;
	private boolean flag = false;
	private static final Set<String> VALUES = new HashSet<String>(Arrays.asList(
		     new String[] {"TD","JA","CD","GG","UB","DB"}));
	private static LocationTO locationTO = new LocationTO();
	private static List<LocationTO> locationTOs = new ArrayList<LocationTO>();
 
	/*public void setLocationsToRoles(UserRole role, ArrayList<Location> locations){
		role.setRoleLocations(locations);
	}
	
	public void setPermissionsToRoles(UserRole role, String[] permissions){
		role.setPermissions(permissions);
	}
	
	public void setRolesToUser(UserCustom user,ArrayList<UserRole> userRoles){
		user.setUserRoles(userRoles);
	}
	
	public void setLocationsToUser(UserCustom user, Location location){
		user.getUserLocations().add(location);
	}
	
	public Location getLastKnownLocationUser(UserCustom user){
		return user.getUserLocations().get(user.getUserLocations().size()-1);
	}*/
	
	@ProcessAction(name = "changeUserRoleByLocation")
	public void changeUserRoleByLocation(ActionRequest actionRequest,ActionResponse actionResponse) throws Exception{
		System.out.println("the role will be changed to the location: "+actionRequest.getParameter("location"));
		System.out.println(" the location object: "+actionRequest.getParameter("locationObj"));
		System.out.println("Trying to fetch the roles");
		location= actionRequest.getParameter("location");
		storeLocation(location);
		retrieveOrganisationRoles();
		
		//if(flag){
			//actionResponse.wait(50);
			//actionResponse.notifyAll();
			//actionResponse.sendRedirect("http://localhost:8080/web/guest/geolocation");
			//actionResponse.sendRedirect("http://localhost:8080/web/guest/geolocation");
			//actionResponse.sendRedirect("http://localhost:8080/web/guest/locationtest");
		//}
		
	}
	
	public static void retrieveOrganisationRoles() throws PortalException{
		try {
			/*List<Role> allAvailRoles = RoleLocalServiceUtil.getRoles( 0, RoleLocalServiceUtil.getRolesCount() );
			for(Role role: allAvailRoles){
				//role.ROLE_ID_ACCESSOR;
				System.out.println(role.getName());
			}*/
			List<Role> listUserRoles =userloc.getRoles();
			
			
			for(Role role: listUserRoles){
				System.out.println("Role types: "+role.getType()+"::"+role.getTypeLabel());
				//role.ROLE_ID_ACCESSOR;
				System.out.println("Current User Role: "+role.getName());
				//Role userRole = RoleServiceUtil.getRole(role.getCompanyId(), "User");
				//UserLocalServiceUtil.deleteRoleUser(userRole.getRoleId(), userloc);
				System.out.println(location);
				//UserServiceUtilImpl.deleteRoleUser(userRole.getRoleId(), userloc.getUserId());
				if(location!=null && (VALUES.contains(location))){
					System.out.println("first barrier");
				if(!role.getName().equalsIgnoreCase(null) && !role.getName().equalsIgnoreCase(location) 
						&& !role.getName().equalsIgnoreCase(RoleConstants.ADMINISTRATOR) && !role.getName().equalsIgnoreCase(RoleConstants.GUEST)){
					System.out.println("second barrier");
					//String newRoleName= location+"_"+role.getName().split("_")[1];
					String newRoleName= location;
					System.out.println(newRoleName);
					System.out.println("companyId"+role.getCompanyId());
					Role newRole = RoleLocalServiceUtil.getRole(role.getCompanyId(), newRoleName);
					RoleUtil.addUser(newRole.getRoleId(), userloc.getUserId());
					RoleUtil.removeUser(role.getRoleId(), userloc.getUserId());
					//UserServiceUtil.deleteRoleUser(role.getRoleId(), userloc.getUserId());
					UserLocalServiceUtil.deleteRoleUser(role.getRoleId(), userloc);
					UserLocalServiceUtil.addRoleUser(newRole.getRoleId(), userloc.getUserId());
					//UserServiceUtil.deleteRoleUser(role.getRoleId(), userloc.getUserId());
					//UserServiceUtil.addRoleUsers(newRole.getRoleId(), userloc.getUserId());
					System.out.println("working till here");
					UserLocalServiceUtil.updateUser(userloc);
					RoleLocalServiceUtil.updateRole(newRole);
					//RoleServiceUtil.updateRole(newRole.getRoleId(), newRoleName, null, null, newRoleName, null);
					/*RoleServiceUtil.updateRole(newRole.getRoleId(), newRole.getName(), newRole.getTitleMap(),
							newRole.getDescriptionMap(), newRole.getSubtype(), serviceContext);*/
					System.out.println("executed success");
					CacheRegistryUtil.clear();
					MultiVMPoolUtil.clear();
					WebCachePoolUtil.clear();
					
					//flag=true;
					
				}
			}
			}
			List<Role> listUserRoles1 =userloc.getRoles();
			for(Role role1:listUserRoles1){
				System.out.println("Updated User Role: "+role1.getName());
			}
		} catch (SystemException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	public static String retrieveCurrentUserRole(User user) throws SystemException, PortalException{
		userloc = user;
		//System.out.println("userloc"+userloc);
		System.out.println("User role after refresh: "+userloc.getRoles().get(0).getName());
		return userloc.getRoles().get(0).getName();
	}
	
	
	public static String retrieveCurrentUserOrganisationRole(User user) throws SystemException, PortalException{
		String organisationRole=null;
		if(user.getOrganizations()!= null && !user.getRoles().get(0).getName().equalsIgnoreCase(RoleConstants.GUEST)){
	List<UserGroupRole> userGroups = UserGroupRoleLocalServiceUtil.getUserGroupRolesByGroup(user.getOrganizations().get(0).getGroupId());
	for(UserGroupRole group: userGroups){
		System.out.println("name of role:"+group.getRole().getName());
		
		if(user.getUserId()==group.getUserId()&&(group.getRole().getName().equalsIgnoreCase("UJIAcademic")||group.getRole().getName().equalsIgnoreCase("UJIMaintenance")
				|| group.getRole().getName().equalsIgnoreCase("UJIVisitor"))){
			organisationRole=group.getRole().getName();
		}
	}}
	return organisationRole;
	}
	
	@Override
	public void doView(RenderRequest request, RenderResponse response)
			throws PortletException, IOException {
		// TODO Auto-generated method stub
		super.doView(request, response);
		themeDisplay = (ThemeDisplay) request.getAttribute(WebKeys.THEME_DISPLAY);
		PortletRequestDispatcher dispatcher = getPortletContext().getRequestDispatcher("view.jsp");
		//dispatcher.include(request,response);
		//response.getCacheControl().setExpirationTime(10);
		//response.getCacheControl().setPublicScope(true);
	}

	public void storeLocation(String location) throws SystemException, PortalException{
		//String locationVal[] = location.split(",");
		//Integer x = Integer.parseInt(locationVal[0]);
		//Integer y = Integer.parseInt(locationVal[1]);
		
		locationTO.setPoint(location);
		locationTO.setUserID(userloc.getUserId());
		locationTO.setTimeStamp(Calendar.getInstance());
		locationTO.setUserOrganisationRole(retrieveCurrentUserOrganisationRole(userloc));
		locationTO.setUserRole(retrieveCurrentUserRole(userloc));
			
		locationTOs.add(locationTO);
		System.out.println("loc"+locationTOs.size());
		
	}
	
	public static long getCurrentTime(){
		System.out.println(Calendar.getInstance().getTimeInMillis()+":  current time");
		return Calendar.getInstance().getTimeInMillis();
	}

}
