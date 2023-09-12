FROM debian:bookworm-slim

HEALTHCHECK NONE

# Install dependencies
RUN apt-get update && apt-get install -y bzip2 ca-certificates curl libarchive13 lib32gcc-s1 locales p7zip-full tar unzip wget xz-utils
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
RUN locale-gen --no-purge en_US.UTF-8
RUN apt-get clean
RUN rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

# Set up user enviornment
RUN useradd --home /app --gid root --system SteamCMD
RUN mkdir /app && mkdir /games
RUN chown SteamCMD:root -R /app && chown SteamCMD:root -R /games

USER SteamCMD

WORKDIR /app

# Download SteamCMD; run it once for self-updates
RUN wget -qO- http://media.steampowered.com/installer/steamcmd_linux.tar.gz | tar xz -C /app
RUN chmod +x /app/steamcmd.sh
RUN /app/steamcmd.sh +force_install_dir /games +login anonymous +quit

ONBUILD USER root
