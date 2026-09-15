-- NQNQ SQL Server(nqnqdb) 적재 검증 — 5. 비즈니스 규칙(문서 기준 공식) 체크

-- SKU.cost ≈ price × 0.48 (COST_RATIO)
SELECT sku_code, price, cost, ROUND(price * 0.48, 0) AS expected_cost
FROM sku WHERE ABS(cost - price * 0.48) > 1;

-- purchase_order 리드타임: expected_arrival_date = order_date + 52일
SELECT po_id, order_date, expected_arrival_date
FROM purchase_order
WHERE expected_arrival_date <> DATEADD(day, 52, order_date);

-- inventory_by_location: SKU당 HUB 행이 정확히 1개인지
SELECT sku_code, COUNT(*) AS hub_rows
FROM inventory_by_location WHERE location_id = 'HUB'
GROUP BY sku_code HAVING COUNT(*) <> 1;

-- 재고 수량 음수 불가 (두 테이블 다)
SELECT * FROM inventory WHERE available_qty < 0 OR reserved_qty < 0 OR defective_qty < 0 OR pending_return_qty < 0;
SELECT * FROM inventory_by_location WHERE available_qty < 0 OR reserved_qty < 0 OR defective_qty < 0 OR pending_return_qty < 0;

-- inventory_ledger 이관(+/-) 쌍 합계는 0이어야 함
SELECT reference_id, SUM(qty_change) AS net_change
FROM inventory_ledger
WHERE movement_type = N'이관'
GROUP BY reference_id
HAVING SUM(qty_change) <> 0;
