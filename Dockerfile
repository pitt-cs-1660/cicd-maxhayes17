# create builder stage
FROM python:3.11-buster AS builder

# set wd
WORKDIR /app

# install poetry and upgrade pip
RUN pip install --upgrade pip && pip install poetry

# copy pyproject.toml and poetry.lock to builder stage
COPY pyproject.toml poetry.lock ./

# start building in builder stage
RUN poetry config virtualenvs.create false \
    && poetry install --no-root --no-interaction --no-ansi

# create app stage
FROM python:3.11-buster AS app

WORKDIR /app

# copy application code from builder stage to app stage
COPY --from=builder /app /app

# expose port 8000 for FastAPI
EXPOSE 8000

# set entrypoint to entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# set cmd for FastAPI
CMD [ "uvicorn", "cc_compose.server:app", "--reload", "--host", "0.0.0.0", "--port", "8000" ]