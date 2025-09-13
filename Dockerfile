FROM golang:1.22-alpine AS build

WORKDIR /app

# Добавляем git, чтобы go install работал
RUN apk add --no-cache git

# Установим goose
RUN go install github.com/pressly/goose/v3/cmd/goose@latest

# Копируем исходники
COPY . .

# Собираем бинарник приложения
RUN go build -o simpleapp ./main.go

# ---------------------------
FROM alpine:3.19

WORKDIR /app

# Устанавливаем bash и клиент PostgreSQL (psql)
RUN apk add --no-cache bash postgresql-client

# Копируем goose из первого stage
COPY --from=build /go/bin/goose /usr/local/bin/goose

# Копируем бинарь приложения и миграции
COPY --from=build /app/simpleapp /app/
COPY --from=build /app/migrations /app/migrations

EXPOSE 8080

CMD ["/app/simpleapp"]
