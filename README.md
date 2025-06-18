# FIG Emergency Resilient Network (FERN)  
**無花果緊急韌性網路**  
**FIG = Flexible Interconnected Grid**：彈性互聯式社區自組網

## 🧭 專案簡介 | Introduction

**FERN（無花果緊急韌性網路）** 是一套為災難與戰時設計的社區型自組網路系統。  
當所有網際網路與 Wi-Fi 基礎設施中斷時，**FIG** 讓任何人只要**插上電源**即可自動加入網路，提供本地化通訊與資訊服務。

> "A network that lives as long as electricity exists."

---

## 🎯 核心目標 | Core Goals

- 🛠 **零設定部署**：插電即啟動，無需手動設定
- 🌐 **完全離線運作**：不依賴任何中央伺服器或網際網路
- 🧩 **節點自組網**：單板電腦自動偵測附近裝置，透過 Mesh 網路連接
- 🔄 **服務同步備援**：內建服務（如聊天室、公告牆）支援節點間同步與快取
- ⚡ **斷電容錯能力**：節點中斷不影響整體網路，節點恢復即重新合併

---

## 🧱 架構說明 | System Architecture

### 🎛 節點組成 | Node Composition
- 單板電腦（如 Raspberry Pi 3B+ 或其他 SBC）
- 1 張內建 Wi-Fi 網卡（做 Mesh）
- 1 張外接 USB Wi-Fi 網卡（提供 Wi-Fi 熱點）

### 🌐 Mesh 組網 | Mesh Networking
- 使用 Linux + `batman-adv` 實作節點互聯
- 每個節點可自動搜尋其他節點，並建立 Mesh 網路

### 📡 熱點服務 | Local Wi-Fi Access
- 由外接網卡提供 Wi-Fi AP，讓用戶設備（手機、筆電）可接入本地服務頁面

---

## 📦 內建服務 | Built-in Services

| 服務 | 說明 |
|------|------|
| 📢 公告牆 | 節點間同步的社區公告，支援脫機瀏覽 |
| 💬 聊天室 | 本地化即時聊天室，節點可互為備援 |
| 🗂 檔案分享 | 簡易點對點或全節點共享檔案 |
| 🌐 內部 DNS | 節點自動命名與尋址（不依賴 DHCP）

---

## 🔌 節點特性 | Node Features

- 自動開機加入 Mesh
- 自動提供 Wi-Fi 熱點
- 偵測用戶連線並同步資料

---

## 🔒 安全性與韌性 | Security & Resilience

- 節點之間使用本地加密通訊
- 網路自動恢復斷線節點
- 若兩區間節點斷開，則獨立成兩個子網
- 一旦有節點連上網際網路，整個網路將可連外（gateway 模式）

---

## 💡 使用情境 | Use Cases

- 🚨 災難後緊急資訊交換
- 🏘 社區備援通訊
- 🧪 學術研究與韌性網路測試
- 🛠 無網環境 IoT 架構實驗

---

## 🚀 開發與貢獻 | Development & Contribution

專案採用模組化設計，使用簡單可維護的技術實作：

- Backend：Go
- Networking：batman-adv, hostapd, dnsmasq
- Frontend：HTML + JS
- Deployment：Raspberry Pi OS Lite

歡迎提 issue、貢獻程式、或建議架構改善！

---

## 📜 授權 | License

MIT License  
© 2025 HazelnutParadise
