-- NQNQ SQL Server(nqnqdb) 적재 검증 — 2. PK/유니크 위반 체크 (전부 0건이어야 정상)

SELECT sku_code, COUNT(*) AS c FROM sku GROUP BY sku_code HAVING COUNT(*) > 1;
SELECT product_id, COUNT(*) AS c FROM product GROUP BY product_id HAVING COUNT(*) > 1;
SELECT order_id, COUNT(*) AS c FROM orders GROUP BY order_id HAVING COUNT(*) > 1;
SELECT return_id, COUNT(*) AS c FROM return_request GROUP BY return_id HAVING COUNT(*) > 1;

-- inventory: sku_code 단독 유니크(위치 미구분 합계 테이블)
SELECT sku_code, COUNT(*) AS c FROM inventory GROUP BY sku_code HAVING COUNT(*) > 1;

-- inventory_by_location: 복합 유니크 (sku_code, location_id)
SELECT sku_code, location_id, COUNT(*) AS c FROM inventory_by_location GROUP BY sku_code, location_id HAVING COUNT(*) > 1;

-- order_item / po_item: surrogate id가 PK지만, 문서상 실질 유니크키 조합도 체크
SELECT order_id, sku_code, COUNT(*) AS c FROM order_item GROUP BY order_id, sku_code HAVING COUNT(*) > 1;
SELECT po_id, sku_code, COUNT(*) AS c FROM po_item GROUP BY po_id, sku_code HAVING COUNT(*) > 1;
