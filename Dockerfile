FROM golang:1.16.0 as build

# Build executable
WORKDIR /go/src/github.com/sdillen/nvidia_gpu_prometheus_exporter
COPY . .
RUN make docker_build

# Build non-root
FROM alpine:3.13.2

# Link dependencies
RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

# Create group and user
RUN addgroup -g 10001 exporter && adduser -u 10001 -G exporter -S exporter

## Non-root executable
USER 10001
COPY --from=build --chown=10001:10001 /nvidia_gpu_prometheus_exporter /nvidia_gpu_prometheus_exporter

EXPOSE 9445

ENTRYPOINT ["/nvidia_gpu_prometheus_exporter"]