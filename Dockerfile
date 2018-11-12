FROM  tracer0tong/android-emulator

RUN (while sleep 3; do echo "y"; done) | android update sdk --no-ui --all --filter build-tools-22.0.2,android-22,extra-android-m2repository

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ADD minidemo.tar.gz /root
RUN chmod +x /root/minidemo/gradlew && \
    /root/minidemo/gradlew build && \
    rm -rf /root/minidemo

ADD https://github.com/Yelp/dumb-init/releases/download/v1.0.2/dumb-init_1.0.2_amd64 /usr/bin/dumb-init
RUN chmod +x /usr/bin/dumb-init

RUN apt-get update -y && \
    apt-get install -y curl && \
    curl -s https://packages.gitlab.com/install/repositories/runner/gitlab-ci-multi-runner/script.deb.sh | bash && \
    apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y gitlab-ci-multi-runner && \
    apt-get clean && \
    apt-get autoremove -y && \
rm -rf /var/lib/apt/lists/*
    
VOLUME ["/etc/gitlab-runner", "/home/gitlab-runner"]
ENTRYPOINT ["/usr/bin/dumb-init", "gitlab-ci-multi-runner"]
CMD ["run", "--user=root", "--working-directory=/home/gitlab-runner"]
