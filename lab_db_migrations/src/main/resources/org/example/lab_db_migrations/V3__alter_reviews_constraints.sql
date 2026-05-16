ALTER TABLE reviews
    ALTER COLUMN review_text SET NOT NULL;

ALTER TABLE reviews
    ADD CONSTRAINT chk_reviews_rating
        CHECK (rating >= 0 AND rating <= 5);

ALTER TABLE reviews
    ADD CONSTRAINT chk_reviews_status
        CHECK (status IN ('new', 'approved', 'rejected'));