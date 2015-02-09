package com.es.uji.init.action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.liferay.portal.model.User;
import com.liferay.portal.security.auth.AutoLogin;
import com.liferay.portal.security.auth.AutoLoginException;
import com.liferay.portal.service.UserLocalServiceUtil;
import com.liferay.portal.util.PortalUtil;

public class VisitorLogin implements AutoLogin {

	@Override
	public String[] handleException(HttpServletRequest request,
			HttpServletResponse response, Exception e)
			throws AutoLoginException {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String[] login(HttpServletRequest request,
			HttpServletResponse response) throws AutoLoginException {
		// TODO Auto-generated method stub
		String visitorName = request.getParameter("ujiVisitor");
		System.out.println(visitorName);
        if (visitorName == null || visitorName.isEmpty()){
            return null;
	}else if(visitorName.equalsIgnoreCase("abc3")){
        try {
        	
            long companyId = PortalUtil.getCompanyId(request);
            User user = UserLocalServiceUtil.getUserByScreenName(companyId,visitorName);
            return new String[] { String.valueOf(user.getUserId()),user.getPassword(),String.valueOf(user.isPasswordEncrypted()) };
        } catch (Exception e) {
            return null;
        }

	}else{
		return null;
	}
	}

}
