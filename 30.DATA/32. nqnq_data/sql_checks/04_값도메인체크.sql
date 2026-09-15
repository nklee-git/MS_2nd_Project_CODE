-- NQNQ SQL Server(nqnqdb) 적재 검증 — 4. 값 도메인(허용값) 체크 (전부 0건이어야 정상)

SELECT DISTINCT popularity_tier FROM product WHERE popularity_tier NOT IN ('HERO','STEADY','NICHE');
SELECT DISTINCT line_type FROM product WHERE line_type NOT IN ('BASIC','TREND');
SELECT DISTINCT channel_id FROM channel WHERE channel_id NOT IN ('ZIGZAG','OFFLINE','WHOLESALE');
SELECT DISTINCT o.channel_id FROM orders o WHERE o.channel_id NOT IN ('ZIGZAG','OFFLINE','WHOLESALE');
SELECT DISTINCT reason_code FROM return_request WHERE reason_code NOT IN ('R01','R02','R03','R04','R05');
SELECT DISTINCT status FROM orders WHERE status NOT IN (N'주문완료', N'배송중', N'배송완료', N'구매확정', N'취소');
