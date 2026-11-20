-- Exemplos das funções de janela (aulas 32 a 34)

SELECT
	p.product_category_name,
	op.payment_type,
	oi.shipping_limit_date,
	MIN ( oi.shipping_limit_date ) OVER ( PARTITION BY p.product_category_name, op.payment_type
										                    ORDER BY oi.shipping_limit_date  ) AS first_purchase
FROM order_items oi INNER JOIN products p ON ( p.product_id = oi.product_id )
					INNER JOIN order_payments op ON ( op.order_id = oi.order_id)
WHERE p.product_category_name IS NOT NULL

SELECT
	p.product_category_name,
	oi.price,
	ROW_NUMBER() OVER (PARTITION BY p.product_category_name ORDER BY oi.price DESC ) AS price_rank
FROM order_items oi INNER JOIN products p ON ( p.product_id = oi.product_id )
WHERE p.product_category_name IS NOT NULL
LIMIT 20


SELECT
	p.product_category_name,
	oi.price,
	RANK() OVER (PARTITION BY p.product_category_name ORDER BY oi.price DESC ) AS price_rank
FROM order_items oi INNER JOIN products p ON ( p.product_id = oi.product_id )
WHERE p.product_category_name IS NOT NULL
LIMIT 20

SELECT
	p.product_category_name,
	oi.price,
	DENSE_RANK() OVER (PARTITION BY p.product_category_name ORDER BY oi.price DESC ) AS price_rank
FROM order_items oi INNER JOIN products p ON ( p.product_id = oi.product_id )
WHERE p.product_category_name IS NOT NULL
LIMIT 20

SELECT
	p.product_category_name,
	oi.price,
	PERCENT_RANK() OVER (PARTITION BY p.product_category_name ORDER BY oi.price DESC ) AS price_rank
FROM order_items oi INNER JOIN products p ON ( p.product_id = oi.product_id )
WHERE p.product_category_name IS NOT NULL


SELECT
	p.product_category_name,
	oi.price,
	NTILE(40) OVER (PARTITION BY p.product_category_name ORDER BY oi.price DESC ) AS price_rank
FROM order_items oi INNER JOIN products p ON ( p.product_id = oi.product_id )
WHERE p.product_category_name IS NOT NULL


SELECT
	p.product_category_name,
	oi.price,
	oi.shipping_limit_date,
	LAG( oi.shipping_limit_date ) OVER ( PARTITION BY p.product_category_name
	                                     ORDER BY oi.shipping_limit_date DESC ) AS lag
FROM order_items oi INNER JOIN products p ON ( p.product_id = oi.product_id )
WHERE p.product_category_name IS NOT NULL


SELECT
	p.product_category_name,
	oi.price,
	oi.shipping_limit_date,
	FIRST_VALUE( oi.shipping_limit_date ) OVER ( PARTITION BY p.product_category_name ORDER BY oi.shipping_limit_date DESC ) AS first_purchase
FROM order_items oi INNER JOIN products p ON ( p.product_id = oi.product_id )
WHERE p.product_category_name IS NOT NULL


-- Exercícios

-- 1. Ranking dos produtos por preço médio dentro de cada categoria (a partir de 01/06/2018)
SELECT
    categoria,
    product_id,
    preco_medio,
    DENSE_RANK() OVER (PARTITION BY categoria ORDER BY preco_medio DESC) AS classificacao
FROM (
    SELECT
        p.product_category_name AS categoria,
        p.product_id,
        ROUND(AVG(oi.price), 2) AS preco_medio
    FROM products p INNER JOIN order_items oi ON (p.product_id = oi.product_id)
    WHERE DATE(oi.shipping_limit_date) >= '2018-06-01'
      AND p.product_category_name IS NOT NULL
    GROUP BY p.product_category_name, p.product_id
    )


-- 2. Total acumulado de vendas por data de compra


    SELECT
    	DATE(o.order_purchase_timestamp) AS data_compra,
    	op.payment_value  AS pagamento,
    	SUM(op.payment_value) OVER (ORDER BY DATE(o.order_purchase_timestamp)) as soma_acum
    FROM
    	orders o  INNER JOIN order_payments op  ON (o.order_id = op.order_id)


-- 3. Média móvel dos últimos três valores de venda (precisa de ROWS BETWEEN)

SELECT
    DATE(o.order_purchase_timestamp) AS data_compra,
    op.payment_value AS valor,
    AVG(op.payment_value) OVER (
        ORDER BY o.order_purchase_timestamp
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS media_movel
FROM orders o INNER JOIN order_payments op ON (o.order_id = op.order_id)


-- 4. Crescimento de produtos vendidos em relação ao dia anterior (LAG)
SELECT
	t.data_compra,
	t.num_produtos,
	t.num_produtos - t.vendas_anterior as crescimento
FROM (SELECT
		s.data_compra,
		s.num_produtos,
		LAG (s.num_produtos ) OVER (ORDER BY s.data_compra) as vendas_anterior
	FROM (SELECT
			DATE(o.order_approved_at) as data_compra,
			COUNT(oi.product_id) AS num_produtos
		FROM
			orders o INNER JOIN order_items oi ON (oi.order_id = o.order_id)
		WHERE data_compra IS NOT NULL
		GROUP BY data_compra
		ORDER BY data_compra
		) as s
	) as t

-- 4 (versão com uma subquery a menos)
SELECT
    data_compra,
    num_produtos,
    num_produtos - LAG(num_produtos) OVER (ORDER BY data_compra) AS crescimento
FROM (
    SELECT
        DATE(o.order_approved_at) AS data_compra,
        COUNT(oi.product_id) AS num_produtos
    FROM orders o INNER JOIN order_items oi ON (oi.order_id = o.order_id)
    WHERE o.order_approved_at IS NOT NULL
    GROUP BY data_compra
)


-- 5. Por estado do cliente e categoria: produtos vendidos e percentual em relação ao total do estado
SELECT
	s.estado,
	s.categoria,
	s.num_produtos,
	SUM(s.num_produtos) OVER (PARTITION BY s.estado) as total_estado,
	s.num_produtos * 100.0 / (SUM(s.num_produtos) OVER (PARTITION BY s.estado )) as porcentagem
FROM
	(SELECT
		c.customer_state as estado,
		p.product_category_name as categoria,
		COUNT(p.product_id ) as num_produtos
	FROM
		customer c
		INNER JOIN orders o ON (o.customer_id = c.customer_id)
		INNER JOIN order_items oi ON (oi.order_id  = o.order_id)
		INNER JOIN products p ON (p.product_id  = oi.product_id)
	WHERE p.product_category_name IS NOT NULL
	GROUP BY c.customer_state, p.product_category_name
	) AS s
