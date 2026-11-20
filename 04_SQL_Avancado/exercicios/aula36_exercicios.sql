-- 1. Total de vendas por categoria com WITH
WITH tabela AS (SELECT
	p.product_category_name as categoria,
	SUM(op.payment_value) AS total
FROM
	products p INNER JOIN order_items oi ON (p.product_id = oi.product_id)
	INNER JOIN order_payments op ON (op.order_id  = oi.order_id)
WHERE categoria is not NULL
GROUP BY p.product_category_name
)
SELECT
	t.categoria,
	t.total
FROM
	tabela t

-- 2. Receita total por mês e o mês de maior receita
WITH receita_mes AS (
    SELECT strftime('%Y-%m', o.order_approved_at) AS mes,
           SUM(op.payment_value)                  AS receita
    FROM order_payments op
    INNER JOIN orders o ON o.order_id = op.order_id
    WHERE o.order_approved_at IS NOT NULL
    GROUP BY strftime('%Y-%m', o.order_approved_at)
)
SELECT mes, ROUND(receita, 2) AS receita
FROM receita_mes
ORDER BY receita DESC
LIMIT 1;


-- 3. Duas CTEs: total de vendas por estado e por cidade


WITH table_estado AS (SELECT c.customer_state AS estado, SUM(op.payment_value) AS total_estado
FROM
	orders o INNER JOIN customer c ON (c.customer_id  = o.customer_id)
	INNER JOIN order_payments op ON (o.order_id = op.order_id)
GROUP BY c.customer_state
), table_cidade AS(
	SELECT c.customer_city  AS cidade, c.customer_state as estado, SUM(op.payment_value) AS total_cidade
	FROM
		orders o INNER JOIN customer c ON (c.customer_id  = o.customer_id)
		INNER JOIN order_payments op ON (o.order_id = op.order_id)
	GROUP BY c.customer_state ,c.customer_city
)
SELECT tc.estado, tc.cidade, tc.total_cidade, te.total_estado
FROM table_cidade tc INNER JOIN table_estado te ON (tc.estado  = te.estado)


-- 4. Por categoria: preço, data limite de envio, primeira compra da categoria
--    e dias entre a primeira compra e cada venda
WITH tabela_compra as (SELECT
		p.product_category_name as categoria,
		oi.price as preco,
		DATE(oi.shipping_limit_date) as data_envio,
		DATE(FIRST_VALUE(oi.shipping_limit_date) OVER (PARTITION BY p.product_category_name ORDER BY oi.shipping_limit_date )) as primeira_compra
	FROM
		products p
		INNER JOIN order_items oi ON (oi.product_id  = p.product_id)
	WHERE p.product_category_name IS NOT NULL
)
SELECT tc.categoria, tc.preco, tc.data_envio,tc.primeira_compra,
		 julianday(tc.data_envio) - julianday(tc.primeira_compra) AS dias_desde_primeira
FROM tabela_compra tc
