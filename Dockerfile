FROM  senggen/android

ADD minidemo.tar.gz /root
RUN chmod +x /root/minidemo/gradlew && \
    /root/minidemo/gradlew build && \
    rm -rf /root/minidemo

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
    
ENTRYPOINT ["/home/gitlab-runner/run.sh"]
