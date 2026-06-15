-- Users Table
CREATE TABLE users (
    user_id      SERIAL PRIMARY KEY,
    full_name    VARCHAR(100) NOT NULL,
    email        VARCHAR(100) NOT NULL,
    role         VARCHAR(50)  NOT NULL,
    phone_number VARCHAR(20)
);

-- Matches Table
CREATE TABLE matches (
    match_id            SERIAL PRIMARY KEY,
    fixture             VARCHAR(150)   NOT NULL,
    tournament_category VARCHAR(100)   NOT NULL,
    base_ticket_price   NUMERIC(10,2)  NOT NULL,
    match_status        VARCHAR(50)    NOT NULL
);

-- Bookings Table
CREATE TABLE bookings (
    booking_id     SERIAL PRIMARY KEY,
    user_id        INT REFERENCES users(user_id),
    match_id       INT REFERENCES matches(match_id),
    seat_number    VARCHAR(10),
    payment_status VARCHAR(20),
    total_cost     NUMERIC(10,2) NOT NULL
);

-- Sample Data: Users
INSERT INTO users VALUES
(1, 'Tanvir Rahman', 'tanvir@mail.com', 'Football Fan',   '+8801711111111'),
(2, 'Asif Haque',   'asif@mail.com',   'Football Fan',   '+8801722222222'),
(3, 'Sajjad Rahman','sajjad@mail.com',  'Ticket Manager', '+8801733333333'),
(4, 'Jannat Ara',   'jannat@mail.com',  'Football Fan',   NULL);

-- Sample Data: Matches
INSERT INTO matches VALUES
(101,'Real Madrid vs Barcelona','Champions League',150,'Available'),
(102,'Man City vs Liverpool',   'Premier League',  120,'Selling Fast'),
(103,'Bayern Munich vs PSG',    'Champions League',130,'Available'),
(104,'AC Milan vs Inter Milan', 'Serie A',          90,'Sold Out'),
(105,'Juventus vs Roma',        'Serie A',          80,'Available');

-- Sample Data: Bookings
INSERT INTO bookings VALUES
(501,1,101,'A-12','Confirmed',150),
(502,1,102,'B-04','Confirmed',120),
(503,2,101,'A-13','Confirmed',150),
(504,2,101, NULL,  NULL,      150),
(505,3,102,'C-20','Pending',  120);