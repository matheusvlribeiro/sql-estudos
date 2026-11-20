# Estudos de SQL

Repositório com meus estudos de SQL, do básico ao avançado.
Aqui ficam só as **minhas** produções: PDFs didáticos de explicação e os exercícios resolvidos.

## Estrutura

| Pasta | O que tem |
|---|---|
| `01_SQL_Fundamentos/` | PDFs explicativos: database/schema, tabelas do dataset, DBeaver, resumo do módulo |
| `02_SQL_Basico/` | PDFs explicativos, resumo do módulo e exercícios (`exercicios/*.sql`) |
| `03_SQL_Intermediario/` | Resumo do módulo (JOINs, subqueries) |
| `04_SQL_Avancado/` | Resumo do módulo, resumo e guia completo de Window Functions e exercícios (`exercicios/*.sql`) |
| `Ebook_SQL_do_Basico_ao_Avancado.pdf` | Ebook de 71 páginas com tudo do curso, exemplos rodados na Olist e aplicações para ciência de dados |

## Dataset

Uso o dataset público [Brazilian E-Commerce (Olist)](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) do Kaggle.
Ele não está no repositório (arquivos grandes). Para reproduzir:

1. Baixe os CSVs do Kaggle e coloque em `Dataset/`.
2. Importe os CSVs no SQLite (por exemplo pelo DBeaver) criando `Dataset/db_olist.sqlite`.
3. Abra os arquivos `.sql` das pastas `exercicios/` conectado a esse banco.

## Ferramentas

SQLite + DBeaver.
