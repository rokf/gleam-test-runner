FROM ghcr.io/gleam-lang/gleam:v0.30.5-erlang-alpine

# Install packages required to run the tests
RUN apk add --no-cache jq coreutils

WORKDIR /opt/test-runner
COPY . .

# Download the used Gleam packages eagerly as the test runner will not have
# network access to do so. They are also pre-compiled for performance when
# compiling test projects.
RUN cd packages \
  && gleam deps download \
  && gleam fix build/packages --target erlang \
  && gleam build

ENTRYPOINT ["/opt/test-runner/bin/run.sh"]
