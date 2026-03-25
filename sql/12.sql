/* 
 * A new James Bond movie will be released soon, and management wants to send promotional material to "action fanatics".
 * They've decided that an action fanatic is any customer where at least 4 of their 5 most recently rented movies are action movies.
 *
 * Write a SQL query that finds all action fanatics.
 */
SELECT customer.customer_id, first_name, last_name
FROM customer
JOIN LATERAL (
    SELECT film_id
    FROM rental
    JOIN inventory USING (inventory_id)
    WHERE rental.customer_id = customer.customer_id
    ORDER BY rental_date DESC
    LIMIT 5
) AS recent_films ON true
JOIN film_category USING (film_id)
JOIN category USING (category_id)
WHERE category.name = 'Action'
GROUP BY customer.customer_id, first_name, last_name
HAVING count(*) >= 4
ORDER BY customer.customer_id;
