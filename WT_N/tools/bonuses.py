"""WT_N bonus payments for Prolific.

    python bonuses.py <Meta export: .xlsx of the whole spreadsheet, or Meta as .csv>

Reads Meta, takes every participant who completed the study with a bonus to
pay (final_bonus > 0), skips those already in bonuses_processed.csv (kept in this\ntools folder, next to the script), and writes, next to the input file,\n    bulk_bonus_<date-time>.csv   PROLIFIC_PID,amount  (dot decimals, two digits)\nfor Prolific's bulk bonus payment, adding the same participants to the ledger.
Excluded: demo sessions, the unpaid test modes (STUDY_ID pilot/studentpilot),
study ids starting with "test", unfinished sessions.
"""
import csv, os, re, sys, zipfile, datetime
import xml.etree.ElementTree as ET


def read_meta(path):
    if path.lower().endswith('.csv'):
        with open(path, newline='', encoding='utf-8-sig') as f:
            return list(csv.DictReader(f))
    z = zipfile.ZipFile(path)
    ns = {'m': 'http://schemas.openxmlformats.org/spreadsheetml/2006/main'}
    rid = '{http://schemas.openxmlformats.org/officeDocument/2006/relationships}id'
    shared = []
    if 'xl/sharedStrings.xml' in z.namelist():
        for si in ET.fromstring(z.read('xl/sharedStrings.xml')).findall('m:si', ns):
            shared.append(''.join(t.text or '' for t in si.iter('{%s}t' % ns['m'])))
    rels = {r.get('Id'): r.get('Target') for r in ET.fromstring(z.read('xl/_rels/workbook.xml.rels'))}
    target = None
    for sh in ET.fromstring(z.read('xl/workbook.xml')).find('m:sheets', ns):
        if sh.get('name') == 'Meta':
            target = rels[sh.get(rid)]
    if not target:
        sys.exit('No "Meta" sheet in ' + path)
    target = target if target.startswith('xl/') else 'xl/' + target.lstrip('/')
    rows = []
    for row in ET.fromstring(z.read(target)).iter('{%s}row' % ns['m']):
        vals = {}
        for c in row.findall('m:c', ns):
            col = 0
            for ch in re.match(r'[A-Z]+', c.get('r')).group(0):
                col = col * 26 + ord(ch) - 64
            v, t = c.find('m:v', ns), c.get('t')
            if t == 'inlineStr':
                val = ''.join(x.text or '' for x in c.iter('{%s}t' % ns['m']))
            elif v is None:
                val = ''
            elif t == 's':
                val = shared[int(v.text)]
            else:
                val = v.text
            vals[col - 1] = val
        if vals:
            rows.append([vals.get(i, '') for i in range(max(vals) + 1)])
    header = rows[0]
    return [dict(zip(header, r + [''] * (len(header) - len(r)))) for r in rows[1:]]


def to_float(x):
    try:
        return float(str(x).replace(',', '.'))
    except ValueError:
        return 0.0


def main():
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    src = sys.argv[1]
    folder = os.path.dirname(os.path.abspath(src))
    processed_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'bonuses_processed.csv')  # the ledger stays in tools/

    done = set()
    if os.path.exists(processed_path):
        with open(processed_path, newline='', encoding='utf-8') as f:
            done = {r['prolific_pid'] for r in csv.DictReader(f)}

    new = []
    for m in read_meta(src):
        pid = str(m.get('prolific_pid', '')).strip()
        sid = str(m.get('study_id', '')).strip()
        bonus = round(to_float(m.get('final_bonus', 0)), 2)
        if not pid or pid in done or not str(m.get('study_complete_at', '')).strip():
            continue
        if to_float(m.get('demo_mode', 0)) != 0 or re.match(r'^(pilot|studentpilot)$', sid, re.I) or sid.lower().startswith('test'):
            continue
        if bonus <= 0:
            continue
        new.append((pid, bonus, sid))
        done.add(pid)

    if not new:
        print('No new bonuses to pay.')
        return

    stamp = datetime.datetime.now().strftime('%Y-%m-%d_%H%M')
    out_path = os.path.join(folder, 'bulk_bonus_%s.csv' % stamp)
    with open(out_path, 'w', newline='', encoding='utf-8') as f:
        w = csv.writer(f)
        for pid, bonus, _ in new:
            w.writerow([pid, '%.2f' % bonus])

    first = not os.path.exists(processed_path)
    with open(processed_path, 'a', newline='', encoding='utf-8') as f:
        w = csv.writer(f)
        if first:
            w.writerow(['prolific_pid', 'bonus', 'study_id', 'processed_at', 'file'])
        for pid, bonus, sid in new:
            w.writerow([pid, '%.2f' % bonus, sid, stamp, os.path.basename(out_path)])

    print('%d new bonuses, total GBP %.2f -> %s' % (len(new), sum(b for _, b, _ in new), out_path))
    print('Recorded in ' + processed_path)


if __name__ == '__main__':
    main()
