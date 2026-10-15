// メルカリ用の商品名と説明文を catalog.json から作る。出力先: out/mercari/<TB-xx>.title.txt / .desc.txt
import { readFileSync, writeFileSync, mkdirSync } from 'node:fs';
const cat = JSON.parse(readFileSync(new URL('../catalog.json', import.meta.url), 'utf8'));
mkdirSync('out/mercari', { recursive: true });
const sideLine = { 'Side A': 'Side A — Bayside, Tokyo 1985–1991', 'Side B': 'Side B — Tokyo Bay, after dark', 'Cover Girl': 'Cover Girl — 横顔で、こちらを見ない。' };
for (const w of cat.works) {
  if (!w.mercari) continue;
  const m = cat.measurements[w.size];
  const title = `TOKYO BUBBLE Tシャツ ${w.size} ${w.color} ${w.no} シティポップ 新品`;
  const desc = [
    'TOKYO BUBBLE',
    `${w.no} ${w.title}`,
    sideLine[w.side],
    '',
    '正方形のアートワークを胸にプリントしたTシャツ。',
    'ひとつの絵につき、白と黒。',
    '',
    `【サイズ】${w.size}　ユニセックス`,
    `身丈 ${m.length} / 身幅 ${m.chest} / 袖丈 ${m.sleeve}`,
    '素材: コットン',
    '',
    'レコードジャケットの中にだけあった、東京。',
    '1985年から1991年のあいだ、東京は夏が終わらないと思っていた。',
    '',
    '#TOKYOBUBBLE #シティポップ #80s #レトロ #Tシャツ',
  ].join('\n');
  if ([...title].length > 40) throw new Error(`${w.no}: 商品名が 40 字超 (${[...title].length})`);
  writeFileSync(`out/mercari/${w.no}.title.txt`, title);
  writeFileSync(`out/mercari/${w.no}.desc.txt`, desc + '\n');
  console.log(`${w.no} ${w.mercari}  ${[...title].length}字  ${title}`);
}
