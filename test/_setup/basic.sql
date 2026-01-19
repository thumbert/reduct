
CREATE TABLE basic (
    hour_beginning TIMESTAMPTZ NOT NULL,
    as_of DATE NOT NULL,
    resource_type ENUM('solar', 'wind', 'hydro', 'storage') NOT NULL,
    resource_id INTEGER NOT NULL,
    location VARCHAR,
    price DECIMAL(9,4),
    start_time TIME NOT NULL,
);

INSERT INTO basic (hour_beginning, as_of, resource_type, resource_id, location, price, start_time) VALUES
('2023-01-01 00:00:00-05:00', '2023-01-01', 'solar', 1, 'LocationA', 45.67, '00:00:00'),
('2023-01-10 01:00:00-05:00', '2023-01-10', 'wind', 2, 'LocationB', 38.90, '01:00:00'),
('2023-02-01 02:00:00-05:00', '2023-02-01', 'hydro', 3, 'LocationC', 50.12, '02:00:00'),
('2023-03-01 03:00:00-05:00', '2023-03-01', 'storage', 4, 'LocationD', 60.45, '03:00:00');