-- NQNQ SQL Server(nqnqdb) 적재 검증 — 3-1. inventory ↔ inventory_by_location 정합성
-- inventory(SKU 전체 합계, 520행) 값이 inventory_by_location(SKU×위치, 2092행)의
-- 위치별 합계와 정확히 일치해야 함. 불일치 SKU가 있으면 아래 쿼리에 행이 나옴(0건이 정상).
--
-- 2026-09-15 최초 실행 결과: 350개 SKU 전원 불일치 (inventory 값이 항상 더 작음)
-- 원인 규명 후 03-2 재적재 스크립트 실행 → 재검증 결과 0건 확인 (results/ 폴더 CSV 참고)

SELECT i.sku_code, i.available_qty AS total_qty, SUM(ibl.available_qty) AS sum_by_location,
       i.available_qty - SUM(ibl.available_qty) AS diff
FROM inventory i
LEFT JOIN inventory_by_location ibl ON i.sku_code = ibl.sku_code
GROUP BY i.sku_code, i.available_qty
HAVING i.available_qty <> ISNULL(SUM(ibl.available_qty), 0)
ORDER BY diff DESC;

-- 참고 진단 쿼리: inventory 값이 실제로는 HUB 재고와만 일치하는지 확인
-- SELECT sku_code, location_id, available_qty FROM inventory_by_location WHERE sku_code = 'NQ-ACC-BAG-001-FREE-BEG';
