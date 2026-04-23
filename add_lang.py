import os

path = 'src/main/webapp'
skip = ['langswitcher.jsp','footer.jsp','header.jsp','adminheader.jsp',
        'patientheader.jsp','doctorheader.jsp','adminsidebar.jsp',
        'patientsidebar.jsp','doctorsidebar.jsp']

count = 0
for f in os.listdir(path):
    if not f.endswith('.jsp'):
        continue
    if f in skip:
        continue
    fp = os.path.join(path, f)
    with open(fp, 'r', encoding='utf-8') as fh:
        c = fh.read()
    if 'lang.jsp' in c:
        continue
    marker = '<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>'
    if marker in c:
        replacement = marker + '\n<%@ include file="/WEB-INF/lang.jsp" %>'
        c = c.replace(marker, replacement, 1)
        with open(fp, 'w', encoding='utf-8') as fh:
            fh.write(c)
        count += 1
        print('Added lang.jsp to:', f)

print('Total files updated:', count)
