FROM python:3.11-bookworm as Builder
RUN pip install --no-cache-dir --no-cache virtualenv
WORKDIR /awsebcli
RUN virtualenv --python=$(which python3) /opt/env
ENV PATH="/opt/env/bin:$PATH"
RUN pip install --no-cache-dir --no-cache awsebcli==3.20.10
FROM python:3.11-slim-bookworm
WORKDIR /awsebcli
COPY --from=Builder /opt/env /opt/env
ENV PATH="/opt/env/bin:$PATH"
ENV PYTHONUNBUFFERED=1
ENTRYPOINT [ "eb" ]