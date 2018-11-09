FROM openjdk:8-jdk

ENV ANDROID_COMPILE_SDK "22"
ENV ANDROID_BUILD_TOOLS "22.0.2"
ENV ANDROID_SDK_TOOLS   "4333796"

RUN apt-get --quiet update --yes && \
    apt-get --quiet install --yes wget tar unzip lib32stdc++6 lib32z1 && \
    wget --quiet --output-document=android-sdk.zip https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_TOOLS}.zip && \
    unzip -d android-sdk-linux android-sdk.zip && \
    echo y | android-sdk-linux/tools/bin/sdkmanager "platforms;android-${ANDROID_COMPILE_SDK}" >/dev/null && \
    echo y | android-sdk-linux/tools/bin/sdkmanager "platform-tools" >/dev/null && \
    echo y | android-sdk-linux/tools/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS}" >/dev/null && \
    export ANDROID_HOME=$PWD/android-sdk-linux && \
    export PATH=$PATH:$PWD/android-sdk-linux/platform-tools/ && \
    chmod +x ./gradlew && \
    set +o pipefail && \
    yes | android-sdk-linux/tools/bin/sdkmanager --licenses && \
    set -o pipefail && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*
    
ADD minidemo/ minidemo
WORKDIR minidemo
RUN cd minidemo && \
    chmod +x ./gradlew && \
    ./gradlew && \
    rm -rf minidemo
    
VOLUME ["/etc/gitlab-runner", "/home/gitlab-runner"]
ENTRYPOINT ["/usr/bin/dumb-init", "gitlab-ci-multi-runner"]
CMD ["run", "--user=root", "--working-directory=/home/gitlab-runner"]
