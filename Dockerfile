FROM python:3.12-alpine

# Забороняємо Python створювати .pyc файли та буферизувати вивід (важливо для логів K8s)
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

COPY requirements.txt .

# Встановлюємо залежності оптимізовано
RUN apk add --no-cache postgresql-libs && \
    apk add --no-cache --virtual .build-deps gcc musl-dev postgresql-dev && \
    pip install --no-cache-dir -r requirements.txt && \
    apk --purge del .build-deps

COPY . .

# Створюємо користувача без прав root для безпеки (Best Practice для Kubernetes)
RUN adduser -D django_user && \
    chown -R django_user:django_user /app

# Перемикаємось на цього користувача
USER django_user

EXPOSE 8000

CMD ["gunicorn", "lesson4.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "3"]