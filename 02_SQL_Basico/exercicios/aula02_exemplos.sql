-- 1. Id, cidade e estado de todos os clientes
SELECT 
	c.customer_id, 
	c.customer_city, 
	c.customer_state   
FROM 
	customer c
	
-- 2. Id e cidade dos clientes de SC
SELECT 
	c.customer_id, 
	c.customer_city 
FROM 
	customer c 
WHERE 
	c.customer_state = 'SC'

	
-- 3. Id e estado dos clientes de Florianópolis
	
SELECT 
	c.customer_id,
	c.customer_state 
FROM 
	customer c 
WHERE 
	c.customer_city = 'florianopolis'


-- 4. Estado, latitude e longitude de SP

SELECT
	g.geolocation_state, 
	g.geolocation_lat, 
	g.geolocation_lng
FROM
	geolocation g
WHERE 
	g.geolocation_state = 'SP'
 
	
-- 5. Produto, data limite de envio e preço, só preço acima de 6300

	SELECT 
		oi.product_id,
		oi.shipping_limit_date,
		oi.price 
	FROM 
		order_items oi 
	 WHERE
	 	oi.price > 6300
	

-- 6. Pedido, tipo de pagamento e parcelas, só parcelas menores que 1

SELECT
	op.order_id,
	op.payment_type,
	op.payment_installments 
FROM 

	order_payments op
WHERE 
	op.payment_installments < 1


-- 7. Pedido, cliente, status e aprovação, só aprovados até 05/10/2016
SELECT
	o.order_id,
	o.customer_id,
	o.order_status,
	o.order_approved_at 
FROM 
	orders o
WHERE 
	o.order_approved_at <= '2016-10-06'



	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
