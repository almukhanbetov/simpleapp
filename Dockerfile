FROM golang:1.22-alpine AS build

WORKDIR /app

# Установим goose (через go install)
RUN go install github.com/pressly/goose/v3/cmd/goose@latest

# Скопируем исходники
COPY . .

# Собираем бинарник приложения
RUN go build -o simpleapp ./main.go

# ---------------------------
FROM alpine:3.19

WORKDIR /app

# Установим зависимости для goose (bash, psql)
RUN apk add --no-cache bash postgresql-client

# Скопируем goose из build stage
COPY --from=build /go/bin/goose /usr/local/bin/goose

# Скопируем бинарь приложения и миграции
COPY --from=build /app/simpleapp /app/
COPY --from=build /app/migrations /app/migrations

EXPOSE 8080

CMD ["/app/simpleapp"]
