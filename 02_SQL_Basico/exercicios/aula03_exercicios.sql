-- 1. Clientes únicos de MG
SELECT
	COUNT (DISTINCT c.customer_id ) as clientes_mineiros
FROM 
	customer c 
WHERE 
	c.customer_state = 'MG'

	
-- 2. Cidades únicas de vendedores de SC
SELECT
	COUNT (DISTINCT s.seller_city) AS cidades_catarinenses 
FROM
	sellers s 
WHERE 
	s.seller_state  = 'SC'

	
-- 3. Cidades únicas de todos os vendedores

SELECT 
	COUNT (DISTINCT s.seller_city) AS cidades_unicas
FROM 
	sellers s 


-- 4. Pedidos únicos com preço acima de 3500

SELECT 
	COUNT( DISTINCT oi.order_id ) 
FROM 
	order_items oi  
 WHERE 
 	oi.price >3500



-- 5. Preço médio
 
 SELECT 
 	AVG(oi.price  ) as avg_price
FROM 
	order_items oi  


-- 6. Maior preço
	
SELECT 
 	MAX(oi.price  ) as avg_price
FROM 
	order_items oi 

-- 7. Menor preço
	
SELECT 
 	MIN(oi.price ) as avg_price
FROM 
	order_items oi  

	
-- 8. Produtos distintos vendidos abaixo de 100
SELECT 
	COUNT (DISTINCT oi.product_id)
FROM 
	order_items oi 
WHERE 
	oi.price < 100

	
-- 9. Vendedores distintos com pedido antes de 23/09/2016
SELECT 
	COUNT(DISTINCT oi.seller_id)
FROM 
	order_items oi 
WHERE 
	oi.shipping_limit_date < '2016-09-24'
	
-- 10. Tipos de pagamento existentes
SELECT 
	DISTINCT op.payment_type as tipos_pgtoconf 
FROM 
	order_payments op 

-- 11. Maior número de parcelas
SELECT
	MAX(op.payment_installments) as max_parcelas 
FROM 
	order_payments op 


-- 12. Menor número de parcelas
SELECT
	MIN(op.payment_installments) as mIN_parcelas 
FROM 
	order_payments op 


-- 13. Média paga no cartão de crédito
SELECT 
	AVG(op.payment_value) as media_credit_card
FROM 
	order_payments op 
WHERE op.payment_type = 'credit_card'
	


-- 14. Quantidade de status de pedido
SELECT
	COUNT(DISTINCT o.order_status)
FROM
	orders o
	
-- 15. Quais os status de pedido
	
SELECT
	DISTINCT o.order_status as tipos_status
FROM
	orders o
	
	
-- 16. Clientes distintos que fizeram pedido
SELECT 
	COUNT (DISTINCT o.customer_id ) as clientes_distintos
FROM
	orders o

	
-- 17. Produtos cadastrados
SELECT 
	COUNT(DISTINCT p.product_id)
FROM 
	products p 
	
	
-- 18. Maior número de fotos de um produto
SELECT
	MAX(p.product_photos_qty) AS qtd_photos_max
FROM 
	products p 
	
-- 19. Maior peso entre os produtos
SELECT
	MAX(p.product_weight_g ) AS peso_max
FROM 
	products p 	
	
-- 20. Altura média dos produtos

SELECT 
	AVG(p.product_height_cm) as altura_media_cm
FROM 
	products p 
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

