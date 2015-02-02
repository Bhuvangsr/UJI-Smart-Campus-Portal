<%@page import="com.liferay.portlet.polls.service.PollsQuestionLocalServiceUtil"%>
<%@page import="java.util.List"%>
<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>
<%@page import="com.es.uji.init.portlets.UJIPollsDisplayPortlet"%>
<%@page import="com.liferay.portlet.polls.model.PollsQuestion" %>
<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui"%>
<%@ taglib uri="http://liferay.com/tld/portlet" prefix="liferay-portlet" %>
<%@ taglib uri="http://liferay.com/tld/theme" prefix="liferay-theme" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>
<%@ taglib uri="http://liferay.com/tld/util" prefix="liferay-util" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>

<portlet:defineObjects />
<liferay-theme:defineObjects/>
<% Integer count = PollsQuestionLocalServiceUtil.getPollsQuestionsCount();
pageContext.setAttribute("pollsQuestions", count);
List<PollsQuestion> questions = PollsQuestionLocalServiceUtil.getPollsQuestions(0, count);
pageContext.setAttribute("pollsQuestionslist", questions);
%>
<table style="border-color: maroon; border-style: solid; border-spacing: 50pt;">
	<tr bordercolor="maroon" style="border-style: solid;">
      <td bordercolor="maroon" style="border-style: solid;">Question ID</td>
      <td bordercolor="maroon" style="border-style: solid;">Title</td>
      <td bordercolor="maroon" style="border-style: solid;">DeadLine</td>
      <td bordercolor="maroon" style="border-style: solid;">Creator</td>
    </tr>
  
  <c:forEach items="${pollsQuestionslist}" var="pollsQuestion">
    <tr style="border-style: solid;">
      <td style="border-style: solid;"><c:out value="${pollsQuestion.getQuestionId()}" /></td>
      <td style="border-style: solid;"><c:out value="${pollsQuestion.getTitleCurrentValue()}" /></td>
      <td style="border-style: solid;"><c:out value="${pollsQuestion.getLastVoteDate()}" /></td>
      <td style="border-style: solid;"><c:out value="${pollsQuestion.getUserName()}" /></td>
    </tr>
  </c:forEach>
</table>
