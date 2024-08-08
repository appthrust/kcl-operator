FROM --platform=${BUILDPLATFORM} golang:1.22 AS build

# The TARGETOS and TARGETARCH args are set by docker. We set GOOS and GOARCH to
# these values to ask Go to compile a binary for these architectures. If
# TARGETOS and TARGETOS are different from BUILDPLATFORM, Go will cross compile
# for us (e.g. compile a linux/amd64 binary on a linux/arm64 build machine).
ARG TARGETOS
ARG TARGETARCH

ENV GO111MODULE=on \
    GOPROXY=https://goproxy.cn,direct

WORKDIR /

COPY . .

RUN GOOS=linux GOARCH=amd64 go build -o manager

FROM kcllang/kcl

WORKDIR /
COPY --from=builder /manager .

ENV KCL_FAST_EVAL=1
ENV LANG="en_US.UTF-8"

ENTRYPOINT ["/manager"]
