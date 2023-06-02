# syntax=docker/dockerfile:1.2
# Adapted from https://github.com/openscad/docker-openscad/blob/main/openscad/bookworm/Dockerfile

FROM debian:bookworm-slim AS debian-base

# Builder's libc6 version must match runtime
RUN apt-get -y update && apt-get -y upgrade && apt-get -y install libc6

FROM debian-base AS builder-deps

# Base setup
RUN apt-get -y update && \
	apt-get install -y --no-install-recommends \
	build-essential devscripts apt-utils apt-transport-https ca-certificates git wget jq

# Dev dependencies
RUN apt-get -y update && \
	apt-get -y install --no-install-recommends \
	build-essential curl libffi-dev  libxmu-dev cmake bison flex \
	git-core libboost-all-dev libmpfr-dev libboost-dev \
	libcairo2-dev  libeigen3-dev libcgal-dev libopencsg-dev libgmp3-dev \
	libgmp-dev imagemagick libfreetype6-dev libdouble-conversion-dev \
	gtk-doc-tools libglib2.0-dev gettext pkg-config ragel libxi-dev \
	libfontconfig-dev libzip-dev lib3mf-dev libharfbuzz-dev libxml2-dev \
	qtbase5-dev libqt5scintilla2-dev libqt5opengl5-dev libqt5svg5-dev \
	qtmultimedia5-dev libqt5multimedia5-plugins \
	libglew-dev

FROM builder-deps as builder


WORKDIR /openscad

COPY openscad .

RUN git submodule update --init
ARG GITHUB_USER=openscad
ARG GITHUB_REPO=openscad
ARG BRANCH=master
ARG REFS=heads
ARG OPENSCAD_VERSION=
ARG BUILD_TYPE=Release
ARG SNAPSHOT=ON
ARG JOBS=1
ARG COMMIT=true
RUN echo "Build type: ${BUILD_TYPE}"
RUN mkdir -p /build-results
WORKDIR build
RUN --mount=type=cache,target=/openscad/build cmake .. \
		-DCMAKE_INSTALL_PREFIX=/usr/local \
		-DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
		-DEXPERIMENTAL=${SNAPSHOT} \
		-DSNAPSHOT=${SNAPSHOT} \
		-DOPENSCAD_VERSION="$OPENSCAD_VERSION" \
		-DOPENSCAD_COMMIT="$OPENSCAD_COMMIT" \
		&& \
	make -j"$JOBS" \
	    && \
	cp -r . /build-results

FROM debian-base AS runtime-base

RUN apt-get -y update && apt-get install -y --no-install-recommends \
	libcairo2 libdouble-conversion3 libxml2 lib3mf1 libzip4 libharfbuzz0b \
	libboost-thread1.74.0 libboost-program-options1.74.0 libboost-filesystem1.74.0 \
	libboost-regex1.74.0 libopencsg1 libmpfr6 libqscintilla2-qt5-15 \
	libqt5multimedia5 libqt5concurrent5 libglu1-mesa \
	libglew2.1 xvfb xauth

RUN apt-get -y update && apt-get install -y gdb xterm

RUN apt-get clean

FROM runtime-base as runtime

RUN mkdir -p /root/.local/share/OpenSCAD/backups

WORKDIR /root
COPY .gdbinit .

WORKDIR /openscad
COPY startup.sh .
RUN chmod +x startup.sh

COPY --from=builder /openscad .
COPY --from=builder /build-results/openscad ./build

FROM runtime-base AS ctest

RUN apt-get -y update && apt-get install -y cmake python3 imagemagick

WORKDIR /openscad
COPY --from=builder /openscad .
COPY --from=builder /build-results/ ./build
WORKDIR ./build/tests