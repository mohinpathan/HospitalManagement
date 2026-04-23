import os, re

path = 'src/main/webapp'
count = 0

for f in os.listdir(path):
    if not f.endswith('.jsp'):
        continue
    fp = os.path.join(path, f)
    with open(fp, 'r', encoding='utf-8', errors='ignore') as fh:
        c = fh.read()
    orig = c

    # Remove <%@ include file="/WEB-INF/lang.jsp" %>
    c = re.sub(r'<%@\s*include\s+file=["\'][^"\']*lang\.jsp["\']%>', '', c)
    # Remove <jsp:include page="/WEB-INF/lang.jsp" />
    c = re.sub(r'<jsp:include\s+page=["\'][^"\']*lang\.jsp["\'][^>]*/>', '', c)

    # Replace <%=L(hi,"hindi","english")%> with english
    c = re.sub(r'<%=\s*L\s*\(\s*hi\s*,\s*"[^"]*"\s*,\s*"([^"]*)"\s*\)\s*%>', r'\1', c)
    c = re.sub(r"<%=\s*L\s*\(\s*hi\s*,\s*'[^']*'\s*,\s*'([^']*)'\s*\)\s*%>", r'\1', c)

    # Remove boolean hi = ... lines inside <% %>
    c = re.sub(r'boolean\s+hi\s*=\s*[^;]+;', '', c)

    if c != orig:
        with open(fp, 'w', encoding='utf-8') as fh:
            fh.write(c)
        count += 1
        print('Fixed:', f)

print('Total fixed:', count)
