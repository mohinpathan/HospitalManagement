import os

path = 'src/main/webapp'
responsive_link = '<link rel="stylesheet" href="/HospitalManagement/responsive.css">\n'
count = 0

for f in os.listdir(path):
    if not f.endswith('.jsp'):
        continue
    fp = os.path.join(path, f)
    with open(fp, 'r', encoding='utf-8', errors='ignore') as fh:
        c = fh.read()

    # Skip if already has it
    if 'responsive.css' in c:
        continue

    # Add after bootstrap link
    if 'bootstrap@5.3.2' in c:
        c = c.replace(
            '<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">',
            '<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">\n' + responsive_link
        )
        with open(fp, 'w', encoding='utf-8') as fh:
            fh.write(c)
        count += 1
        print('Added responsive.css to:', f)

print('Total:', count)
