<%--
    Language Helper — reads session first, then cookie
    Include at top of every JSP: <%@ include file="/WEB-INF/lang.jsp" %>
    Use: <%=hi%>  or  <%=L(hi,"English","हिंदी")%>
--%>
<%
    // Session takes priority (set immediately by LangController)
    // Cookie is fallback (persists across sessions)
    String __lang = "en";
    Object __sessLang = session.getAttribute("hms_lang");
    if (__sessLang != null) {
        __lang = (String) __sessLang;
    } else if (request.getCookies() != null) {
        for (jakarta.servlet.http.Cookie __c : request.getCookies()) {
            if ("hms_lang".equals(__c.getName())) {
                __lang = __c.getValue();
                // Sync to session so next request is faster
                session.setAttribute("hms_lang", __lang);
                break;
            }
        }
    }
    final boolean hi = "hi".equals(__lang);
%>
<%!
    public static String L(boolean isHindi, String en, String hiText) {
        return isHindi ? hiText : en;
    }
%>
