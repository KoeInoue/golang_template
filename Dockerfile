FROM golang:1.15.13-alpine3.12 as builder

ENV CGO_ENABLED=1
ENV GOOS=linux
ENV GOARCH=amd64
ENV GO111MODULE on
ENV ROOT=/go/src/app

WORKDIR ${ROOT}

RUN apk update \
    && apk add git \
    gcc \
    musl-dev \
    upx \
    && apk add --no-cache ca-certificates && update-ca-certificates \
    && apk add --no-cache tzdata && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    apk del tzdata \
    && go get -u github.com/cosmtrek/air@latest \
    && go get -u bitbucket.org/liamstask/goose/cmd/goose \
    && go get github.com/pwaller/goupx

COPY app/go.mod app/go.sum ./
RUN go mod download

COPY ./app ${ROOT}

EXPOSE 8080
