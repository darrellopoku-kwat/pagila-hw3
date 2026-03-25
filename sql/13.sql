/*
 * Management wants to create a "best sellers" list for each actor.
 *
 * Write a SQL query that:
 * For each actor, reports the three films that the actor starred in that have brought in the most revenue for the company.
 * (The revenue is the sum of all payments associated with that film.)
 *
 * HINT:
 * For correct output, you will have to rank the films for each actor.
 * My solution uses the `rank` window function.
 */
SELECT actor_id, first_name, last_name, film_id, title, rank, revenue
FROM actor
JOIN LATERAL (
    SELECT film_id, title, sum(amount) AS revenue, rank() OVER (ORDER BY sum(amount) DESC, film_id) AS rank
    FROM film_actor
    JOIN film USING (film_id)
    JOIN inventory USING (film_id)
    JOIN rental USING (inventory_id)
    JOIN payment USING (rental_id)
    WHERE film_actor.actor_id = actor.actor_id
    GROUP BY film_id, title
) AS top_films ON true
WHERE rank <= 3
ORDER BY actor_id, rank;
