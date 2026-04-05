FROM python:3.12-alpine
WORKDIR /app
COPY requirements.txt .
RUN apk add --no-cache libpq-dev gcc musl-dev
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 8000
CMD ["gunicorn", "lesson4.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "3"]