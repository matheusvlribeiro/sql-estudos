-- 1. Clientes únicos de MG ou RJ
SELECT COUNT(DISTINCT c.customer_id ) as num_clientes
FROM customer c 
WHERE c.customer_state  = 'MG' OR c.customer_state = 'RJ'

-- 2. Cidades únicas de SP ou RJ com latitude e longitude dentro de um intervalo
SELECT
	g.geolocation_state, 
	COUNT(DISTINCT g.geolocation_city ) as qtde_cidade
FROM geolocation g
WHERE (g.geolocation_state ='SP' OR g.geolocation_state  = 'RJ') AND g.geolocation_lat > -24.54 AND g.geolocation_lng <-45.63
GROUP BY g.geolocation_state 


-- 3. Pedidos, produtos e preço médio: frete acima de 20 e envio em outubro/2016
SELECT 
	COUNT(DISTINCT oi.order_id ) as total_pedidos,
	COUNT(DISTINCT oi.product_id ) as total_produtos,
	AVG(oi.price ) as preco_medio
FROM 
	order_items oi 
WHERE 
	oi.freight_value >20 AND 
	DATE(oi.shipping_limit_date ) >= '2016-10-01' AND 
	DATE(oi.shipping_limit_date ) <= '2016-10-31'


-- 4. Por parcelas: pedidos e total pago, parcelas de 1 a 5 ou pagamento acima de 5000

SELECT 
	op.payment_installments as prestações,
	COUNT(op.order_id ) as qtde_pedidos,
	SUM(op.payment_value ) as total_pagamento
FROM order_payments op 
WHERE
	op.payment_installments >=1 and op.payment_installments <=5 or op.payment_value >5000
GROUP BY op.payment_installments 



-- 5. Pedidos em processamento ou cancelados com entrega estimada fora de um intervalo

SELECT 
	o.order_status  as status,
	COUNT(DISTINCT o.order_id ) AS quantidade_pedidos
FROM orders o 
WHERE 
	(o.order_status = 'processing' or 
	o.order_status = 'canceled') AND
	(DATE(o.order_estimated_delivery_date) > '2017-01-01' OR
	DATE(o.order_estimated_delivery_date) < '2016-11-23')  
GROUP BY o.order_status 

-- 6. Produtos de 5 categorias com mais de 5 fotos e medidas mínimas
SELECT  
	p.product_category_name  as categoria,
	COUNT(DISTINCT p.product_id) as qtde_produtos
FROM 
	products p 
WHERE
	p.product_photos_qty > 5 AND 
	p.product_weight_g > 5 AND 
	p.product_height_cm > 10 AND 
	p.product_width_cm  > 20 AND 
	(p.product_category_name  = 'perfumaria' OR
	p.product_category_name  = 'brinquedos' OR
	p.product_category_name  = 'esporte_lazer' OR
	p.product_category_name  = 'cama_mesa_banho' OR
	p.product_category_name  = 'moveis_escritorio') 
GROUP BY p.product_category_name 	




















