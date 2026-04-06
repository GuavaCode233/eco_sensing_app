# 🍃 Eco-Sensing 企業範疇三碳排 AI 智慧核算助理

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=flat&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-%230175C2.svg?style=flat&logo=dart&logoColor=white)
![Riverpod](https://img.shields.io/badge/Riverpod-State_Management-blue)
![Status](https://img.shields.io/badge/Status-Active_Development-brightgreen)
![NSTC](https://img.shields.io/badge/Project-國科會研究計畫-orange)

> **結合「數位與綠色雙軸轉型」，為企業打造的非侵入式範疇三碳盤查與員工減碳行為激勵 App。**

<!-- 🔗 **Repository:**[https://github.com/GuavaCode233/eco_sensing_app](https://github.com/GuavaCode233/eco_sensing_app) -->

---

## 📖 專案背景與痛點 (Background & Motivation)

在當前「綠色與數位雙軸轉型 (Twin Transition)」趨勢下，企業面臨嚴峻的國際合規壓力與供應鏈透明度要求。然而，在「範疇三 (Scope 3)」的碳盤查中，長期存在以下結構性困境：

1. **數據破碎化與行政成本過高**：員工通勤、差旅收據、辦公資源消耗等多為非結構化單據。手動填報精準度低，且高昂的行政成本易引發員工對環保政策的抵觸情緒。
2. **「分開激勵」問題 (Split Incentive)**：員工不直接負擔能源成本，導致減碳缺乏實質誘因，難以將淨零文化轉化為持久的行為慣性。
3. **現有 IoT 設備缺乏靈活性**：市面設備多針對特定硬體（如智慧電表），無法適應不同職能部門（如高出差頻率的業務部）迥異的排放結構。

---

## 🎯 研究與開發目標 (Core Objectives)

本專案旨在透過 App 軟體端與感知技術，達成以下雙重目標：

### 🛠️ 技術維度 (Technical Dimension)
* **分眾虛擬感知器 (SVS) 應用**：建構非侵入式感知架構，針對不同部門業務特性（差旅、廢棄物、數位行為）動態配置感知模組。
* **自動化數據採集與轉換**：將員工行為數據自動化轉譯為碳排放數據，大幅降低手動採集負擔。
* **合規級數據輸出**：產出可供第三方稽核之即時碳足跡報表。

### 📊 管理維度 (Management Dimension)
* **行為引導閉環模型**：透過數據報表之視覺化分析，建立「數據回饋引導行為」之機制。
* **利潤分享激勵體系**：將隱形的碳排放轉化為可管理的營運指標，結合實質激勵模型，驗證並提升員工減碳行為的轉化率。

---

## 💻 軟體架構與技術棧 (Tech Stack & Architecture)

本 Repository 主要負責系統之前端 App 與核心商業邏輯實作。

* **開發框架**：Flutter (跨平台支援 iOS / Android / Web)
* **狀態管理**：[Riverpod](https://riverpod.dev/) (確保 API 串接與多重感知數據傳遞的高擴充性與高穩定性)
* **架構設計**：*(開發中，預計採用 MVVM 或 Clean Architecture)*
* **後端與 AI 整合**：*(預計串接之 API 或 AI 服務說明)*

---

## 🚀 當前開發進度 (Current Progress)

> 本專案目前處於積極開發階段，以下為主要 Milestone：

- [x] 確立系統架構與 Flutter 專案初始化
- [x] 導入 Riverpod 狀態管理機制與基礎路由配置
- [ ] 實作員工行為數據輸入與 SVS 模組化介面
- [ ] 串接後端碳排轉換 API
- [ ] 實作個人/企業碳足跡視覺化 Dashboard (儀表板)
- [ ] 導入「利潤分享」激勵機制 UI/UX

---

## 📸 畫面展示 (UI Demo)

*(UI 介面持續開發中，未來將於此處更新系統截圖與操作 GIF)*

| Dashboard 總覽 | 碳排數據採集 | 減碳激勵回饋 |
| :---: | :---: | :---: |
| `[預留圖片位置]` | `[預留圖片位置]` | `[預留圖片位置]` |

---

## ⚙️ 安裝與運行 (Installation)

```bash
# Clone this repository
$ git clone https://github.com/GuavaCode233/eco_sensing_app.git

# Go into the repository
$ cd eco_sensing_app

# Install dependencies
$ flutter pub get

# Run the app
$ flutter run