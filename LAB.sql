use sakila;

CREATE VIEW customer_summary_report AS
SELECT r.customer_id, c.first_name, c.email,count(*) AS rental_count FROM rental AS r
JOIN customer AS c
ON c.customer_id = r.customer_id
GROUP BY r.customer_id;

CREATE TEMPORARY TABLE sakila.temp_customer_table
SELECT cs.customer_id, SUM(amount) AS total_amount FROM customer_summary_report AS cs
JOIN payment AS p
ON p.customer_id = cs.customer_id
GROUP BY customer_id;


WITH cte_customer_table AS(
    SELECT csr.*,tc.total_amount AS total_paid FROM sakila.customer_summary_report AS csr
    JOIN sakila.temp_customer_table AS tc
    ON csr.customer_id = tc.customer_id
)
SELECT * FROM cte_customer_table;