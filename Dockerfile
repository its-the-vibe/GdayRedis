# ── Build stage ──────────────────────────────────────────────────────────────
FROM golang:1.26.6 AS builder

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -trimpath -ldflags="-s -w" -o /gdayredis ./cmd/gdayredis

# ── Runtime stage (distroless) ────────────────────────────────────────────────
FROM gcr.io/distroless/static-debian12:nonroot

COPY --from=builder /gdayredis /gdayredis

ENTRYPOINT ["/gdayredis"]
