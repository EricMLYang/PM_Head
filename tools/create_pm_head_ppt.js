const pptxgen = require("pptxgenjs");

let pres = new pptxgen();
pres.layout = 'LAYOUT_16x9';
pres.author = 'PM Head';
pres.title = 'PM Head - 多產品線管理架構';

// 定義顏色主題
const colors = {
  primary: "2563EB",      // Blue
  secondary: "64748B",    // Slate
  accent: "F59E0B",       // Amber
  dark: "1E293B",         // Dark slate
  light: "F8FAFC",        // Light
  white: "FFFFFF"
};

// ========== 封面 ==========
let slide1 = pres.addSlide();
slide1.background = { color: colors.primary };

slide1.addText("PM Head", {
  x: 0.5, y: 1.8, w: 9, h: 0.8,
  fontSize: 54, bold: true, color: colors.white,
  align: "center", fontFace: "微軟正黑體"
});

slide1.addText("多產品線管理架構 + GitHub Copilot 整合", {
  x: 0.5, y: 2.8, w: 9, h: 0.5,
  fontSize: 24, color: colors.white,
  align: "center", fontFace: "微軟正黑體"
});

slide1.addText("AI-Powered Portfolio Management", {
  x: 0.5, y: 4.5, w: 9, h: 0.3,
  fontSize: 14, color: colors.white,
  align: "center", fontFace: "Arial", italic: true
});

// ========== 管理範圍與目標 ==========
let slide2 = pres.addSlide();
slide2.addText("管理範圍與目標", {
  x: 0.5, y: 0.3, w: 9, h: 0.6,
  fontSize: 32, bold: true, color: colors.dark,
  fontFace: "微軟正黑體", margin: 0
});

// 三個子專案卡片
const projects = [
  { name: "MI_PM", desc: "MI2.0 影像平台", x: 0.7, color: "3B82F6" },
  { name: "VMS_PM", desc: "VMS 影像管理系統", x: 3.7, color: "8B5CF6" },
  { name: "SmartSignagePM", desc: "智慧電子看板", x: 6.7, color: "10B981" }
];

projects.forEach(proj => {
  slide2.addShape(pres.shapes.RECTANGLE, {
    x: proj.x, y: 1.3, w: 2.6, h: 1.4,
    fill: { color: proj.color, transparency: 10 },
    line: { color: proj.color, width: 2 }
  });
  slide2.addText(proj.name, {
    x: proj.x, y: 1.5, w: 2.6, h: 0.4,
    fontSize: 18, bold: true, color: colors.dark,
    align: "center", fontFace: "微軟正黑體"
  });
  slide2.addText(proj.desc, {
    x: proj.x, y: 2.0, w: 2.6, h: 0.5,
    fontSize: 12, color: colors.secondary,
    align: "center", fontFace: "微軟正黑體"
  });
});

// 共通技術棧
slide2.addShape(pres.shapes.RECTANGLE, {
  x: 0.7, y: 3.0, w: 8.6, h: 0.8,
  fill: { color: colors.light },
  line: { color: colors.secondary, width: 1 }
});
slide2.addText("共通技術棧：Databricks 數據分析 + 領域應用層", {
  x: 0.7, y: 3.15, w: 8.6, h: 0.5,
  fontSize: 14, color: colors.dark, bold: true,
  align: "center", fontFace: "微軟正黑體"
});

// 目標
slide2.addText("核心目標", {
  x: 0.5, y: 4.0, w: 9, h: 0.4,
  fontSize: 16, bold: true, color: colors.dark,
  fontFace: "微軟正黑體"
});

slide2.addText([
  { text: "俯瞰高度：跨專案策略協同、資源配置", options: { bullet: true, breakLine: true } },
  { text: "槓桿思維：共用組件抽離，一次投資多專案受惠", options: { bullet: true, breakLine: true } },
  { text: "尊重在地：不越級干預各子 PM 的產品細節", options: { bullet: true } }
], {
  x: 0.8, y: 4.5, w: 8.5, h: 1.0,
  fontSize: 13, color: colors.dark,
  fontFace: "微軟正黑體"
});

// ========== GitHub Copilot 整合架構 ==========
let slide3 = pres.addSlide();
slide3.addText("GitHub Copilot 整合架構", {
  x: 0.5, y: 0.3, w: 9, h: 0.6,
  fontSize: 32, bold: true, color: colors.dark,
  fontFace: "微軟正黑體", margin: 0
});

// 核心指令源
slide3.addShape(pres.shapes.RECTANGLE, {
  x: 0.7, y: 1.2, w: 3.5, h: 1.8,
  fill: { color: colors.primary, transparency: 10 },
  line: { color: colors.primary, width: 2 }
});
slide3.addText("核心指令源", {
  x: 0.7, y: 1.4, w: 3.5, h: 0.4,
  fontSize: 16, bold: true, color: colors.dark,
  align: "center", fontFace: "微軟正黑體"
});
slide3.addText([
  { text: "AGENTS.md", options: { bullet: true, breakLine: true } },
  { text: "├─ 角色身份 (.ai/identity.yaml)", options: { bullet: true, breakLine: true, indentLevel: 1 } },
  { text: "├─ 決策原則 (.ai/principles.md)", options: { bullet: true, breakLine: true, indentLevel: 1 } },
  { text: "└─ 技能觸發規則", options: { bullet: true, indentLevel: 1 } }
], {
  x: 0.9, y: 2.0, w: 3.1, h: 0.9,
  fontSize: 11, color: colors.dark,
  fontFace: "Consolas"
});

// Copilot 橋接
slide3.addShape(pres.shapes.RECTANGLE, {
  x: 4.5, y: 1.2, w: 4.8, h: 1.8,
  fill: { color: colors.accent, transparency: 10 },
  line: { color: colors.accent, width: 2 }
});
slide3.addText("Copilot 橋接層", {
  x: 4.5, y: 1.4, w: 4.8, h: 0.4,
  fontSize: 16, bold: true, color: colors.dark,
  align: "center", fontFace: "微軟正黑體"
});
slide3.addText([
  { text: ".github/copilot-instructions.md", options: { bullet: true, breakLine: true } },
  { text: "自動摘要 AGENTS.md 核心資訊", options: { bullet: true, breakLine: true, indentLevel: 1 } },
  { text: "保持與核心指令源同步", options: { bullet: true, indentLevel: 1 } }
], {
  x: 4.7, y: 2.0, w: 4.4, h: 0.9,
  fontSize: 11, color: colors.dark,
  fontFace: "微軟正黑體"
});

// 同步機制
slide3.addShape(pres.shapes.LINE, {
  x: 2.45, y: 2.1, w: 2.05, h: 0,
  line: { color: colors.secondary, width: 2, endArrowType: "triangle" }
});
slide3.addText("copilot-sync 技能", {
  x: 2.5, y: 1.8, w: 2.0, h: 0.3,
  fontSize: 10, color: colors.secondary,
  align: "center", fontFace: "微軟正黑體"
});

// 設計理念
slide3.addText("設計理念", {
  x: 0.5, y: 3.3, w: 9, h: 0.4,
  fontSize: 16, bold: true, color: colors.dark,
  fontFace: "微軟正黑體"
});
slide3.addText([
  { text: "單一真相來源：AGENTS.md 為核心，避免多處維護", options: { bullet: true, breakLine: true } },
  { text: "自動同步：AGENTS.md 變更後自動更新 Copilot 橋接檔", options: { bullet: true, breakLine: true } },
  { text: "跨 AI 相容：支援 Claude, Gemini, Copilot 不同存取路徑", options: { bullet: true } }
], {
  x: 0.8, y: 3.8, w: 8.5, h: 1.6,
  fontSize: 13, color: colors.dark,
  fontFace: "微軟正黑體"
});

// ========== 核心功能概覽 ==========
let slide4 = pres.addSlide();
slide4.addText("核心功能概覽", {
  x: 0.5, y: 0.3, w: 9, h: 0.6,
  fontSize: 32, bold: true, color: colors.dark,
  fontFace: "微軟正黑體", margin: 0
});

const functions = [
  {
    icon: "📊",
    title: "定期彙整報告",
    items: ["週/月/季報自動產生", "跨專案策略觀點", "輸出至 5_management/"]
  },
  {
    icon: "🎯",
    title: "跨專案策略協調",
    items: ["資源衝突分析", "共用組件識別", "槓桿效益評估"]
  },
  {
    icon: "⚖️",
    title: "優先順序仲裁",
    items: ["多專案資源協調", "全局槓桿框架", "決策記錄追蹤"]
  },
  {
    icon: "🔄",
    title: "子 Repo 狀態同步",
    items: ["Git 狀態批量檢查", "跨 Repo 進度追蹤", "只讀取不干預"]
  }
];

functions.forEach((func, idx) => {
  const x = 0.5 + (idx % 2) * 4.8;
  const y = 1.3 + Math.floor(idx / 2) * 2.0;
  
  slide4.addShape(pres.shapes.RECTANGLE, {
    x: x, y: y, w: 4.5, h: 1.6,
    fill: { color: colors.light },
    line: { color: colors.secondary, width: 1 }
  });
  
  slide4.addText([
    { text: func.icon + " ", options: { fontSize: 20 } },
    { text: func.title, options: { bold: true, fontSize: 14 } }
  ], {
    x: x + 0.2, y: y + 0.15, w: 4.1, h: 0.4,
    color: colors.dark, fontFace: "微軟正黑體"
  });
  
  slide4.addText([
    { text: func.items[0], options: { bullet: true, breakLine: true } },
    { text: func.items[1], options: { bullet: true, breakLine: true } },
    { text: func.items[2], options: { bullet: true } }
  ], {
    x: x + 0.3, y: y + 0.6, w: 4.0, h: 0.8,
    fontSize: 11, color: colors.dark,
    fontFace: "微軟正黑體"
  });
});

// ========== 技能驅動工作流 ==========
let slide5 = pres.addSlide();
slide5.addText("技能驅動工作流", {
  x: 0.5, y: 0.3, w: 9, h: 0.6,
  fontSize: 32, bold: true, color: colors.dark,
  fontFace: "微軟正黑體", margin: 0
});

// 流程圖
const workflow = [
  { step: "1", text: "任務輸入", y: 1.3, color: "3B82F6" },
  { step: "2", text: "查詢技能索引", y: 2.2, color: "8B5CF6" },
  { step: "3", text: "載入 SKILL.md", y: 3.1, color: "EC4899" },
  { step: "4", text: "執行流程", y: 4.0, color: "F59E0B" }
];

workflow.forEach((item, idx) => {
  // 步驟方塊
  slide5.addShape(pres.shapes.RECTANGLE, {
    x: 1.5, y: item.y, w: 3.0, h: 0.6,
    fill: { color: item.color },
    line: { color: item.color, width: 0 }
  });
  slide5.addText([
    { text: item.step + ". ", options: { fontSize: 16, bold: true, color: colors.white } },
    { text: item.text, options: { fontSize: 14, color: colors.white } }
  ], {
    x: 1.5, y: item.y + 0.1, w: 3.0, h: 0.4,
    align: "center", fontFace: "微軟正黑體"
  });
  
  // 連接線
  if (idx < workflow.length - 1) {
    slide5.addShape(pres.shapes.LINE, {
      x: 3.0, y: item.y + 0.6, w: 0, h: 0.6,
      line: { color: colors.secondary, width: 2, endArrowType: "triangle" }
    });
  }
});

// 技能清單
slide5.addShape(pres.shapes.RECTANGLE, {
  x: 5.0, y: 1.3, w: 4.5, h: 3.3,
  fill: { color: colors.light },
  line: { color: colors.secondary, width: 1 }
});
slide5.addText("可用技能 (8 個)", {
  x: 5.0, y: 1.4, w: 4.5, h: 0.4,
  fontSize: 14, bold: true, color: colors.dark,
  align: "center", fontFace: "微軟正黑體"
});
slide5.addText([
  { text: "portfolio-report：定期報告彙整", options: { bullet: true, breakLine: true } },
  { text: "cross-project-strategy：策略分析", options: { bullet: true, breakLine: true } },
  { text: "priority-arbitrate：優先順序仲裁", options: { bullet: true, breakLine: true } },
  { text: "stakeholder-align：利害關係人對齊", options: { bullet: true, breakLine: true } },
  { text: "repo-git-sync：Git 狀態同步", options: { bullet: true, breakLine: true } },
  { text: "util-pptx：簡報處理", options: { bullet: true, breakLine: true } },
  { text: "skill-expand：技能擴充", options: { bullet: true, breakLine: true } },
  { text: "copilot-sync：Copilot 橋接同步", options: { bullet: true } }
], {
  x: 5.2, y: 1.9, w: 4.1, h: 2.5,
  fontSize: 10, color: colors.dark,
  fontFace: "微軟正黑體"
});

// ========== 實際運作範例 ==========
let slide6 = pres.addSlide();
slide6.addText("實際運作範例", {
  x: 0.5, y: 0.3, w: 9, h: 0.6,
  fontSize: 32, bold: true, color: colors.dark,
  fontFace: "微軟正黑體", margin: 0
});

// 範例 1
slide6.addShape(pres.shapes.RECTANGLE, {
  x: 0.5, y: 1.2, w: 9, h: 1.3,
  fill: { color: colors.light },
  line: { color: "3B82F6", width: 2 }
});
slide6.addText("範例 1：週報產生", {
  x: 0.7, y: 1.35, w: 8.6, h: 0.3,
  fontSize: 14, bold: true, color: colors.dark,
  fontFace: "微軟正黑體"
});
slide6.addText([
  { text: "觸發：每週五執行 portfolio-report 技能", options: { bullet: true, breakLine: true } },
  { text: "流程：讀取 projects/*/00_context/ → 彙整狀態 → 產生週報到 5_management/weekly/", options: { bullet: true, breakLine: true } },
  { text: "產出：含跨專案策略觀點的週報，非單純狀態搬運", options: { bullet: true } }
], {
  x: 0.9, y: 1.75, w: 8.2, h: 0.6,
  fontSize: 11, color: colors.dark,
  fontFace: "微軟正黑體"
});

// 範例 2
slide6.addShape(pres.shapes.RECTANGLE, {
  x: 0.5, y: 2.7, w: 9, h: 1.3,
  fill: { color: colors.light },
  line: { color: "8B5CF6", width: 2 }
});
slide6.addText("範例 2：資源衝突仲裁", {
  x: 0.7, y: 2.85, w: 8.6, h: 0.3,
  fontSize: 14, bold: true, color: colors.dark,
  fontFace: "微軟正黑體"
});
slide6.addText([
  { text: "觸發：MI 與 VMS 同時需要數據分析資源", options: { bullet: true, breakLine: true } },
  { text: "流程：執行 priority-arbitrate → 評估全局槓桿 → 產出仲裁建議", options: { bullet: true, breakLine: true } },
  { text: "記錄：決策理由寫入 .ai/memory/decisions.md 與 5_management/decision_records/", options: { bullet: true } }
], {
  x: 0.9, y: 3.25, w: 8.2, h: 0.6,
  fontSize: 11, color: colors.dark,
  fontFace: "微軟正黑體"
});

// 範例 3
slide6.addShape(pres.shapes.RECTANGLE, {
  x: 0.5, y: 4.2, w: 9, h: 1.1,
  fill: { color: colors.light },
  line: { color: "10B981", width: 2 }
});
slide6.addText("範例 3：共用組件識別", {
  x: 0.7, y: 4.35, w: 8.6, h: 0.3,
  fontSize: 14, bold: true, color: colors.dark,
  fontFace: "微軟正黑體"
});
slide6.addText([
  { text: "觸發：發現 MI 與 SmartSignage 都需要影像分析功能", options: { bullet: true, breakLine: true } },
  { text: "流程：cross-project-strategy → 評估抽離效益 → 更新 0_portfolio/common_components.md", options: { bullet: true } }
], {
  x: 0.9, y: 4.75, w: 8.2, h: 0.5,
  fontSize: 11, color: colors.dark,
  fontFace: "微軟正黑體"
});

// 儲存
pres.writeFile({ fileName: "PM_Head_多產品線管理架構.pptx" });
console.log("✅ 簡報已產生：PM_Head_多產品線管理架構.pptx");
