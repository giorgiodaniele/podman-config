FROM maven:3.5.4-jdk-8
COPY bperRootCA.crt /tmp/bperRootCA.crt

# install BPER CA certificate
RUN  keytool -import -trustcacerts \
    -alias bperRootCA    \
    -file /tmp/bperRootCA.crt \
    -keystore /usr/lib/jvm/java-8-openjdk-$(dpkg --print-architecture)/jre/lib/security/cacerts \
    -storepass changeit \
    -noprompt && rm -f /tmp/bperRootCA.crt
