
use music
 /*
 1. Who is the senior most employee based on job title?
 */
select * from employee
order by levels desc
limit 1;

 /*
 2. Which countries have the most Invoices?
 */
select count(invoice_id) as count, billing_country  from invoice
group by  billing_country
order by count desc
limit 1

/*
3. What are top 3 values of total invoice?
*/
select total from invoice
order by total desc
limit 3
 

/*
4. Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. Write a query that returns one city that
has the highest sum of invoice totals. Return both the city name & sum of all invoice totals
*/
select billing_city, sum(total) from invoice
group by billing_city
order by sum(total) desc
limit 1

/*
5.Who is the best customer? The customer who has spent the most money will be declared the best customer. Write a query that returns the person who has spent the
most money 
*/
select sum(invoice.total) as sum, customer.first_name, customer.last_name from
customer
inner join
invoice
on customer.customer_id = invoice.customer_id
group by first_name, last_name
order by sum(total) desc
limit 1




/*---------------------------------Moderate--------------------------------------------*/

/*
6.Write query to return the email, first name, last name, & Genre of all Rock Music listeners. Return your list ordered alphabetically by email starting with A
*/

select first_name, last_name, email
from customer where  customer_id in (
select customer_id from invoice 
where invoice_id in (
select
invoice_id
from 
invoice_line
where track_id in (
	(select track_id from track
	where genre_id in (select genre_id
	from genre
	where name = 'rock')
))))
order by email

/*----------------------------//solution 2//-----------------------------------------*/
Select C.email,C.first_name,C.last_name,G.name
from 
customer as C
inner join
invoice
on c.customer_id = invoice.customer_id
inner join 
invoice_line
on invoice.invoice_id = invoice_line.invoice_id
inner join 
track
on 
invoice_line.track_id = track.track_id
inner join
genre as G
on
track.genre_id = G.genre_id
where G.name = 'rock'
Group by  C.email,C.first_name,C.last_name,G.name
order by c.email
 
/*
7.Let's invite the artists who have written the most rock music in our dataset. Write a query that returns the Artist name and total track count of the top 10 rock bands
*/
select artist.name, count(artist.name) from 
track
inner join
genre
on 
track.genre_id = genre.genre_id
inner join
album2
on
track.album_id = album2.album_id
inner join 
artist
on
album2.artist_id = artist.artist_id
where genre.name = 'rock'
group by artist.name

/*
8.Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent
*/

Find how much amount spent by each customer on artists? Write a query to return
customer name, artist name and total spent

select customer.first_name, customer.last_name, sum(invoice_line.unit_price*invoice_line.quantity), artist.name from 
customer
inner join
invoice
on
customer.customer_id = invoice.customer_id
inner join
invoice_line
on 
invoice.invoice_id = invoice_line.invoice_id
inner join
track
on
invoice_line.track_id = track.track_id
inner join
album2
on track.album_id = album2.album_id
inner join
artist
on
album2.artist_id = artist.artist_id
group by customer.first_name, customer.last_name, artist.name

/*
9. We want to find out the most popular music Genre for each country. We determine the
most popular genre as the genre with the highest amount of purchases. Write a query
that returns each country along with the top Genre. For countries where the maximum
number of purchases is shared return all Genres
*/
Select x.country,x.genre,x.count_2 from
(select customer.country as Country, genre.name as genre,  
genre.genre_id, 
count(invoice_line.invoice_line_id) as count_1, 
max(count(invoice_line.invoice_line_id)) over (partition by customer.country) as count_2
from customer
inner join
invoice
on
customer.customer_id = invoice.invoice_id
inner join
invoice_line
on
invoice.invoice_id = invoice_line.invoice_id
inner join
track
on 
invoice_line.track_id = track.track_id 
inner join
genre
on
track.genre_id = genre.genre_id

group by customer.country, genre.name, genre.genre_id
order by country, count_1 desc

)As X

where count_2 = count_1

/*
10.Write a query that determines the customer that has spent the most on music for each
country. Write a query that returns the country along with the top customer and how
much they spent. For countries where the top amount spent is shared, provide all
customers who spent this amount
*/

select x.country, x.customer_id, x.first_name, x.last_name, x.amount from
(select customer.country, customer.customer_id, customer.first_name, customer.last_name, invoice.total, max(invoice.total) over (partition by customer.country) as Amount from 
customer
inner join
invoice
on
customer.customer_id = invoice.invoice_id) as x
where x.total = x.Amount
order by amount desc
