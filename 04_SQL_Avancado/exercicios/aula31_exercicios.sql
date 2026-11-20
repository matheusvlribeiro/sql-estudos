-- Comando para verificar a tabela inteira
PRAGMA table_info( order_items )

-- Comando para verificar todos os elementos da coluna
SELECT typeof( oi.order_id )
FROM order_items oi


-- 1. Média ponderada das avaliações dos pedidos aprovados a partir de 01/01/2018
--    pesos: nota 5 = 0.2 | 4 = 0.1 | 3 = 0.3 | 2 = 0.3 | 1 = 0.1
SELECT SUM(nota_x_peso) / SUM(peso) as media_ponderada
FROM (SELECT
			CASE WHEN t.review_score = 5 THEN t.review_score*0.2
			WHEN t.review_score = 4 THEN t.review_score*0.1
			WHEN t.review_score = 3 THEN t.review_score*0.3
			WHEN t.review_score = 2 THEN t.review_score*0.3
			WHEN t.review_score = 1 THEN t.review_score*0.1
			ELSE 0 END AS nota_x_peso,
			CASE WHEN t.review_score = 5 THEN 0.2
			WHEN t.review_score = 4 THEN 0.1
			WHEN t.review_score = 3 THEN 0.3
			WHEN t.review_score = 2 THEN 0.3
			WHEN t.review_score = 1 THEN 0.1
			ELSE 0 END AS peso
	  FROM order_reviews t INNER JOIN orders o ON (o.order_id = t.order_id)
	  WHERE DATE(o.order_approved_at) >= '2018-01-01'
	)


-- 2. A mesma média ponderada, agora por mês
SELECT mes, SUM(nota_x_peso) / SUM(peso) as media_ponderada
FROM (SELECT STRFTIME('%m', o.order_approved_at) AS mes,
			CASE WHEN t.review_score = 5 THEN t.review_score*0.2
			WHEN t.review_score = 4 THEN t.review_score*0.1
			WHEN t.review_score = 3 THEN t.review_score*0.3
			WHEN t.review_score = 2 THEN t.review_score*0.3
			WHEN t.review_score = 1 THEN t.review_score*0.1
			ELSE 0 END AS nota_x_peso,
			CASE WHEN t.review_score = 5 THEN 0.2
			WHEN t.review_score = 4 THEN 0.1
			WHEN t.review_score = 3 THEN 0.3
			WHEN t.review_score = 2 THEN 0.3
			WHEN t.review_score = 1 THEN 0.1
			ELSE 0 END AS peso
	  FROM order_reviews t INNER JOIN orders o ON (o.order_id = t.order_id)
	  WHERE DATE(o.order_approved_at) >= '2018-01-01'
	)
GROUP BY mes


-- 3. Desconto total, médio, mínimo, máximo e quantidade de produtos com desconto
--    livros_tecnicos 10% | pet_shop 20% | pc_gamer 50% | tablets 90% | fashion_esporte 40%
SELECT
	AVG(s.desconto) as desconto_medio,
	SUM(s.desconto) as desconto_total,
	MIN(s.desconto) as desconto_minimo,
	MAX(s.desconto) as desconto_maximo,
	SUM(IIF(s.desconto > 0, 1, 0)) AS qtd_com_desconto
FROM (SELECT
			CASE WHEN p.product_category_name = 'livros_tecnicos' THEN oi.price *0.1
				 WHEN p.product_category_name = 'pet_shop' THEN oi.price *0.2
				 WHEN p.product_category_name = 'pc_gamer' THEN oi.price*0.5
				 WHEN p.product_category_name = 'tablets_impressao_imagem' THEN oi.price *0.9
				 WHEN p.product_category_name = 'fashion_esporte' THEN oi.price *0.4
			ELSE 0 END AS desconto
		FROM
			products p INNER JOIN order_items oi  ON (p.product_id = oi.product_id)
		WHERE p.product_category_name IN ('livros_tecnicos', 'pet_shop', 'pc_gamer', 'tablets_impressao_imagem', 'fashion_esporte',
		'perfumaria', 'telefonia', 'beleza_saude', 'ferramentas_jardim')
	) AS s


-- 4. As mesmas métricas de desconto, agora por categoria
SELECT
	s.categoria,
	AVG(s.desconto) as desconto_medio,
	SUM(s.desconto) as desconto_total,
	MIN(s.desconto) as desconto_minimo,
	MAX(s.desconto) as desconto_maximo,
	SUM(IIF(s.desconto > 0, 1, 0)) AS qtd_com_desconto
FROM (SELECT
			p.product_category_name as categoria,
			CASE WHEN p.product_category_name = 'livros_tecnicos' THEN oi.price *0.1
				 WHEN p.product_category_name = 'pet_shop' THEN oi.price *0.2
				 WHEN p.product_category_name = 'pc_gamer' THEN oi.price*0.5
				 WHEN p.product_category_name = 'tablets_impressao_imagem' THEN oi.price *0.9
				 WHEN p.product_category_name = 'fashion_esporte' THEN oi.price *0.4
			ELSE 0 END AS desconto
		FROM
			products p INNER JOIN order_items oi  ON (p.product_id = oi.product_id)
		WHERE p.product_category_name IN ('livros_tecnicos', 'pet_shop', 'pc_gamer', 'tablets_impressao_imagem', 'fashion_esporte',
		'perfumaria', 'telefonia', 'beleza_saude', 'ferramentas_jardim')
	) AS s
GROUP BY s.categoria
