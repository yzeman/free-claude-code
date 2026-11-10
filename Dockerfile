FROM python:3.14.10-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    UV_LINK_MODE=copy \
    SETUPTOOLS_SCM_PRETEND_VERSION=0.0.0

RUN pip install --no-cache-dir "uv>=0.13.7"

WORKDIR /app

COPY pyproject.toml uv.lock README.md LICENSE ./
COPY src ./src

RUN uv sync --frozen --no-dev

ENV PATH="/app/.venv/bin:$PATH" \
    HOME=/tmp/fcc-home

RUN useradd --system --create-home --home-dir /tmp/fcc-home --shell /usr/sbin/nologin fcc \
    && chown -R fcc:fcc /app /tmp/fcc-home

USER fcc

EXPOSE 10000

CMD ["fcc-server"]
