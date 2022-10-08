# syntax=docker/dockerfile:1.4

ARG BUILD_DATE=""
ARG VCS_REF=""
ARG VERSION=""

FROM alpine:3.16.2 AS build
MAINTAINER chriseth <chris@ethereum.org>
#Official solidity docker image

#Establish working directory as solidity
WORKDIR /solidity

# Build dependencies
RUN set -eux; \
     apk update; \
     apk --no-cache add \
     boost-dev boost-static build-base cmake git;

#Copy working directory on travis to the image
COPY / $WORKDIR

# Number of parallel jobs during build
# or 0 for auto-computing (max(1, CPU_core_count * 2/3), a greedy value)
ARG BUILD_CONCURRENCY="0"

#Install dependencies, eliminate annoying warnings
RUN sed -i -E -e 's/include <sys\/poll.h>/include <poll.h>/' /usr/include/boost/asio/detail/socket_types.hpp
RUN cmake -DCMAKE_BUILD_TYPE=Release -DTESTS=0 -DSOLC_LINK_STATIC=1
RUN make solc \
    -j$(awk "BEGIN {                                       \
        if (${BUILD_CONCURRENCY} != 0) {                   \
            print(${BUILD_CONCURRENCY});                   \
        } else {                                           \
            x=($(grep -c ^processor /proc/cpuinfo) * 2/3); \
            if (x > 1) {                                   \
                printf(\"%d\n\", x);                       \
            } else {                                       \
                print(1);                                  \
            }                                              \
        }                                                  \
    }")

RUN strip solc/solc

FROM scratch
COPY --from=build /solidity/solc/solc /usr/bin/solc
ENTRYPOINT ["/usr/bin/solc"]

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="Solidity" \
      org.label-schema.description="Solidity Compiler" \
      org.label-schema.url="https://soliditylang.org" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/etereum/solidityy.git" \
      org.label-schema.vendor="Ethereum" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"