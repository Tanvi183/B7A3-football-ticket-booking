
-- DROP TABLES IF THEY ALREADY EXIST TO PREVENT CONFLICTS
DROP TABLE IF EXISTS Bookings;
DROP TABLE IF EXISTS Matches;
DROP TABLE IF EXISTS Users;

-- Users Table
CREATE TABLE Users (
    user_id      INT,
    full_name    VARCHAR(100) NOT NULL,
    email        VARCHAR(100) NOT NULL,
    role         VARCHAR(20)  NOT NULL,
    phone_number VARCHAR(20),


    CONSTRAINT pk_users PRIMARY KEY (user_id),
    CONSTRAINT uq_users_email UNIQUE (email),
    CONSTRAINT chk_users_role CHECK (role IN ('Ticket Manager', 'Football Fan'))
);

-- Matches Table
CREATE TABLE Matches (
    match_id            INT,
    fixture             VARCHAR(150) NOT NULL,
    tournament_category VARCHAR(50)  NOT NULL,
    base_ticket_price   DECIMAL(10, 2) NOT NULL,
    match_status        VARCHAR(20)  NOT NULL,


    CONSTRAINT pk_matches PRIMARY KEY (match_id),
    CONSTRAINT chk_matches_price CHECK (base_ticket_price >= 0),
    CONSTRAINT chk_matches_status CHECK (
        match_status IN ('Available', 'Selling Fast', 'Sold Out', 'Postponed')
    )
);

-- Bookings Table
CREATE TABLE Bookings (
    booking_id     INT,
    user_id        INT NOT NULL,
    match_id       INT NOT NULL,
    seat_number    VARCHAR(10),
    payment_status VARCHAR(20),
    total_cost     DECIMAL(10, 2) NOT NULL,

  
    CONSTRAINT pk_bookings PRIMARY KEY (booking_id),
    CONSTRAINT fk_bookings_user FOREIGN KEY (user_id)
        REFERENCES Users (user_id),
    CONSTRAINT fk_bookings_match FOREIGN KEY (match_id)
        REFERENCES Matches (match_id),
    CONSTRAINT chk_bookings_cost CHECK (total_cost >= 0),
    CONSTRAINT chk_bookings_status CHECK (
        payment_status IN ('Pending', 'Confirmed', 'Cancelled', 'Refunded')
    )
);



-- INSERT SAMPLE DATA INTO USERS
INSERT INTO Users (user_id, full_name, email, role, phone_number) VALUES
(1, 'Tanvir Rahman', 'tanvir@mail.com', 'Football Fan', '+8801711111111'),
(2, 'Asif Haque', 'asif@mail.com', 'Football Fan', '+8801722222222'),
(3, 'Sajjad Rahman', 'sajjad@mail.com', 'Ticket Manager', '+8801733333333'),
(4, 'Jannat Ara', 'jannat@mail.com', 'Football Fan', NULL);


-- INSERT SAMPLE DATA INTO MATCHES
INSERT INTO Matches (match_id, fixture, tournament_category, base_ticket_price, match_status) VALUES
(101, 'Real Madrid vs Barcelona', 'Champions League', 150.00, 'Available'),
(102, 'Man City vs Liverpool', 'Premier League', 120.00, 'Selling Fast'),
(103, 'Bayern Munich vs PSG', 'Champions League', 130.00, 'Available'),
(104, 'AC Milan vs Inter Milan', 'Serie A', 90.00, 'Sold Out'),
(105, 'Juventus vs Roma', 'Serie A', 80.00, 'Available');


-- INSERT SAMPLE DATA INTO BOOKINGS
INSERT INTO Bookings (booking_id, user_id, match_id, seat_number, payment_status, total_cost) VALUES
(501, 1, 101, 'A-12', 'Confirmed', 150.00),
(502, 1, 102, 'B-04', 'Confirmed', 120.00),
(503, 2, 101, 'A-13', 'Confirmed', 150.00),
(504, 2, 101, NULL, NULL, 150.00),
(505, 3, 102, 'C-20', 'Pending', 120.00);





-- SQL QUERIES --


-- Query 1: Retrieve all upcoming matches in the 'Champions League' where match status is 'Available'.

SELECT match_id, fixture, base_ticket_price
FROM Matches
WHERE tournament_category = 'Champions League'
  AND match_status = 'Available';


-- Query 2: Search users whose full_name starts with 'Tanvir' OR contains the phrase 'Haque' (case-insensitive). Concepts used: LIKE, ILIKE

SELECT user_id, full_name, email
FROM Users
WHERE full_name ILIKE 'Tanvir%'
   OR full_name ILIKE '%Haque%';


-- Query 3: Retrieve all booking records where payment_status is NULL, replacing the empty result with 'Action Required'. Concepts used: IS NULL, COALESCE

SELECT booking_id, user_id, match_id,
       COALESCE(payment_status, 'Action Required') AS systematic_status
FROM Bookings
WHERE payment_status IS NULL;


-- Query 4: Retrieve booking details along with the User's full name and the scheduled Match fixture. Concepts used: INNER JOIN

SELECT b.booking_id, u.full_name, m.fixture, b.total_cost
FROM Bookings b
INNER JOIN Users u ON b.user_id = u.user_id
INNER JOIN Matches m ON b.match_id = m.match_id
ORDER BY b.booking_id;


-- Query 5: Display all users and their booking IDs, ensuring that fans who have never bought a ticket are still listed. Concepts used: LEFT JOIN

SELECT u.user_id, u.full_name, b.booking_id
FROM Users u
LEFT JOIN Bookings b ON u.user_id = b.user_id
ORDER BY u.user_id, b.booking_id;



-- Query 6: Find all bookings where total_cost is strictly higher than the average cost of all bookings. Concepts used: Subquery, Aggregate function (AVG)

SELECT booking_id, match_id, total_cost
FROM Bookings
WHERE total_cost > (SELECT AVG(total_cost) FROM Bookings)
ORDER BY booking_id;



-- Query 7: Retrieve the top 2 most expensive matches by base_ticket_price, skipping the absolute highest premium match. Concepts used: ORDER BY, LIMIT, OFFSET (Pagination)

SELECT match_id, fixture, base_ticket_price
FROM Matches
ORDER BY base_ticket_price DESC
LIMIT 2 OFFSET 1;