# Base image
FROM debian:bookworm-slim AS build

# Build variables
ARG SAMBA_VERSION

# Environment variables
ENV SAMBA_VERSION=${SAMBA_VERSION}
ENV DEBIAN_FRONTEND="noninteractive"
ENV PATH="$PATH:/usr/local/samba/bin:/usr/local/samba/sbin"

# Download Samba sources
ADD https://download.samba.org/pub/samba/samba-${SAMBA_VERSION}.tar.gz /

# Extract the source code
RUN tar xvf /samba-${SAMBA_VERSION}.tar.gz

# Install build dependancies
RUN bash /samba-${SAMBA_VERSION}/bootstrap/generated-dists/debian12/bootstrap.sh

# Build and install Samba
FROM build
RUN cd /samba-${SAMBA_VERSION} && ./configure && make -j $(nproc) && make install 
RUN rm -rf /samba-${SAMBA_VERSION} /samba-${SAMBA_VERSION}.tar.gz
