CREATE TABLE reviews (
                         review_id SERIAL PRIMARY KEY,
                         staff_id INT NOT NULL,
                         review_text TEXT NOT NULL,
                         created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);