# 50.DATABRICKS

ML·모델링 롤 실행 폴더. Databricks 노트북(피처 엔지니어링~학습), risk_score 계산 로직, 예측-실측 오차율 스크립트를 여기 담습니다.

## 참고 문서 (2026-09-10 보강 — Dataverse 적재 대기 중 자료조사용)

### risk_score / 스코어링 공식 — 제일 먼저 볼 것
- [[23. Alert & Trigger Rules]] — risk_score 산출 공식(재고소진임박도 × 인기도가중치)의 SSOT. "학술적 근거" 절에 안전재고/재주문점 이론 참고문헌도 있음
- ⚠️ [[작업지시서 (최민 — 데이터·인프라)]] 6-2절 — 위 공식과 현재 대시보드 구현이 서로 다르다는 걸 발견해서 적어둔 부분. 실제 구현 시 어느 쪽으로 통일할지 결정 필요

### Databricks 착수 전 필수
- [[22. Cost Plan]] — 클러스터 소형 구성 + 짧은 자동종료(15~30분) 필수, Burn Rate 알림 2단계. 클러스터 켜기 전에 꼭 한 번 볼 것

### 피처 엔지니어링 — 실제 데이터 로직 참고
- `30.DATA/32. nqnq_data/generate_v4.py` — reorder_point/par_level/safety_stock 공식, SKU 선택 가중치(날씨×사이즈×인기도 티어), 카테고리별 반품율 등 원본 로직
- [[71. Entity Definitions & Data Dictionary]] — 전체 테이블 스키마, 재고정책 공식
- [[74. Real-World Data Grounding (Weather & Body)]] — 계절/체형 민감도 계수 근거자료
- `30.DATA/32. nqnq_data/README.md` — 지금 데이터 규모 확인용

### RAG 자동발주 프로토타입 (임현제 제안 아이디어)
- [[04.MS-DataSchool/20.PROJECT/22.MS_2nd_Project/00.WBS/05. 회의록/01. 1차 화상회의록]] 1부 — 본인이 제안한 원안("과거 최적값 기반 발주, 발주이력 데이터 없어서 임의생성 필요")
- [[14. 1차 프로젝트 대비 차별화 아이디어]] 논의 5(GenAI 활용처)·6(24절기 계절 ML)·8(K3 Ratio Curves)

### GenAI 예측근거 자연어 설명 (2026-09-10 채택)
- [[21. Appservice Core model]] 7절 — ReAct 축소판 파이프라인(탐색→생성→검증) 기술 설계 초안, Structured Output 스키마까지 제안돼있음

### 2026-09-10 새로 결정된 것
- [[04.MS-DataSchool/20.PROJECT/22.MS_2nd_Project/00.WBS/05. 회의록/02. 9-10 타운홀 회의록]] C·D·F절 — recommended_qty(재발주는 SKU 독립계산·판매현황 기반, 신규출시만 K3 비율배분), 예측대조 데이터 저장방식(미정, 작업하면서 판단), GenAI 예측근거 설명 채택

### 기타
- [[24. 기능명세서 v1]] — Databricks가 기술 핵심, 예측 결과를 Dataverse에 직접 적재
- [[26. 대시보드 기술명세 (프론트)]] 2절·5절 — 예측대조 뷰가 필요로 하는 데이터 형태(예측치 vs held-out 실측치)
- [[28. Dataverse 가이드]] — ML 결과가 어떤 필드 형태로 Dataverse에 적재되는지

## 📌 2026-09-14 전달사항 — 임현제님 신규 작업: `auto_decidable` 판정 로직

임현제님이 제안하신 "담당자 부재 시 자동 의사결정" 아이디어를 채택 — 다만 완전자동화가 아니라 저위험 건만 안전하게 처리하는 스트레치로 스코프를 좁혔음([[21. Appservice Core model]] 0-1절 Human-in-the-loop 원칙과 안 부딪히게). 상세 설계는 [[ML·RAG·프론트·백엔드 실행설계 (요구사항-설계-구현-테스트)]] 2-5절 참고.

- 노트북 `04_risk_score` 단계에서 `auto_decidable`(Boolean) 플래그도 같이 계산해서 Dataverse에 적재 — risk_score·recommended_qty가 낮아 "잘못돼도 손실이 작은" 건만 true
- 이 플래그를 Power Automate(나경)가 SLA 타임아웃 시 Condition으로만 읽음 — 복잡한 판정 로직을 로우코드로 짤 필요 없음
- 착수 시점: 코어 루프(1~5단계 노트북) 배포·9/23 체크포인트 통과 이후에만
- SLA 시간·임계값 구체 수치는 9/14 회의에서 확정
