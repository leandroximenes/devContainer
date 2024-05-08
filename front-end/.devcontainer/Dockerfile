FROM node:18

# Instalar o redis-cli
RUN apt-get update && apt-get install -y redis-tools sudo

# Install gh cli
RUN mkdir -p -m 755 /etc/apt/keyrings && wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
    && chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt update \
    && apt install gh -y

# Update npm
RUN npm install -g npm

# Install nestjs
RUN npm i -g @nestjs/cli

# Ensure default `node` user has access to `sudo`
ARG USERNAME=node
RUN echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Custom bash instruction to run in container. Ex: put branch name in bash
COPY start-container /usr/local/bin/start-container
RUN chmod +x /usr/local/bin/start-container


# Change to `node` user
USER node

# Set workdir
WORKDIR /app/notification-service

# Expose port 3000
EXPOSE 3000

# Set the entrypoint to start-container script
ENTRYPOINT ["/usr/local/bin/start-container"]

CMD ["tail", "-f", "/dev/null"]

