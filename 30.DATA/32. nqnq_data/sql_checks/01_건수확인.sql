-- NQNQ SQL Server(nqnqdb) 적재 검증 — 1. 전체 테이블 건수 확인
-- 참고: 기획 저장소 61-entity-dictionary.md 품질 체크리스트 2026-09-15 항목

SELECT 'category' AS tbl, COUNT(*) AS cnt FROM category
UNION ALL SELECT 'product', COUNT(*) FROM product
UNION ALL SELECT 'sku', COUNT(*) FROM sku
UNION ALL SELECT 'factory', COUNT(*) FROM factory
UNION ALL SELECT 'purchase_order', COUNT(*) FROM purchase_order
UNION ALL SELECT 'po_item', COUNT(*) FROM po_item
UNION ALL SELECT 'inventory', COUNT(*) FROM inventory
UNION ALL SELECT 'inventory_by_location', COUNT(*) FROM inventory_by_location
UNION ALL SELECT 'inventory_ledger', COUNT(*) FROM inventory_ledger
UNION ALL SELECT 'channel', COUNT(*) FROM channel
UNION ALL SELECT 'customer', COUNT(*) FROM customer
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_item', COUNT(*) FROM order_item
UNION ALL SELECT 'return_request', COUNT(*) FROM return_request
UNION ALL SELECT 'store', COUNT(*) FROM store;

-- 참고: database_firewall_rules는 Azure SQL Database 자체 시스템 테이블이라 검증 대상 아님
