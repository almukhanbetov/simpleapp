-- +goose Up
CREATE TABLE messages (
    id SERIAL PRIMARY KEY,
    message TEXT NOT NULL
);

INSERT INTO messages (message) VALUES ('Hello from Goose');

-- +goose Down
DROP TABLE messages;
