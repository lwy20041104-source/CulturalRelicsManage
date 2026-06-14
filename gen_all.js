const f = require('fs');
const base = 'E:\\java\\Graduate\\CulturalRelicsManage\\CulturalRelicsManage\\';
function esc(s) { return s.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;'); }
function gen(name, w, h, cells) {
  let o = [];
  o.push('<?xml version="1.0" encoding="UTF-8"?>');
  o.push('<mxfile host="app.diagrams.net" modified="2026-06-12T10:00:00.000Z" version="24.0.0">');
  o.push('  <diagram id="f1" name="' + name + '">');
  o.push('    <mxGraphModel dx="0" dy="0" grid="1" gridSize="10" pageWidth="' + w + '" pageHeight="' + h + '" background="#ffffff">');
  o.push('      <root><mxCell id="0" /><mxCell id="1" parent="0" />');
  cells.forEach(c => {
    let v = '';
    if (c.v) v = ' value="' + esc(c.v) + '"';
    let st = '';
    if (c.st) st = ' style="' + c.st + '"';
    let geo = '<mxGeometry';
    if (c.x !== undefined) geo += ' x="' + c.x + '" y="' + c.y + '" width="' + c.w + '" height="' + c.h + '"';
    geo += ' as="geometry" />';
    if (c.s && c.t) {
      let t = ''; let lb = '';
      if (c.lb) lb = ' value="' + esc(c.lb) + '"';
      o.push('<mxCell' + st + ' edge="1" parent="1"' + lb + '><mxGeometry relative="1" as="geometry"><mxPoint x="' + c.sx + '" y="' + c.sy + '" as="sourcePoint" /><mxPoint x="' + c.tx + '" y="' + c.ty + '" as="targetPoint" /></mxGeometry></mxCell>');
    } else {
      o.push('<mxCell id="' + c.id + '"' + v + st + ' vertex="1" parent="1">' + geo + '</mxCell>');
    }
  });
  o.push('      </root>');
  o.push('    </mxGraphModel>');
  o.push('  </diagram>');
  o.push('</mxfile>');
  f.writeFileSync(base + name + '.drawio', o.join('\n'), 'utf-8');
  console.log('Created: ' + name + '.drawio');
}

const BW = 'fillColor=#ffffff;strokeColor=#000000;fontColor=#000000;';
const BOX = 'rounded=1;whiteSpace=wrap;html=1;' + BW + 'fontSize=11;';
const ELL = 'ellipse;whiteSpace=wrap;html=1;' + BW + 'fontSize=11;';
const DIA = 'rhombus;whiteSpace=wrap;html=1;' + BW + 'fontSize=11;';
const CYL = 'shape=cylinder3;whiteSpace=wrap;html=1;' + BW + 'fontSize=11;';
const EDGE = 'edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeColor=#000000;';
const A = EDGE + 'exitX=1;exitY=0.5;entryX=0;entryY=0.5;';
const U = EDGE + 'exitX=0.5;exitY=0;entryX=0.5;entryY=1;';
const D2 = EDGE + 'exitX=0.5;exitY=1;entryX=0.5;entryY=0;';
const L = EDGE + 'exitX=0;exitY=0.5;entryX=1;entryY=0.5;';
const X0 = EDGE + 'exitX=0;exitY=1;entryX=0.5;entryY=0;';

function cell(ar, id, v, st, x, y, w, h) { ar.push({id:id,v:v,st:st,x:x,y:y,w:w,h:h}); }
function conn(ar, sx, sy, tx, ty, lb) { ar.push({s:1,t:1,sx:sx,sy:sy,tx:tx,ty:ty,lb:lb}); }

// ========== Flow 1: 文物信息管理 ==========
let c1 = [];
const X=40, W=100, H=40, GAP=140, GAPV=55;
const TLX = 350; // top label x

// Title
cell(c1,'t1','文物信息管理流程','text;html=1;textAlign=center;' + BW + 'fontSize=16;fontStyle=1', 280, 10, 340, 35);

// Row 1: 进入 + 选择
cell(c1,'r1','进入文物管理模块',BOX, X, 60, W, H);
cell(c1,'r2','选择操作类型',BOX, X, 120, W, H);

// Row 2: 4 operations
cell(c1,'r3','添加文物',BOX, 220, 60, 90, 35);
cell(c1,'r4','填写表单与上传图片',BOX, 360, 55, 110, 45);
cell(c1,'r5','自动生成编号WW00001',BOX, 520, 55, 110, 45);

cell(c1,'r6','编辑文物',BOX, 220, 110, 90, 35);
cell(c1,'r7','修改信息与保存更新',BOX, 360, 105, 110, 45);

cell(c1,'r8','删除文物',BOX, 220, 160, 90, 35);
cell(c1,'r9','确认并清除关联数据',BOX, 360, 155, 110, 45);

cell(c1,'r10','批量操作',BOX, 220, 210, 90, 35);
cell(c1,'r11','批量删除或修改状态',BOX, 360, 205, 110, 45);

// Row 3: 日志审计
cell(c1,'r12','操作日志审计与记录',BOX, 520, 120, 110, 40);
// Row 4: 刷新
cell(c1,'r13','刷新文物列表',BOX, 520, 180, 110, 40);
// Row 5: 数据库
cell(c1,'r14','MySQL数据库 + Redis缓存',CYL, 520, 250, 110, 55);

// 3D
cell(c1,'r15','3D文物展示',BOX, X, 200, W, 35);
cell(c1,'r16','Three.js渲染与交互',BOX, 220, 275, 110, 45);

// 二维码
cell(c1,'r17','生成二维码标签',BOX, X, 260, W, 35);
cell(c1,'r18','导出ExcelPDFWord',BOX, 220, 330, 110, 45);

// Edges
var cx = X + W; var cy = 60 + H/2; var cy2 = 120 + H/2;
conn(c1, cx, cy, 220, 60+H/2); // r1-r3
conn(c1, cx, cy2, 220, 110+H/2); // r1-r6
conn(c1, cx, 120+H/2, 220, 160+H/2);
conn(c1, cx, 120+H/2, 220, 210+H/2);

conn(c1, 220+90, 60+17, 360, 55+22);
conn(c1, 360+110, 55+22, 520, 55+22);
conn(c1, 220+90, 110+17, 360, 105+22);
conn(c1, 220+90, 160+17, 360, 155+22);
conn(c1, 220+90, 210+17, 360, 205+22);

conn(c1, 520, 55+45, 520, 120); // from 编号 down-right
// Actually let me simplify - just connect each result to log
conn(c1, 360+110, 55+22, 520, 120+40/2);
// Actually let me redo these connections cleanly
// Already have auto edges... let me just do straight connections
// Let me keep it simple with direct connections to log audit
function connR(ar, fx, fy, tx, ty) { conn(ar, fx, fy, tx, ty); }

// r5 - r12 (add)
connR(c1, 520+110, 55+22, 520+110, 120+20);
connR(c1, 520+110, 120+20, 520, 120+20);
// r7 - r12 (edit)
connR(c1, 360+110, 105+22, 520, 120+20);
// r9 - r12 (delete)
connR(c1, 360+110, 155+22, 520, 120+20);
// r11 - r12 (batch)
connR(c1, 360+110, 205+22, 520, 120+20);

connR(c1, 520+55, 120+40, 520+55, 180); // r12-r13
connR(c1, 520+55, 180+40, 520+55, 250); // r13-r14

// 3D
connR(c1, X+W, 200+17, 220, 200+17);
connR(c1, 220+110, 200+17, 220+110, 275+22);
connR(c1, 220+110, 275+22, 220+110, 330+22);

// QR
connR(c1, X+W, 260+17, 220, 260+17);
connR(c1, 220+110, 260+17, 220+110, 330+22);

gen('01-文物信息管理流程', 700, 430, c1);

// ========== Flow 2: 维护与修复审批 ==========
let c2 = [];
cell(c2,'t1','维护与修复审批流程','text;html=1;textAlign=center;' + BW + 'fontSize=16;fontStyle=1', 300, 10, 400, 35);

// Row 1: 提交
cell(c2,'m1','保管员提交维护/修复申请',BOX, 30, 70, 140, 40);
cell(c2,'m2','系统保存申请并记录状态',BOX, 230, 70, 140, 40);
cell(c2,'m3','WebSocket推送加邮件实时通知审批员',BOX, 430, 65, 160, 50);

// Row 2: 审批
cell(c2,'m4','审批员审核申请',DIA, 430, 170, 160, 50);
cell(c2,'m5','修复材料管理',BOX, 30, 310, 110, 35);
cell(c2,'m6','按专业领域筛选',BOX, 30, 365, 110, 35);

// Decision
cell(c2,'d3','审批是否通过?',DIA, 660, 170, 130, 50);
cell(c2,'m7','通知保管员并说明驳回原因',BOX, 860, 170, 150, 40);

// Row 3: 通过后
cell(c2,'m8','更新文物状态为"维护/修复中"',BOX, 660, 280, 150, 45);
cell(c2,'m9','分配修复专家并选择修复材料',BOX, 660, 350, 150, 40);
cell(c2,'m10','执行修复/维护任务直至完成',BOX, 660, 420, 150, 40);

// Row 4: 专家/材料
cell(c2,'m11','修复专家管理',BOX, 30, 150, 110, 35);
cell(c2,'m12','库存预警提示',BOX, 30, 420, 110, 35);

// Edges
conn(c2, 170, 90, 230, 90);
conn(c2, 370, 90, 430, 90);
conn(c2, 430+80, 65+50, 430+80, 170);

conn(c2, 430+80, 170+25, 660, 170+25);
conn(c2, 660+65, 170+50, 660+65, 280);
conn(c2, 660+75, 280+45, 660+75, 350);
conn(c2, 660+75, 350+40, 660+75, 420);

// Reject
conn(c2, 660+130, 170+25, 860, 170+25);
// Expert/Material
conn(c2, 30+140, 70+20, 30+140, 150);
conn(c2, 30+55, 150+35, 30+55, 310);
conn(c2, 30+55, 310+35, 30+55, 365);
conn(c2, 30+55, 365+35, 30+55, 420);

// Labels
conn(c2, 660+65, 170+50, 660+65, 260, '是');
conn(c2, 660+130, 170+25, 840, 170+25, '否');

gen('02-维护与修复审批流程', 1100, 520, c2);

// ========== Flow 3: AI智能查询与数据管理 ==========
let c3 = [];
cell(c3,'t1','AI智能查询与数据管理','text;html=1;textAlign=center;' + BW + 'fontSize=16;fontStyle=1', 300, 10, 400, 35);

// Row 1
cell(c3,'a1','用户输入查询内容',BOX, 30, 70, 110, 40);
cell(c3,'a2','是否为文物查询?',DIA, 210, 65, 130, 50);

// Branch: 是 → 馆藏检索
cell(c3,'a3','馆藏MySQL数据库检索',BOX, 410, 70, 130, 40);
cell(c3,'a4','是否匹配成功?',DIA, 610, 65, 130, 50);

// 是 → 评分展示
cell(c3,'a5','相关度评分排序并以卡片形式展示',BOX, 810, 70, 150, 40);
cell(c3,'a6','展示文物详细信息与图片',BOX, 810, 140, 150, 40);

// 否 → 全网搜索
cell(c3,'a7','调用搜索引擎进行全网检索',BOX, 610, 160, 130, 40);
cell(c3,'a8','智能抓取网页信息与图片URL',BOX, 610, 230, 130, 40);
cell(c3,'a9','按相关度排序以卡片展示',BOX, 610, 300, 130, 40);

// 否 (from 文物查询?) → DeepSeek
cell(c3,'a10','直接由DeepSeek AI智能回答',BOX, 410, 160, 130, 40);

// Convergence
cell(c3,'a11','合并结果并记录对话历史',BOX, 410, 300, 130, 40);
cell(c3,'a12','系统管理员可查看所有历史记录',BOX, 410, 370, 130, 40);

// 百度AI
cell(c3,'a13','百度AI图像智能识别',BOX, 30, 200, 110, 35);
cell(c3,'a14','上传文物图片自动识别分类',BOX, 30, 260, 110, 40);

// Edges
conn(c3, 140, 90, 210, 90);
conn(c3, 210+65, 65+50, 210+65, 65+50); // Decision exits

// 是 to 馆藏检索
conn(c3, 210+130, 65+25, 410, 90);
// 否 to DeepSeek
conn(c3, 210+65, 65+50, 410, 200);

conn(c3, 410+130, 90, 610, 90);
conn(c3, 610+65, 65+50, 610+65, 160);
conn(c3, 610+65, 160+40, 610+65, 230);
conn(c3, 610+65, 230+40, 610+65, 300);

conn(c3, 410+130, 200, 610, 200);

// 是 to 展示
conn(c3, 610+130, 65+25, 810, 90);
conn(c3, 810+75, 70+40, 810+75, 140);

// Convergence
conn(c3, 810+75, 140+40, 810+75, 300);
conn(c3, 610+65, 300+40, 810+75, 300);
conn(c3, 810+75, 300, 410+130, 300);

// 否 labels
conn(c3, 210+65, 65+50, 210+65, 65+50); // already handled
conn(c3, 610+65, 65+50, 610+65, 150, '否');
conn(c3, 610+130, 65+25, 800, 65+25, '是');

// DeepSeek to merge
conn(c3, 410+130, 200, 410+130, 300);

// Baidu AI
conn(c3, 140, 90, 30, 200+17);
conn(c3, 30+55, 200+35, 30+55, 260);

gen('03-AI智能查询与数据管理', 1050, 470, c3);

console.log('All files created successfully!');
