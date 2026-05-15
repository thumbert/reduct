
CREATE TABLE basic (
    hour_beginning TIMESTAMPTZ NOT NULL,
    as_of DATE NOT NULL,
    resource_type ENUM('solar', 'wind', 'hydro', 'storage') NOT NULL,
    resource_id INTEGER NOT NULL,
    location VARCHAR,
    price DECIMAL(9,4),
    mw FLOAT,
    start_time TIME NOT NULL,
);

INSERT INTO basic (hour_beginning, as_of, resource_type, resource_id, location, price, mw, start_time) VALUES
('2023-01-01 00:00:00-05:00', '2023-01-01', 'solar', 1, 'LocationA', 45.67, 100.5, '00:00:00'),
('2023-01-10 01:00:00-05:00', '2023-01-10', 'wind', 2, 'LocationB', 38.90, 200.0, '01:00:00'),
('2023-02-01 02:00:00-05:00', '2023-02-01', 'hydro', 3, 'LocationC', 50.12, 150.0, '02:00:00'),
('2023-03-01 03:00:00-05:00', '2023-03-01', 'storage', 4, 'LocationD', 60.45, 250.0, '03:00:00');