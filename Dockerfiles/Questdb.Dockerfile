FROM questdb/questdb:6.6.1

RUN apt-get update && apt-get install curl -y