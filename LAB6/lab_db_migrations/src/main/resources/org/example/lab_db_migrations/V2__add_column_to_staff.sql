ALTER TABLE reviews
    ADD COLUMN rating NUMERIC(2,1) DEFAULT 0.0;

ALTER TABLE reviews
    ADD COLUMN status VARCHAR(20) DEFAULT 'new';

ALTER TABLE reviews
    ADD COLUMN is_anonymous BOOLEAN DEFAULT false;