# 垃圾桶 Supabase Demo

本功能只模擬相機初始化成功後的 3 秒掃描，不解析 QR。後續只使用 `trash_sessions` 真實資料，不計時模擬開桶／分析／結果，也不產生假獎勵。

## App 設定

垃圾桶由後端 `POST /trash/session` 決定，App 不再傳送／固定 bin ID。App 將回傳的 `session_id` 對應為 Supabase 的 `trash_sessions.id`，只監聽該筆資料。

`POST /trash/{session_id}/raw-data` 由垃圾桶上傳 `raw_weight`、`image_url`、`ai_raw_result`、`sensor_data`；App 不呼叫這支 API，也不產生假原始資料。

後端 URL、Supabase URL 與前端 publishable key 已設定，可直接 `flutter run -d U1`。覆寫環境時：

```sh
flutter run -d U1 \
  --dart-define=API_BASE_URL=https://uie47061-eco-sensing-backend.hf.space \
  --dart-define=SUPABASE_URL=https://svshoobbhjciypwvdgob.supabase.co \
  --dart-define=SUPABASE_PUBLISHABLE_KEY=YOUR_PUBLISHABLE_OR_ANON_KEY
```

需要 release 時加 `--release`。參數更改須重新啟動，不是 hot reload。若覆寫成空白或無效設定，Supabase 監聽會顯示連線失敗；其餘 App 功能不因缺少 Supabase 設定而無法啟動。

只放前端 publishable / anon key，不能使用 service_role key。此流程不使用 App 後端 JWT，也不自動登入 Supabase Auth；目前依 Supabase 匿名角色權限執行。

## Supabase 準備

- `public.trash_sessions` 須具備 `id`（自動產生）、`bin_id`、`status`、`trash_type`、`weight`、`carbon`。
- 除 `bin_id`、`status` 外的必填欄位需有預設值；結果欄位須能先留空。
- Demo bin UUID 必須存在於 `bins`。
- 在 Realtime publication 啟用 `public.trash_sessions` 的 Postgres Changes。
- 目前客戶端角色需能 SELECT 該筆資料（含相應 RLS policy），以供補讀與 Realtime 使用。INSERT 由後端執行，App 不需要 INSERT／UPDATE 權限。請依 Demo 資料範圍配置，這次未自動修改任何資料庫政策。
- App 自有員工登入與 Supabase Auth 為不同機制，略過 App 登入不會略過資料庫權限。

## 手動驗收

1. 進掃描頁，按「掃描垃圾桶」，允許相機權限。
2. 相機就緒 3 秒後呼叫 `POST /trash/session`（空 body），由後端建立 `status = waiting` 的紀錄，畫面顯示 Session ID。
3. Table Editor 只修改該 ID：`opened` → `collecting` → `processing`。
4. 填入 `status = completed`、`trash_type = PET`、`weight = 32.5`、`carbon = 0.083`，畫面應顯示原值。單位未定案前不自行加 kg 或做換算。
5. 改別筆 session，畫面不得變更。改本筆 `failed`，畫面顯示「處理失敗」。
6. 關閉或返回會取消訂閱／移除 channel；重新掃描只建立一筆新 session。
7. 斷線顯示重新連線按鈕；重連沿用原 ID、不重新 INSERT，訂閱成功後補讀最新狀態。

若關閉時建立請求已送出，資料庫可能仍建立 waiting 紀錄，但 App 不會啟動延遲訂閱；可在 Table Editor 檢查。建立逾時（30 秒）或失敗不會自動重送 POST，以免回應遺失時重複建單。

官方參考：
- https://supabase.com/docs/reference/dart/initializing
- https://supabase.com/docs/reference/dart/subscribe
- https://supabase.com/docs/guides/realtime/postgres-changes
