FROM runmymind/docker-android-sdk
    
ADD minidemo/ minidemo
WORKDIR minidemo
RUN cd minidemo && \
    chmod +x ./gradlew && \
    ./gradlew lint && \
    rm -rf minidemo
    
VOLUME ["/etc/gitlab-runner", "/home/gitlab-runner"]
ENTRYPOINT ["/usr/bin/dumb-init", "gitlab-ci-multi-runner"]
CMD ["run", "--user=root", "--working-directory=/home/gitlab-runner"]
