FROM defradigital/cdp-perf-test-docker:latest

WORKDIR /opt/perftest

# Install JMeter Plugins (Dummy Sampler + dependencies) from Maven Central
RUN set -eux; \
    JMETER_EXT=$(find / -name "ApacheJMeter_core.jar" -type f 2>/dev/null | head -1 | xargs dirname); \
    if [ -z "$JMETER_EXT" ]; then echo "ERROR: Cannot locate JMeter lib/ext directory" && exit 1; fi; \
    echo "JMeter ext directory: $JMETER_EXT"; \
    curl -fSL -o "$JMETER_EXT/jmeter-plugins-dummy-0.4.jar" \
      "https://repo1.maven.org/maven2/kg/apc/jmeter-plugins-dummy/0.4/jmeter-plugins-dummy-0.4.jar"; \
    curl -fSL -o "$JMETER_EXT/jmeter-plugins-cmn-jmeter-0.7.jar" \
      "https://repo1.maven.org/maven2/kg/apc/jmeter-plugins-cmn-jmeter/0.7/jmeter-plugins-cmn-jmeter-0.7.jar"; \
    ls -l "$JMETER_EXT/"*plugin* "$JMETER_EXT/"*cmn* || true

COPY scenarios/ ./scenarios/
COPY entrypoint.sh .
COPY user.properties .

ENV S3_ENDPOINT=https://s3.eu-west-2.amazonaws.com

ENTRYPOINT [ "./entrypoint.sh" ]
