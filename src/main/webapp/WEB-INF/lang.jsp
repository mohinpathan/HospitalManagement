<%--
    Language Helper — MUST be included with <%@ include file="/WEB-INF/lang.jsp" %>
    This runs fresh on EVERY request (static include = inlined at compile time, runs at request time)
    
    After include, use:
        <%=hi%>                          — true if Hindi
        <%=L(hi,"English","हिंदी")%>    — returns correct language text
--%>
<%
    /*
     * Read language preference:
     * 1. Session attribute (set immediately by LangController on click)
     * 2. Cookie (persists across browser sessions)
     * 3. Default: English
     */
    String __lang = "en";

    // Check session first — most reliable for immediate switch
    Object __sl = session.getAttribute("hms_lang");
    if (__sl instanceof String && (((String)__sl).equals("hi") || ((String)__sl).equals("en"))) {
        __lang = (String) __sl;
    } else {
        // Fall back to cookie
        jakarta.servlet.http.Cookie[] __cks = request.getCookies();
        if (__cks != null) {
            for (jakarta.servlet.http.Cookie __ck : __cks) {
                if ("hms_lang".equals(__ck.getName())) {
                    String __cv = __ck.getValue();
                    if ("hi".equals(__cv) || "en".equals(__cv)) {
                        __lang = __cv;
                        // Sync to session for next request
                        session.setAttribute("hms_lang", __lang);
                    }
                    break;
                }
            }
        }
    }

    // Make available as page-scoped variable
    final boolean hi = "hi".equals(__lang);
    pageContext.setAttribute("currentLang", __lang);
%>
<%!
    /**
     * Translation helper — call as L(hi, "English text", "हिंदी टेक्स्ट")
     * Also available as t() — both work identically
     */
    public static String L(boolean isHindi, String en, String hiText) {
        return isHindi ? hiText : en;
    }
    /** Alias for L() — some pages use t() */
    public static String t(boolean isHindi, String en, String hiText) {
        return isHindi ? hiText : en;
    }
%>
