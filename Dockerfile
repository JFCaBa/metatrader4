FROM debian:bullseye

# Set environment
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y \
    wget \
    gnupg2 \
    software-properties-common && \
    mkdir -pm755 /etc/apt/keyrings && \
    wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key

# Add WineHQ repository
RUN wget -nc https://dl.winehq.org/wine-builds/debian/dists/bullseye/winehq-bullseye.sources && \
    mv winehq-bullseye.sources /etc/apt/sources.list.d/

# Install Wine
RUN apt-get update && \
    apt-get install -y --install-recommends winehq-stable && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create working directory
WORKDIR /mt4
ENV HOME=/mt4
ENV WINEPREFIX=/mt4/.mt4
ENV DISPLAY=:2

# Download MetaTrader 4
RUN wget https://download.mql5.com/cdn/web/metaquotes.software.corp/mt4/mt4oldsetup.exe -O mt4setup.exe

# Copy install script
COPY install-mt4.sh /mt4/
RUN chmod +x /mt4/install-mt4.sh

CMD ["/bin/bash"]
