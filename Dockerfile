# Copyright 2018 Google, Inc. All rights reserved.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM gcr.io/gcp-runtimes/ubuntu_16_0_4 as runtime_deps

RUN apt-get update && \
    apt-get install --no-install-recommends --no-install-suggests -y \
        python-dev \
	git

ENV EXEC_TEMPLATE_VERSION 1.0.0
RUN curl -LO https://github.com/groob/exec-template/releases/download/${EXEC_TEMPLATE_VERSION}/exec-template-linux-amd64 && \
    mv exec-template-linux-amd64 /usr/local/bin/exec-template && \
    chmod +x /usr/local/bin/exec-template

ENV CLOUD_SDK_VERSION 193.0.0
RUN curl -LO https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
 tar -zxvf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    CLOUDSDK_PYTHON="python2.7" /google-cloud-sdk/install.sh --usage-reporting=false \
        --bash-completion=false \
        --disable-installation-options


ENV PATH /usr/local/go/bin:/go/bin:/google-cloud-sdk/bin:${PATH}

FROM runtime_deps as builder

COPY --from=golang:1.10 /usr/local/go /usr/local/go
ENV PATH /usr/local/go/bin:/go/bin:${PATH}
ENV GOPATH /go/

WORKDIR /go/src/github.com/aaron-prindle/github-releaser

COPY . .

FROM builder as releasing

RUN go get github.com/aktau/github-release

CMD ["./hack/github-release.sh"]