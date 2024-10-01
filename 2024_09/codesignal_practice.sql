/*markdown
# Airline Seat Reservation Question

You work for an airline, and you've been tasked with improving the procedure for reserving and buying seats.
You have the table seats, which describes seats in the airplane. It has the following columns:
- seat_no - The unique number of the seat;
- status - The status of the seat (0 indicates free, 1 indicates reserved, and 2 indicates purchased);
- person_id - The ID of the person who reserved/purchased this seat (0 if the corresponding status is 0).

You also have the table requests, which contains the following columns:
- request_id - The unique ID of the request;
- request - The description of the request (1 indicates reserve, 2 indicates purchase);
- seat_no - The number of the seat that the person want to reserve/purchase;
- person_id - The ID of the person who wants to reserve/purchase this seat.

A person can reserve/purchase a free seat and can purchase a seat that they have reserved.

Your task is to return the table seats after the given requests have been performed.

Note: requests are applied from the lowest request_id; it's guaranteed that all values of seat_no in the table requests are presented in the table seats.
*/

/*markdown
Example

For the given tables seats
|seat_no |	status |	person_id|
|---------|-----------|-----|
|1 |	1 |	1|
|2 |	1 	|2|
|3 |	0 	|0|
|4 	|2 |	3|
|5 |	0 |	0|

and requests
|request_id 	|request 	|seat_no |	person_id|
|---------|-----------|-----|---|
|1 	|1 |	3 |	4|
|2 	|2 	|2 	|5|
|3 |	|2 |	1| 	1|

the output should be
|seat_no 	|status 	|person_id|
|---------|-----------|-----|
|1 	|2 	|1|
|2 	|1 	|2|
|3 	|1 	|4|
|4 	|2 	|3|
|5 	|0 	|0|

The first request is completed because seat number 3 is free. The second request is ignored because seat number 2 is already reserved by another person. The third request is completed because seat number 1 was reserved by this person, so they can purchase it.
*/

CREATE TABLE seats (
    seat_no INT PRIMARY KEY,
    status INT,
    person_id INT
);
INSERT INTO seats (seat_no, status, person_id) VALUES
(1, 1, 1),
(2, 1, 2),
(3, 0, 0),
(4, 2, 3),
(5, 0, 0);

CREATE TABLE requests (
    request_id INT PRIMARY KEY,
    request INT,
    seat_no INT,
    person_id INT
);
INSERT INTO requests (request_id, request, seat_no, person_id) VALUES
(1, 1, 3, 4),
(2, 2, 2, 5),
(3, 2, 1, 1);



select * from seats;

select * from requests;

/*markdown
## soln 1
*/

/* Write your SQL here. Terminate each statement with a semicolon. */
    with requests1 as(
        select *,count(*) from request
    ),
    result1 AS (
        SELECT request_id, s.seat_no, r.request AS status, r.person_id
        FROM seats s
        JOIN requests r ON s.seat_no = r.seat_no
        WHERE (s.person_id = r.person_id OR s.person_id = 0)
        ORDER BY s.seat_no
        )
        
    SELECT seat_no, status, person_id  FROM result1
    UNION 
    SELECT seats.seat_no, seats.status,seats.person_id from seats
    WHERE (seats.seat_no not in (select seat_no from result1)) 
    order by seat_no ;

/*markdown
## soln 2
*/

/* Write your SQL here. Terminate each statement with a semicolon. */
UPDATE seats
JOIN requests r ON seats.seat_no = r.seat_no
SET seats.status = r.request, seats.person_id = r.person_id
WHERE ((r.person_id = seats.person_id and r.person_id !=0) OR seats.person_id = 0) 
    and r.request >=seats.status+1;


SELECT * FROM seats
ORDER BY seat_no;

/*markdown
## soln 3
*/

-- 假设我们在数据库中操作，以下是一个可能的SQL实现：

-- 首先处理预定请求（request = 1）
UPDATE seats s
    JOIN requests r ON s.seat_no = r.seat_no
    SET s.status = 1, s.person_id = r.person_id
    WHERE r.request = 1
        AND s.status = 0;  -- 座位必须是空闲状态才能被预定



UPDATE seats s
JOIN requests r ON s.seat_no = r.seat_no
SET s.status = 2
WHERE r.request = 2
    AND s.status = 1  -- 座位必须是已被预定状态
    AND s.person_id = r.person_id;  -- 座位的预定者必须是请求者自己


  SELECT * from seats;


/*markdown
## note

- https://stackoverflow.com/questions/78216176/airline-seat-assignment-procedure-in-sql
- https://github.com/krishnadey30/LeetCode-Questions-CompanyWise/blob/master/capital-one_2year.csv
*/