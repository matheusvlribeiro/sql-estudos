-- 1. Clientes únicos de SP
SELECT COUNT( DISTINCT c.customer_id ) as num_clientes
FROM 
	customer c 
WHERE
	c.customer_state ='SP'
	

-- 2. Pedidos únicos em 08/10/2016
SELECT
	COUNT(DISTINCT o.order_id) as num_pedidos 
FROM
	orders o
WHERE 
	DATE(o.order_purchase_timestamp) = '2016-10-08'
	
-- 3. Pedidos únicos a partir de 08/10/2016
SELECT
	COUNT(DISTINCT o.order_id) as num_pedidos 
FROM
	orders o
WHERE 
	DATE(o.order_purchase_timestamp) >= '2016-10-08'

	
-- 4. Pedidos únicos com limite de envio a partir de 08/10/2016

SELECT
	COUNT(DISTINCT oi.order_id) as num_pedidos 
FROM
	order_items oi 
WHERE 
	DATE(oi.shipping_limit_date  ) >= '2016-10-08'
	
	
	
-- 5. Pedidos únicos e frete médio, preço abaixo de 1100

SELECT 
	COUNT(DISTINCT oi.order_id ) as num_pedidos,
	AVG(oi.freight_value ) as frete_medio	
FROM 
	order_items oi 
WHERE 
	oi.price < 1100
	
	
-- 6. Por vendedor, preço abaixo de 1100: pedidos, datas mín/máx de envio e frete mín/máx/médio
SELECT 
	oi.seller_id  as vendedor,
	COUNT(DISTINCT oi.order_id ) as num_pedidos,
	MIN(oi.shipping_limit_date ) as data_min,
	MAX(oi.shipping_limit_date ) as data_max,
	MIN(oi.freight_value ) as frete_min, 
	MAX(oi.freight_value ) as frete_max,
	AVG(oi.freight_value ) as frete_medio
FROM 
	order_items oi 
WHERE 
	oi.price < 1100
GROUP BY oi.seller_id 
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	