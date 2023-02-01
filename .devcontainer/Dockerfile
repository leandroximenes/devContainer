FROM node:18

ARG HTTP_PROXY="http://10.166.133.81:3128"
ARG NO_PROXY="localhost, 127.0.0.0/8, ::1, 10.0.0.0/8, *.eb.mil.br"
ENV HTTPS_PROXY ${HTTP_PROXY}
ENV HTTP_PROXY ${HTTP_PROXY}
ENV FTP_PROXY ${HTTP_PROXY}
RUN echo "Acquire::https::Proxy \"$HTTP_PROXY\";" >> /etc/apt/apt.conf
RUN echo "Acquire::http::Proxy \"$HTTP_PROXY\";" >> /etc/apt/apt.conf
RUN echo "Acquire::ftp::Proxy \"$HTTP_PROXY\";" >> /etc/apt/apt.conf
RUN npm config set proxy ${HTTP_PROXY}
RUN npm config set https-proxy ${HTTP_PROXY}

# Install basic development tools
RUN apt update && apt install -y less man-db sudo

# Ensure default `node` user has access to `sudo`
ARG USERNAME=node
RUN echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Set `DEVCONTAINER` environment variable to help with orientation
ENV DEVCONTAINER=true
USER node