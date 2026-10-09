select u.user_id,u.username, SUM(t.total_amount) as lifetime_spend 
from users as u
join transactions as t on u.user_id = t.user_id
group by u.user_id,u.username
order by lifetime_spend DESC
limit 10;
