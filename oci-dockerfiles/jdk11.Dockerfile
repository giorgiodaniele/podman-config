FROM maven:3.5.4-jdk-11
COPY bperRootCA.crt /tmp/bperRootCA.crt

# install BPER CA certificate
RUN  keytool -import -trustcacerts \
    -alias bperRootCA \
    -file /tmp/bperRootCA.crt \
    -keystore /usr/lib/jvm/java-11-openjdk-$(dpkg --print-architecture)/lib/security/cacerts \
    -storepass changeit \
    -noprompt && rm -f /tmp/bperRootCA.crt

