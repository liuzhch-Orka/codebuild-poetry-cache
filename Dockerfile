FROM public.ecr.aws/docker/library/python:3.10.13-bullseye
RUN apt-get update && apt-get install -y git tree
RUN tree -d -L 5 /root/.cache/pypoetry/virtualenvs
RUN pip install poetry
WORKDIR /codebuild-poetry-cache
COPY pyproject.toml poetry.lock ./
RUN poetry env use 3.10.13
RUN tree -d -L 5 /root/.cache/pypoetry/virtualenvs
RUN --mount=type=ssh poetry install -vvv --without dev
RUN tree -d -L 5 /root/.cache/pypoetry/virtualenvs
RUN poetry run python -c "import django; print(django)"
COPY . .
RUN tree -d -L 5 /root/.cache/pypoetry/virtualenvs
RUN poetry run python -c "import django; print(django)"
CMD ["poetry", "run", "python"]
