package main

import (
	"fmt"
	"go_bbs/db"
	"go_bbs/server"
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
)

var Router *gin.Engine

func main() {
	db.Init()
	err := godotenv.Load(fmt.Sprintf("./%s.env", os.Getenv("GO_ENV")))
	if err != nil {
		panic(err)
	}

	if os.Getenv("ENV") == "prod" {
		gin.SetMode(gin.ReleaseMode)
	} else {
		gin.SetMode(gin.DebugMode)
	}

	r := gin.Default()

	r = server.Router(r)

	// Not Found
	r.NoRoute(func(c *gin.Context) {
		c.JSON(http.StatusNotFound, gin.H{"message": "Page not Found"})
	})

	r.Run()
	db.Close()
}
