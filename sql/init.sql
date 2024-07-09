-- dealerships table
CREATE TABLE dealerships (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- rooftops table
CREATE TABLE rooftops (
    id SERIAL PRIMARY KEY,
    dealership_id INT REFERENCES dealerships(id),
    location VARCHAR(100) NOT NULL,
    api_key VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- vehicles table
CREATE TABLE vehicles (
    id SERIAL PRIMARY KEY,
    rooftop_id INT REFERENCES rooftops(id),
    make VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    year INT NOT NULL,
    vin VARCHAR(17) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- customers table
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- sales table
CREATE TABLE sales (
    id SERIAL PRIMARY KEY,
    vehicle_id INT REFERENCES vehicles(id),
    customer_id INT REFERENCES customers(id),
    rooftop_id INT REFERENCES rooftops(id),
    sale_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    sale_price NUMERIC(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX idx_vehicles_make_model_year ON vehicles(make, model, year);
CREATE INDEX idx_customers_last_name ON customers(last_name);

-- Enable RLS
ALTER TABLE rooftops ENABLE ROW LEVEL SECURITY;
ALTER TABLE sales ENABLE ROW LEVEL SECURITY;
ALTER TABLE vehicles ENABLE ROW LEVEL SECURITY;

-- Create policies for API key based access
CREATE POLICY rooftop_policy ON rooftops
USING (api_key = current_setting('app.api_key'));

CREATE POLICY vehicle_policy ON vehicles
USING (rooftop_id IN (SELECT id FROM rooftops WHERE api_key = current_setting('app.api_key')));

CREATE POLICY sales_policy ON sales
USING (rooftop_id IN (SELECT id FROM rooftops WHERE api_key = current_setting('app.api_key')));
