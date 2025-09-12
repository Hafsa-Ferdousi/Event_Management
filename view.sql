
--Top_Bookings

CREATE VIEW Top_Bookings AS
SELECT 
    b.booking_id,
    c.client_type,
    pe.name AS client_name,
    pt.name AS package_name,
    pt.price AS booking_price
FROM Booking b
JOIN Client c ON c.client_id = b.client_id
JOIN Person pe ON pe.person_id = c.client_id
JOIN Package_Table pt ON pt.package_id = b.package_id;
SELECT *
FROM Top_Bookings
ORDER BY booking_price DESC;


--Pending_Payments
SELECT * FROM Pending_Payments;
CREATE VIEW Pending_Payments AS
SELECT 
    p.payment_id,
    c.client_id,
    pe.name AS client_name,
    i.invoice_id,
    p.amount,
    p.status,
    p.method,
    b.booking_date
FROM Payment p
JOIN Invoice i ON i.invoice_id = p.invoice_id
JOIN Booking b ON b.booking_id = i.booking_id
JOIN Client c ON c.client_id = b.client_id
JOIN Person pe ON pe.person_id = c.client_id
WHERE p.status = 'Pending';


--Vendor_Performance

CREATE VIEW Vendor_Performance AS
SELECT 
    v.vendor_id,
    v.name AS vendor_name,
    COUNT(s.service_id) AS services_provided,
    AVG(v.rating) AS avg_rating
FROM Vendor v
LEFT JOIN Service s ON v.vendor_id = s.vendor_id
GROUP BY v.vendor_id, v.name;
select * from Vendor_Performance;