FROM python:3.13.11-slim

ARG APP_DIR=/app

WORKDIR ${APP_DIR}

COPY ./models/final/ ${APP_DIR}/models/final/
COPY ./src ${APP_DIR}/src
COPY ./api.py ${APP_DIR}/api.py
COPY ./poetry.lock ${APP_DIR}/poetry.lock
COPY ./pyproject.toml ${APP_DIR}/pyproject.toml

# install dependencies without dev dependencies and without creating a virtual env
RUN pip install poetry
RUN poetry config virtualenvs.create false
RUN poetry install --without dev --no-interaction --no-ansi

EXPOSE 80
CMD ["fastapi", "run", "/app/api.py", "--port", "80"]
