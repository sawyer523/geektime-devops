FROM --platform=$TARGETPLATFORM golang:1.21-alpine3.18 AS builder

WORKDIR /src
COPY . /src

RUN mkdir -p bin/ && go build -gcflags='all=-trimpath=${PWD}' -asmflags='all=-trimpath=${PWD}' -o ./bin/service main.go


FROM --platform=$TARGETPLATFORM alpine:3.18

WORKDIR /app

RUN addgroup -S 9095 && adduser -S 9095 -G 9095 -u 9095
USER 9095
COPY --from=builder /src/bin /app


EXPOSE 9095

ENTRYPOINT ["./service"]
