use ig_clone;

-- Que 1. We want to reward our users who have been around the longest. Find the 5 oldest users.
select * from users
order by created_at
limit 5;

-- Que 2. What day of the week do most users register on ? We need to figure out when to schedule an ad campgain
select
	dayname(created_at) as day,
    count(*) as total
from users
group by day
order by total desc
limit 2;

-- Active users
select *
from users
inner join photos
	on users.id = photos.user_id;

-- Que 3. We want to target our inactive users with an email campgain. Find users who have never posted a photo.
select
	u.username 
    -- , p.image_url
from users u
left join photos p
	on u.id = p.user_id
where p.image_url is null; -- or p.id is null

-- Que 4. We're running a new contest to see who can get the most likes on a single photo. Who won ?
select
	p.id,
    p.image_url,
    count(*) as total_likes
from photos p
inner join likes l
	on l.photo_id = p.id
group by p.id
order by total_likes desc
limit 1;

select
	u.username,
	p.id,
    p.image_url,
    count(*) as total_likes
from photos p
inner join likes l
	on l.photo_id = p.id
inner join users u
	on p.user_id = u.id
group by p.id
order by total_likes desc
limit 1;

-- Que 5. Our investors want to know, how many times does the average user post ?
select
	(select count(*) from photos) / (select count(*) from users)
    as avg;
    
-- Que 6. A brand wants to know which hashtags to use in a post, What are the top 5 most commonly used hashtags?
select 
    t.tag_name,
    count(*) as total_count
from tags t
join photo_tags pt
	on pt.tag_id = t.id
group by t.id
order by total_count desc
limit 5;

-- Que 7. We have a small problem with bots on our site, Find users who have liked every single photo on the site.
select
	u.username,
    count(*) as num_likes
from users u
inner join likes l
	on u.id = l.user_id
group by l.user_id
having num_likes = (select count(*) from photos);