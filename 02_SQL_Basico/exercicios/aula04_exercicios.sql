-- 1. Clientes únicos por estado

SELECT
	c.customer_state as estado,
	COUNT(DISTINCT c.customer_unique_id ) as num_clientes
FROM 
	customer c 
GROUP BY c.customer_state 


-- 2. Cidades únicas de clientes por estado
SELECT
	c.customer_state as estado, 
	COUNT(DISTINCT c.customer_city ) as num_cidades
FROM 	
	customer c 
GROUP BY c.customer_state 


-- 3. Clientes únicos por estado e cidade

SELECT 
	c.customer_state as estado,
	c.customer_city  as cidade,
	COUNT (DISTINCT c.customer_unique_id )
FROM 
	customer c 
GROUP BY c.customer_state , c.customer_city 


-- 4. Clientes únicos por cidade e estado (ordem do GROUP BY invertida)
SELECT 
	c.customer_state as estado,
	c.customer_city  as cidade,
	COUNT (DISTINCT c.customer_unique_id )
FROM 
	customer c 
GROUP BY  c.customer_city , c.customer_state 


-- 5. Pedidos únicos por vendedor
SELECT 
	oi.seller_id as vendedor,
	COUNT(DISTINCT oi.order_id ) as num_pedidos
FROM 
	order_items oi  
GROUP BY oi.seller_id 


-- 6. Por vendedor: pedidos, datas mín/máx de envio e frete mín/máx/médio
SELECT 
	oi.seller_id  as vendedor,
	COUNT(DISTINCT oi.order_id ) as pedidos,
	MIN(oi.shipping_limit_date ) as data_min,
	MAX(oi.shipping_limit_date ) as data_max,
	AVG(oi.freight_value ) as frete_medio,
	MAX(oi.freight_value ) as frete_max,
	MIN(Oi.freight_value ) as frete_min
FROM 
	order_items oi 
GROUP BY 
	oi.seller_id 

-- 7. Por produto: preço médio, mínimo e máximo
	
SELECT
	oi.product_id as produto,
	AVG(oi.price ) as preco_medio,
	MIN(oi.price ) as preco_min,
	MAX(oi.price) as preco_max
FROM
	order_items oi 
GROUP BY oi.product_id 


-- 8. Vendedores distintos com pedido e preço médio das vendas

SELECT 
	COUNT (DISTINCT oi.seller_id ) as num_vendedores,
	AVG(oi.price ) as preco_medio
FROM 
	order_items oi 



-- 9. Pedidos por tipo de pagamento

SELECT 
	op.payment_type as tipo_pgto,
	COUNT (DISTINCT op.order_id ) as qtd_pedidos
FROM 
	order_payments op 
GROUP BY op.payment_type 



-- 10. Por tipo de pagamento: pedidos, média paga e máximo de parcelas
SELECT 
	op.payment_type  as tipo_parcela,
	COUNT(DISTINCT op.order_id ) as qtd_pedidos,
	AVG(op.payment_value) as media_pagamento,
	MAX(op.payment_installments ) as max_parcelas
FROM order_payments op 
GROUP BY op.payment_type 
	
-- 11. Por tipo de pagamento e parcelas: valor mín, máx, médio e total
SELECT
	op.payment_type  as tipo_pagamento,
	op.payment_installments  as num_parcelas,
	MIN(op.payment_value ) as valor_min,
	MAX(op.payment_value ) as valor_max,
	AVG(op.payment_value ) as valor_medio,
	SUM (op.payment_value ) as valor_total	
FROM 
	order_payments op 
GROUP BY op.payment_type, op.payment_installments  
	
	
-- 12. Preço médio por produto
SELECT 
	oi.product_id as produto,
	AVG(oi.price) as media 
FROM 
	order_items oi  
GROUP BY 
	oi.product_id 
	
	
-- 13. Pedidos por status
SELECT
	o.order_status as status,
	COUNT (DISTINCT o.order_id) as qtd_pedidos
FROM 
	orders o 
GROUP BY 
	o.order_status 
	
	
-- 14. Pedidos por dia (DATE para tirar a hora)
SELECT 
	DATE (o.order_approved_at),
	COUNT(DISTINCT o.order_id ) as qtd_pedidos
FROM
	orders o
GROUP BY 
	DATE (o.order_approved_at )

	
-- 15. Produtos cadastrados por categoria


SELECT 
	p.product_category_name as categoria,
	COUNT(DISTINCT p.product_id ) as qtd_produtos
FROM 
	products p 
GROUP BY p.product_category_name 
	
	
	
	
	
	
	
	
	








