-- 2. Hotel Booking System
-- Entities: hotels, rooms, customers, bookings

-- Requirements:

-- hotels: hotel_id, hotel_name (unique), location (not null), rating (1 to 5)

-- rooms: room_id, hotel_id (FK), room_type (ENUM: 'Standard', 'Deluxe', 'Suite'), price_per_night (> 0)

-- customers: customer_id, full_name, email (must have @), phone (10 digits)

-- bookings: booking_id, customer_id (FK), room_id (FK), checkin_date, checkout_date

-- 🧠 Constraints:

-- checkin_date < checkout_date

-- No room can be double-booked between dates (challenge: can be handled in advanced constraints/triggers later)