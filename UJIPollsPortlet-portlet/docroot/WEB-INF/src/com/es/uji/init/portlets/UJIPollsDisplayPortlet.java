package com.es.uji.init.portlets;

import java.io.IOException;
import java.util.List;

import javax.portlet.PortletException;
import javax.portlet.PortletRequestDispatcher;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import com.liferay.portal.kernel.exception.SystemException;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.theme.ThemeDisplay;
import com.liferay.portlet.polls.model.PollsQuestion;
import com.liferay.portlet.polls.service.PollsQuestionLocalServiceUtil;
import com.liferay.util.bridges.mvc.MVCPortlet;

/**
 * Portlet implementation class UJIPollsDisplayPortlet
 */
public class UJIPollsDisplayPortlet extends MVCPortlet {
	
	public static ThemeDisplay themeDisplay;
 
	public static List<PollsQuestion> getPollsQuestions() throws SystemException{
		List<PollsQuestion> pollsQuestions= PollsQuestionLocalServiceUtil.getQuestions(themeDisplay.getCompanyGroupId());
		//pollsQuestions.get(0).getTitleCurrentValue()()
		
		return pollsQuestions;
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
	
	
}
