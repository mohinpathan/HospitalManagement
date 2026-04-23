import os

path = 'src/main/webapp'
count = 0
for f in os.listdir(path):
    if not f.endswith('.jsp'):
        continue
    fp = os.path.join(path, f)
    with open(fp, 'rb') as fh:
        raw = fh.read()
    # Remove UTF-8 BOM if present
    if raw.startswith(b'\xef\xbb\xbf'):
        with open(fp, 'wb') as fh:
            fh.write(raw[3:])
        count += 1
        print(f'Removed BOM from: {f}')

# Also fix WEB-INF/lang.jsp
fp2 = 'src/main/webapp/WEB-INF/lang.jsp'
with open(fp2, 'rb') as fh:
    raw = fh.read()
if raw.startswith(b'\xef\xbb\xbf'):
    with open(fp2, 'wb') as fh:
        fh.write(raw[3:])
    print('Removed BOM from: lang.jsp')
    count += 1

print(f'Total BOM fixes: {count}')
