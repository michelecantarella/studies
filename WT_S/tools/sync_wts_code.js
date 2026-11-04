// Copies WT_S's generator from WT_S/index.html (between /*__WTS_BEGIN__*/ and /*__WTS_END__*/) into the pages that
// reuse it verbatim, between the same markers (as WT_Q/tools/sync_wtq_code.js):
//   node WT_S/tools/sync_wts_code.js WT_S/index.html WT_S/lab.html
const fs = require('fs');
const [src, ...targets] = process.argv.slice(2);
const A = '/*__WTS_BEGIN__*/', B = '/*__WTS_END__*/';
const idx = fs.readFileSync(src, 'utf8').replace(/\r\n/g, '\n');
const i0 = idx.indexOf(A), j0 = idx.indexOf(B);
if(i0 < 0 || j0 < i0) throw new Error('markers missing in ' + src);
const code = idx.slice(i0 + A.length, j0);
for(const t of targets){
  let s = fs.readFileSync(t, 'utf8'); const crlf = s.includes('\r\n'); if(crlf) s = s.replace(/\r\n/g, '\n');
  const i = s.indexOf(A), j = s.indexOf(B);
  if(i < 0 || j < i) throw new Error('markers missing in ' + t);
  s = s.slice(0, i + A.length) + code + s.slice(j);
  if(crlf) s = s.replace(/\n/g, '\r\n');
  fs.writeFileSync(t, s); console.log('synced ' + t);
}
