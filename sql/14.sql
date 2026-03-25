/*
 * Management also wants to create a "best sellers" list for each category.
 *
 * Write a SQL query that:
 * For each category, reports the five films that have been rented the most for each category.
 *
 * Note that in the last query, we were ranking films by the total amount of payments made,
 * but in this query, you are ranking by the total number of times the movie has been rented (and ignoring the price).
 */
SELECT name, title, count AS "total rentals"
FROM category
JOIN LATERAL (
    SELECT film_id, title, count(DISTINCT rental_id) AS count, rank() OVER (ORDER BY count(DISTINCT rental_id) DESC, film_id DESC) AS rank
    FROM film_category
    JOIN film USING (film_id)
    JOIN inventory USING (film_id)
    JOIN rental USING (inventory_id)
    WHERE film_category.category_id = category.category_id
    GROUP BY film_id, title
) AS top_films ON true
WHERE rank <= 5
ORDER BY name, count DESC, title;
