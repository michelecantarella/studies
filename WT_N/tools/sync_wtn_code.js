// Copies WT_N's generator (CFG + the design code) from WT_N/index.html into the
// pages that reuse it verbatim, between /*__WTN_BEGIN__*/ and /*__WTN_END__*/:
//   node WT_N/tools/sync_wtn_code.js WT_N/index.html WT_N/proto_brute.html WT_N/pairs_lab.html WT_N/deck_alt_lab.html
const fs = require('fs');
const [src, ...targets] = process.argv.slice(2);
const idx = fs.readFileSync(src, 'utf8').replace(/\r\n/g, '\n');
const grab = (a, b) => { const i = idx.indexOf(a), j = idx.indexOf(b, i); if(i < 0 || j < 0) throw new Error('not found in ' + src + ': ' + a); return idx.slice(i, j); };
const code = grab('const CFG = {', '\n};') + '\n};\n' + grab('const rnd  =', 'function kill(') + grab('function pickWeighted_(', '\n}') + '\n}\n' + grab('const _pauseW = {};', '// Whether the offer has been reached');
for(const t of targets){
  let s = fs.readFileSync(t, 'utf8'); const crlf = s.includes('\r\n'); if(crlf) s = s.replace(/\r\n/g, '\n');
  const A = '/*__WTN_BEGIN__*/', B = '/*__WTN_END__*/', i = s.indexOf(A), j = s.indexOf(B);
  if(i < 0 || j < i) throw new Error('markers missing in ' + t);
  s = s.slice(0, i + A.length) + '\n' + code + '\n' + s.slice(j);
  if(crlf) s = s.replace(/\n/g, '\r\n');
  fs.writeFileSync(t, s); console.log('synced ' + t);
}
