FROM debian:10

WORKDIR /game-server
COPY . /game-server

EXPOSE 16001


CMD [ "./_builds/linux/linux_server.sh", "--server_port=16001" ]
