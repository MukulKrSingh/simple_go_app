# ---------- Build stage ----------
FROM golang:1.24.4-alpine AS builder

WORKDIR /app

# Enable static build
ENV CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

COPY go.mod  ./
RUN go mod download

COPY . .
RUN go build -o app

# ---------- Runtime stage ----------
FROM alpine:3.19

WORKDIR /app

COPY --from=builder /app/app .

EXPOSE 8080

CMD ["./app"]
