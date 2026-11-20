-- 1. Faixa de preço (A a E) de cada produto com CASE WHEN
--    < 50 A | < 100 B | < 500 C | < 1500 D | resto E
SELECT
	oi.product_id as id,
	CASE WHEN oi.price < 50 THEN 'Categoria A'
		 WHEN oi.price < 100 THEN 'Categoria B'
		 WHEN oi.price < 500 THEN 'Categoria C'
		 WHEN oi.price < 1500 THEN 'Categoria D'
	ELSE 'Categoria E' END AS categoria
FROM
	order_items oi


-- 2. Quantidade de produtos em cada faixa (subquery no FROM)
SELECT s.categoria,
		COUNT(DISTINCT s.id) as num_produtos
FROM (SELECT
		oi.product_id as id,
		CASE WHEN oi.price < 50 THEN 'Categoria A'
			 WHEN oi.price < 100 THEN 'Categoria B'
			 WHEN oi.price < 500 THEN 'Categoria C'
			 WHEN oi.price < 1500 THEN 'Categoria D'
		ELSE 'Categoria E' END AS categoria
	FROM
		order_items oi
	) AS s
GROUP BY s.categoria

-- 3. Novo preço por categoria (desconto ou aumento) e coluna dizendo se o preço mudou
--    livros_tecnicos -10% | pet_shop -20% | pc_gamer +50% | tablets +10% | fashion_esporte +5%
SELECT s.product_id,
		s.novo_preco,
		CASE WHEN s.velho_preco = s.novo_preco THEN 'nao sofreu'
		ELSE 'sofreu' END AS alteracao
FROM (SELECT
			p.product_id,
			p.product_category_name,
			oi.price as velho_preco,
			CASE WHEN p.product_category_name = 'livros_tecnicos' THEN oi.price *0.9
				 WHEN p.product_category_name = 'pet_shop' THEN oi.price *0.8
				 WHEN p.product_category_name = 'pc_gamer' THEN oi.price *1.5
				 WHEN p.product_category_name = 'tablets_impressao_imagem' THEN oi.price *1.1
				 WHEN p.product_category_name = 'fashion_esporte' THEN oi.price *1.05
			ELSE oi.price END AS novo_preco
		FROM
			products p INNER JOIN order_items oi  ON (p.product_id = oi.product_id)
		WHERE p.product_category_name IN ('livros_tecnicos', 'pet_shop', 'pc_gamer', 'tablets_impressao_imagem', 'fashion_esporte', 'perfumaria', 'telefonia', 'beleza_saude', 'ferramentas_jardim')
	) AS s


-- 4. Status de entrega do pedido: pendente (sem data), entregue (até 01/06/2017) ou programado
SELECT
    o.order_id,
    o.order_delivered_customer_date,
    CASE
        WHEN o.order_delivered_customer_date IS NULL THEN 'pendente'
        WHEN o.order_delivered_customer_date <= '2017-06-01 00:00:00' THEN 'entregue'
        ELSE 'programado'
    END AS status
FROM orders o
