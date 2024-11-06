FROM python:3.11-bookworm as Builder
RUN pip install --no-cache-dir --no-cache virtualenv
WORKDIR /awsebcli
RUN virtualenv --python=$(which python3) /opt/env
ENV PATH="/opt/env/bin:$PATH"
RUN pip install --no-cache-dir --no-cache awsebcli==3.21
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    &&./aws/install --bin-dir /aws-cli-bin/
FROM python:3.11-slim-bookworm
WORKDIR /awsebcli
COPY --from=Builder /opt/env /opt/env
COPY --from=Builder /usr/local/aws-cli/ /usr/local/aws-cli/
COPY --from=Builder /aws-cli-bin/ /usr/local/bin/
ENV PATH="/opt/env/bin:$PATH"
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive \
    apt-get install --no-install-recommends -qqy --assume-yes \
    git \
    make \
    jq \
    && rm -rf /var/lib/apt/lists/* 

ENV PYTHONUNBUFFERED=1
ENTRYPOINT [ "eb" ]
