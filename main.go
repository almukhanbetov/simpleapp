package main

import (
	"log"
	"os"

	"simpleapp/internal/db"
	"simpleapp/internal/handlers"

	"github.com/gin-gonic/gin"
)

func main() {
	dsn := os.Getenv("DATABASE_URL")
	if dsn == "" {
		log.Fatal("DATABASE_URL is not set")
	}

	// подключение к БД
	pool := db.InitDB(dsn)
	defer pool.Close()

	// инициализация хендлеров
	h := handlers.New(pool)

	r := gin.Default()
	r.GET("/health", func(c *gin.Context) {
		c.JSON(200, gin.H{"status": "ok"})
	})
	r.GET("/messages", h.GetMessages)

	log.Println("server started on :8080")
	r.Run(":8080")
}
