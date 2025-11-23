CREATE TABLE data_2022_dec (
    event_time TIMESTAMPTZ,
    event_type TEXT,
    product_id INTEGER,
    price NUMERIC(10,2),
    user_id BIGINT,
    user_session UUID
);
