# Базовый образ Python (в нем уже установлен Python, pip и прочее)
FROM python:3.10

# Создаем директорию /code и переходим в нее
WORKDIR /code

# Копируем файл с зависимостями
COPY requirements.txt .
# Устанавливаем через pip зависимости
RUN pip install -r requirements.txt

# Копируем код приложения
COPY app.py .
# Копируем код приложения
COPY migrations migrations

# Копируем специальный конфиг и подменяем дефолтный
COPY docker_config.py default_config.py

# Указываем команду, которая будет запущена командой docker run
CMD flask run -h 0.0.0.0 -p 80

