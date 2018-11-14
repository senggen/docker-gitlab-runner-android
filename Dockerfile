FROM  senggen/android

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

ADD run.sh /home/gitlab-runner/run.sh
RUN chmod +x /home/gitlab-runner/run.sh
    
ENTRYPOINT ["/usr/bin/dumb-init", "/home/gitlab-runner/run.sh"]
CMD ["run", "--user=root", "--working-directory=/home/gitlab-runner"]
