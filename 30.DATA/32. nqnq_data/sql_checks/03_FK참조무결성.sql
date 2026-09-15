-- NQNQ SQL Server(nqnqdb) 적재 검증 — 3. FK 참조무결성 (고아 레코드, 전부 0건이어야 정상)

SELECT p.product_id FROM product p LEFT JOIN category c ON p.category_code = c.category_code WHERE c.category_code IS NULL;
SELECT s.sku_code FROM sku s LEFT JOIN product p ON s.product_id = p.product_id WHERE p.product_id IS NULL;
SELECT o.order_id FROM orders o LEFT JOIN customer c ON o.customer_id = c.customer_id WHERE c.customer_id IS NULL;
SELECT o.order_id FROM orders o LEFT JOIN channel c ON o.channel_id = c.channel_id WHERE c.channel_id IS NULL;
SELECT oi.id FROM order_item oi LEFT JOIN orders o ON oi.order_id = o.order_id WHERE o.order_id IS NULL;
SELECT oi.id FROM order_item oi LEFT JOIN sku s ON oi.sku_code = s.sku_code WHERE s.sku_code IS NULL;
SELECT i.sku_code, i.location_id FROM inventory_by_location i LEFT JOIN store st ON i.location_id = st.store_id WHERE st.store_id IS NULL;
SELECT il.ledger_id FROM inventory_ledger il LEFT JOIN store st ON il.location_id = st.store_id WHERE st.store_id IS NULL;
SELECT rr.return_id FROM return_request rr LEFT JOIN orders o ON rr.order_id = o.order_id WHERE o.order_id IS NULL;
SELECT pi.id FROM po_item pi LEFT JOIN purchase_order po ON pi.po_id = po.po_id WHERE po.po_id IS NULL;
