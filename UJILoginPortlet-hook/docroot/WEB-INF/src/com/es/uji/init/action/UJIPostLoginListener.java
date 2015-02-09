package com.es.uji.init.action;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.liferay.portal.ModelListenerException;
import com.liferay.portal.kernel.events.Action;
import com.liferay.portal.kernel.events.ActionException;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.model.BaseModelListener;
import com.liferay.portal.model.Group;
import com.liferay.portal.model.Role;
import com.liferay.portal.model.User;
import com.liferay.portal.model.UserGroupRole;
import com.liferay.portal.service.GroupLocalServiceUtil;
import com.liferay.portal.service.RoleLocalServiceUtil;
import com.liferay.portal.service.ServiceContextThreadLocal;
import com.liferay.portal.service.UserGroupLocalServiceUtil;
import com.liferay.portal.service.UserGroupRoleLocalServiceUtil;
import com.liferay.portal.service.UserLocalServiceUtil;
import com.liferay.portal.service.persistence.RoleUtil;
import com.liferay.portal.service.persistence.UserGroupRolePK;
import com.liferay.portal.util.PortalUtil;
import com.liferay.portlet.expando.service.ExpandoValueLocalServiceUtil;

public class UJIPostLoginListener extends BaseModelListener<User> {

	/*@Override
	public void run(HttpServletRequest request, HttpServletResponse response)
			throws ActionException {
		// TODO Auto-generated method stub
		System.out.println("  the user is connected ");
        //ThemeDisplay themeDisplay = (ThemeDisplay)request.getAttribute(WebKeys.THEME_DISPLAY);
        User user;
		try {
			user = PortalUtil.getUser(request);
			String defaultBuildingId=user.getExpandoBridge().getAttribute("ChooseBuildingID").toString();
			String organisationRoleVal=user.getExpandoBridge().getAttribute("UserRole").toString();
			System.out.println("user name "+user.getScreenName());
			System.out.println("Default Building Id "+defaultBuildingId);
			System.out.println("organisation role"+organisationRoleVal);
		} catch (PortalException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SystemException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        

	}**/
	
	@Override
	    public void onAfterCreate(User model) throws ModelListenerException
	    {
	                try
	        {
	           // Group group = GroupLocalServiceUtil.getFriendlyURLGroup(companyId, friendlyUrl);
	            long organizationId = 11781;
	            long[] userIds = new long[] { model.getUserId() };
	            UserLocalServiceUtil.addOrganizationUsers(organizationId, userIds);
	            //UserGroupLocalServiceUtil.addu
	
	            System.out.println("Added user " + model.getLogin() + " (id " + model.getUserId()
	                    + ") to organisation ( Id: " + organizationId + ")");
	            User user;
	            String defaultBuildingId1;
	            String organisationRoleVal1;
	    			user = UserLocalServiceUtil.getUser(model.getUserId());
	    			String defaultBuildingId[]= (String[])user.getExpandoBridge().getAttribute("ChooseBuildingID");
	    			String organisationRoleVal[]=(String[])user.getExpandoBridge().getAttribute("UserRole");
	    			if(defaultBuildingId.length!=0 && organisationRoleVal.length!=0){
	    			defaultBuildingId1 = defaultBuildingId[0];
	    			organisationRoleVal1 = organisationRoleVal[0];
	    			
	    			System.out.println("user name "+user.getScreenName());
	    			System.out.println("Default Building Id "+defaultBuildingId[0]);
	    			System.out.println("organisation role"+organisationRoleVal[0]);
	    			}else{
	    				defaultBuildingId1="CD";
	    				organisationRoleVal1="UJIVisitor";
	    			}
	    			//updateUserRole(defaultBuildingId1, user);
	    			updateOrganisationRole(organisationRoleVal1,user);
	           // ExpandoValueLocalServiceUtil.getData(className, tableName, columnName, classPK)
	        }
	        catch (PortalException exception)
	        {
	            exception.printStackTrace();
	        }
	        catch (SystemException exception)
	        {
	            exception.printStackTrace();
	        }
	   }

	public void updateUserRole(String buildingName, User user1) throws SystemException, PortalException{
		Role newRole = RoleLocalServiceUtil.getRole(10157, buildingName);
		RoleUtil.addUser(newRole.getRoleId(), user1.getUserId());
		//RoleUtil.removeUser(role.getRoleId(), user.getUserId());
		//UserServiceUtil.deleteRoleUser(role.getRoleId(), userloc.getUserId());
		//UserLocalServiceUtil.deleteRoleUser(role.getRoleId(), userloc);
		UserLocalServiceUtil.addRoleUser(newRole.getRoleId(), user1.getUserId());
		//UserServiceUtil.deleteRoleUser(role.getRoleId(), userloc.getUserId());
		//UserServiceUtil.addRoleUsers(newRole.getRoleId(), userloc.getUserId());
		//System.out.println("working till here");
		//UserLocalServiceUtil.updateUser(user1);
		//UserLocalServiceUtil.addUser(user1);
		RoleLocalServiceUtil.updateRole(newRole);

	}
	
	public void updateOrganisationRole(String organisationRoleName,User user2) throws SystemException{
		long roleId = 12730;
		long groupId=11782;
		if(organisationRoleName.equalsIgnoreCase("UJIAcademic")){
			roleId=12730;
		}else if(organisationRoleName.equalsIgnoreCase("UJIMaintenance")){
			roleId=12732;
		}else if(organisationRoleName.equalsIgnoreCase("UJIVisitor")){
			roleId=12731;
		}
		System.out.println("new user organisation role: "+roleId);
		long roleIds[] = new long[1];
		roleIds[0]=roleId;
		//List<UserGroupRole> groupRoles = UserGroupRoleLocalServiceUtil.getUserGroupRolesByGroupAndRole(groupId, roleId);
		//UserGroupRole groupRole = groupRoles.get(0);
		UserGroupRoleLocalServiceUtil.addUserGroupRoles(user2.getUserId(), groupId, roleIds);
	}

}
