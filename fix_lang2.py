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

    # Pattern 1: <%@ include file="/WEB-INF/lang.jsp" %>
    c = c.replace('<%@ include file="/WEB-INF/lang.jsp" %>', '')
    c = c.replace("<%@ include file='/WEB-INF/lang.jsp' %>", '')

    # Pattern 2: boolean hi = ... (any variation)
    c = re.sub(r'boolean\s+hi\s*=\s*[^\n;]+[;\n]', '\n', c)

    # Pattern 3: <%=L(hi,"hindi","english")%> -> english
    # Handle multiline and various spacing
    c = re.sub(r'<%=\s*L\s*\(\s*hi\s*,\s*"[^"]*"\s*,\s*"([^"]*)"\s*\)\s*%>', r'\1', c)
    c = re.sub(r"<%=\s*L\s*\(\s*hi\s*,\s*'[^']*'\s*,\s*'([^']*)'\s*\)\s*%>", r'\1', c)

    # Pattern 4: L(hi,"hindi","english") without <%= %> (inside scriptlets)
    c = re.sub(r'L\s*\(\s*hi\s*,\s*"[^"]*"\s*,\s*"([^"]*)"\s*\)', r'"\1"', c)

    if c != orig:
        with open(fp, 'w', encoding='utf-8') as fh:
            fh.write(c)
        count += 1
        print('Fixed:', f)

print('Total fixed:', count)
