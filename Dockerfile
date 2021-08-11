FROM jenkins/inbound-agent

ARG DOCKERVERSION="5:20.10.8~3-0~debian-buster"

USER root

# install docker
RUN apt-get update \
    && apt-get install -y apt-transport-https ca-certificates curl gnupg-agent lsb-release software-properties-common \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    && apt-get install -y docker-ce=$DOCKERVERSION docker-ce-cli=$DOCKERVERSION containerd.io \
    && usermod -aG docker jenkins

# install nodejs
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash \
    && export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")" \
    && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" \
    && nvm install 14.17.1 \
    && npm install -g yarn

USER jenkins
