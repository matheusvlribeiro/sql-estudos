-- ============================================================
-- SQL Intermediário: JOINs e subqueries (banco da Olist)
-- Consultas minhas, organizadas por tema.
-- ============================================================


-- ------------------------------------------------------------
-- JOINs
-- ------------------------------------------------------------

-- 1. INNER JOIN em 3 tabelas: itens de pedidos de clientes de SP
SELECT
	c.customer_city  AS cidade,
	c.customer_state AS estado,
	o.order_id       AS pedido_id,
	o.order_status   AS status,
	oi.product_id    AS produto_id,
	oi.price         AS preco
FROM customer c
	INNER JOIN orders o       ON (c.customer_id = o.customer_id)
	INNER JOIN order_items oi ON (o.order_id    = oi.order_id)
WHERE c.customer_state = 'SP'
LIMIT 20;


-- 2. INNER JOIN em 5 tabelas: pedido, cliente, categoria, preço e vendedor
SELECT
	o.order_id               AS id_pedido,
	c.customer_state         AS estado,
	c.customer_city          AS cidade,
	p.product_category_name  AS categoria,
	oi.price                 AS preco,
	s.seller_city            AS cidade_vendedor,
	s.seller_state           AS estado_vendedor
FROM customer c
	INNER JOIN orders o       ON (c.customer_id = o.customer_id)
	INNER JOIN order_items oi ON (o.order_id    = oi.order_id)
	INNER JOIN products p     ON (oi.product_id = p.product_id)
	INNER JOIN sellers s      ON (oi.seller_id  = s.seller_id)
WHERE DATE(o.order_approved_at) >= '2016-09-16'
LIMIT 80;


-- 3. Top 10 vendedores com mais clientes distintos
SELECT
	s.seller_id,
	COUNT(DISTINCT c.customer_id) AS num_clientes
FROM customer c
	INNER JOIN orders o       ON (c.customer_id = o.customer_id)
	INNER JOIN order_items oi ON (oi.order_id   = o.order_id)
	INNER JOIN sellers s      ON (oi.seller_id  = s.seller_id)
GROUP BY s.seller_id
ORDER BY num_clientes DESC
LIMIT 10;


-- 4. LEFT JOIN para achar o que falta: pedidos sem nenhum item
SELECT COUNT(DISTINCT o.order_id) AS pedidos_sem_item
FROM orders o
	LEFT JOIN order_items oi ON (o.order_id = oi.order_id)
WHERE oi.order_id IS NULL;
-- 775 pedidos (na grande tabela só aparecem com LEFT JOIN)


-- 5. LEFT JOIN: pedidos sem avaliação
SELECT COUNT(*) AS pedidos_sem_avaliacao
FROM orders o
	LEFT JOIN order_reviews t ON (t.order_id = o.order_id)
WHERE t.order_id IS NULL;
-- 0: todo pedido tem avaliação


-- ------------------------------------------------------------
-- Cardinalidade: testando hipóteses antes de juntar
-- ------------------------------------------------------------

-- 6. Pedidos com mais de uma avaliação (1:N entre orders e order_reviews)
SELECT
	o.order_id,
	COUNT(DISTINCT t.review_id) AS num_reviews
FROM orders o
	LEFT JOIN order_reviews t ON (o.order_id = t.order_id)
GROUP BY o.order_id
HAVING COUNT(DISTINCT t.review_id) > 1;
-- 555 pedidos


-- 7. Pedidos com mais de um vendedor: sem DISTINCT o número fica inflado
SELECT o.order_id, COUNT(s.seller_id) AS num_vendedores
FROM orders o
	LEFT JOIN order_items oi ON (o.order_id  = oi.order_id)
	LEFT JOIN sellers s      ON (oi.seller_id = s.seller_id)
GROUP BY o.order_id
HAVING num_vendedores > 1;
-- 9.803 (errado: o mesmo vendedor é contado uma vez por unidade comprada)

SELECT o.order_id, COUNT(DISTINCT s.seller_id) AS num_vendedores
FROM orders o
	LEFT JOIN order_items oi ON (o.order_id  = oi.order_id)
	LEFT JOIN sellers s      ON (oi.seller_id = s.seller_id)
GROUP BY o.order_id
HAVING num_vendedores > 1;
-- 1.278 (certo)


-- ------------------------------------------------------------
-- Subqueries
-- ------------------------------------------------------------

-- 8. No SELECT: cada item ganha o preço médio geral para comparação
SELECT
	oi.order_id,
	oi.price,
	(SELECT AVG(price) FROM order_items) AS preco_medio_geral
FROM order_items oi
LIMIT 10;


-- 9. No WHERE: itens com preço acima da média
SELECT COUNT(*) AS itens_acima_da_media
FROM order_items oi
WHERE oi.price > (SELECT AVG(price) FROM order_items);


-- 10. No WHERE com IN: pedidos pagos com boleto (e a mesma resposta com JOIN)
SELECT COUNT(*) AS num_pedidos
FROM orders o
WHERE o.order_id IN (SELECT op.order_id
                     FROM order_payments op
                     WHERE op.payment_type = 'boleto');

SELECT COUNT(DISTINCT o.order_id) AS num_pedidos
FROM orders o
	INNER JOIN order_payments op ON (op.order_id = o.order_id)
WHERE op.payment_type = 'boleto';


-- 11. No FROM: média de itens por pedido
SELECT AVG(t.num_itens) AS media_itens_por_pedido
FROM (SELECT order_id, COUNT(*) AS num_itens
      FROM order_items
      GROUP BY order_id) t;


-- 12. No FROM: ticket médio (valor médio do pedido) por status
SELECT
	order_status,
	COUNT(*)                    AS num_pedidos,
	ROUND(AVG(total_pedido), 2) AS ticket_medio
FROM (SELECT o.order_id, o.order_status, SUM(oi.price) AS total_pedido
      FROM orders o
      JOIN order_items oi ON oi.order_id = o.order_id
      GROUP BY o.order_id, o.order_status) t
GROUP BY order_status
ORDER BY num_pedidos DESC;


-- 13. Só com subqueries aninhadas: categoria do produto de maior preço
--     (de dentro para fora: maior preço -> produto -> categoria)
SELECT p.product_category_name
FROM products p
WHERE p.product_id IN (SELECT oi.product_id
                       FROM order_items oi
                       WHERE oi.price IN (SELECT MAX(oi2.price)
                                          FROM order_items oi2));
