package handlers


import (
	"context"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgxpool"
)

type Handler struct {
	db *pgxpool.Pool
}

func New(db *pgxpool.Pool) *Handler {
	return &Handler{db: db}
}

func (h *Handler) GetMessages(c *gin.Context) {
	rows, err := h.db.Query(context.Background(), "SELECT id, message FROM messages")
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	defer rows.Close()

	type Message struct {
		ID      int    `json:"id"`
		Message string `json:"message"`
	}

	var msgs []Message
	for rows.Next() {
		var m Message
		if err := rows.Scan(&m.ID, &m.Message); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		msgs = append(msgs, m)
	}

	c.JSON(http.StatusOK, msgs)
}
