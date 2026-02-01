FROM python:3.13.11-slim

ARG APP_DIR=/app

WORKDIR ${APP_DIR}

COPY ./models/final/ ${APP_DIR}/models/final/
COPY ./src ${APP_DIR}/src
COPY ./api.py ${APP_DIR}/api.py
COPY ./uv.lock ${APP_DIR}/uv.lock
COPY ./pyproject.toml ${APP_DIR}/pyproject.toml

# install dependencies without dev dependencies and without creating a virtual env
RUN pip install uv
RUN uv pip install -r pyproject.toml --extra cpu --no-cache --torch-backend cpu --system

EXPOSE 80
CMD ["fastapi", "run", "/app/api.py", "--port", "80"]
