FROM python:3.9-alpine

WORKDIR /app

COPY . .

RUN pip install Flask

EXPOSE 8080

CMD ["python", "main.py"]