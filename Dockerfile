FROM ubuntu:focal
LABEL author="https://github.com/aBARICHELLO/godot-ci/graphs/contributors"

USER root
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    git-lfs \
    python \
    python-openssl \
    unzip \
    wget \
    zip \
    adb \
    openjdk-11-jdk-headless \
    rsync \
    && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ARG GODOT_VERSION="3.5"

RUN wget https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/beta5/Godot_v${GODOT_VERSION}-beta5_linux_headless.64.zip \
    && wget https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/beta5/Godot_v${GODOT_VERSION}-beta5_export_templates.tpz \
    && mkdir ~/.cache \
    && mkdir -p ~/.config/godot \
    && mkdir -p ~/.local/share/godot/templates/${GODOT_VERSION}.beta5 \
    && unzip Godot_v${GODOT_VERSION}-beta5_linux_headless.64.zip \
    && mv Godot_v${GODOT_VERSION}-beta5_linux_headless.64 /usr/local/bin/godot \
    && unzip Godot_v${GODOT_VERSION}-beta5_export_templates.tpz \
    && mv templates/* ~/.local/share/godot/templates/${GODOT_VERSION}.beta5 \
    && rm -f Godot_v${GODOT_VERSION}-beta5_export_templates.tpz Godot_v${GODOT_VERSION}-beta5_linux_headless.64.zip

ADD getbutler.sh /opt/butler/getbutler.sh
RUN bash /opt/butler/getbutler.sh
RUN /opt/butler/bin/butler -V

ENV PATH="/opt/butler/bin:${PATH}"

RUN godot -e -q

RUN mkdir -p /usr/src/game
WORKDIR /usr/src/game
