-- NQNQ SQL Server(nqnqdb) 적재 검증 — 3-2. inventory 테이블 재적재
--
-- 원인: inventory 테이블이 export_for_dataverse.py / export_full_for_dataverse.py
-- (archive/export_scripts/, v5 이전 스키마 기준으로 작성된 옛 스크립트)의
-- "SELECT sku_code, available_qty, ... FROM inventory" 결과로 채워져 있었음.
-- v5부터 inventory 원본 테이블 자체가 (sku_code, location_id) 복합키로 바뀌었는데
-- 이 옛 스크립트는 location_id 없이 그대로 SELECT해서, SKU당 여러 행 중
-- 사실상 HUB 행 하나만 남은 상태로 적재됨(매장 재고 누락).
--
-- 조치: inventory_by_location(정상 데이터, nqnq.db와 100% 일치 확인됨)을
-- sku_code 기준으로 재집계해서 inventory를 통째로 재적재.
-- 2026-09-15 실행 결과: 520건 반영, 이후 03-1 재검증 0건(정상) 확인.

TRUNCATE TABLE inventory;

INSERT INTO inventory (sku_code, available_qty, reserved_qty, defective_qty, pending_return_qty, safety_stock, reorder_point, last_updated)
SELECT
    sku_code,
    SUM(available_qty),
    SUM(reserved_qty),
    SUM(defective_qty),
    SUM(pending_return_qty),
    MAX(safety_stock),
    MAX(reorder_point),
    MAX(last_updated)
FROM inventory_by_location
GROUP BY sku_code;
