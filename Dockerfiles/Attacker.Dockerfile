FROM golang:1.19-rc-alpine

# Install iproute2 and add default route to suricata
RUN apk update && apk add iproute2 gcc

COPY ./go /app

COPY ../pcaps/ /pcap

WORKDIR /app

#RUN go get && go build -o main

#CMD ["./main /pcap/UCAP172.31.31.69.7 $TARGET_IP"]