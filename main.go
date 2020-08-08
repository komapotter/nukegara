package main

import (
	"net"
	"net/http"
	"os"

	"github.com/labstack/echo"
	"github.com/labstack/echo/middleware"

	echotrace "gopkg.in/DataDog/dd-trace-go.v1/contrib/labstack/echo"
	"gopkg.in/DataDog/dd-trace-go.v1/ddtrace/tracer"
)

func main() {
	addr := net.JoinHostPort(
		os.Getenv("DD_AGENT_HOST"),
		os.Getenv("DD_TRACE_AGENT_PORT"),
	)

	tracer.Start(tracer.WithAgentAddr(addr))
	//tracer.Start(tracer.WithAgentAddr(addr), tracer.WithAnalytics(true))
	defer tracer.Stop()

	e := echo.New()

	e.Use(middleware.Logger())
	e.Use(middleware.Recover())
	e.Use(echotrace.Middleware(echotrace.WithServiceName("my-web-app")))

	e.GET("/", func(c echo.Context) error {
		return c.String(http.StatusOK, "Hello, Nukegara World!(v0.0.2)")
	})
	e.POST("/dummy-post", func(c echo.Context) error {
		return c.String(http.StatusCreated, "Dummy Post Succeeded!")
	})

	e.Logger.Fatal(e.Start(":1323"))
}
