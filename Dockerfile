FROM ubuntu:latest   # ❌ Misconfiguration: latest tag, not pinned
USER root            # ❌ Misconfiguration: runs as root

RUN apt-get update && apt-get install -y nginx
CMD ["nginx", "-g", "daemon off;"]
