## flask_app_deploy

###Простейший проект на Flask с миграциями для курса Python разработки от SkyPro

###Ссылка на копию проекта в личном депозитории: https://github.com/Glassyflute/lessons-25_26_tasks

###Действия:
### 1. создаем Dockerfile с содержимым - и вручную добавляем файл docker_config.py с содержимым из видео-урока 
### (отсылка на PosgreSQL вместо sqlite), т.к. файла в изначальной подборке не было.

### 2. В директории с проектом запускаем команду, чтобы собрать образ:
#### docker build -t flask-app .

### 3. Запускаем команду ниже для сбора образа по PosgreSQL (уже есть в Docker Hub):
#### Игнорируем (ошибки): docker run --name postgres -e POSTGRES_PASSWORD=password -e POSTGRES_DB=flask-app -d postgres
#### Берем: docker run --network flask-app --network-alias postgres --name postgres -e POSTGRES_USER=flask-app -e POSTGRES_PASSWORD=password -e POSTGRES_DB=flask-app -d postgres
##### Параметр --name дает название контейнеру
##### Параметр -d запускает контейнер в фоновом режиме
##### Параметр -e – прокидывает переменные окружения внутрь контейнера
##### Для образа postgres существует много переменных окружения, с помощью которых
##### его можно настраивать. Но нам потребуется два:
##### POSTGRES_PASSWORD – пароль для пользователя postgres
##### POSTGRES_DB – название базы данных внутри сервера postgres

### 4. Создаем сеть, чтобы контейнеры видели друг друга:
#### docker network create flask-app
##### Если сеть существует, удаляем контейнер postgres, затем удаляем сеть 
##### через docker network rm flask-app
##### потом снова создаем сеть 

### Запускаем контейнер с БД внутри этой сети
#### Игнорируем (ошибка): docker run --network flask-app --network-alias postgres --name postgres -e POSTGRES_PASSWORD=password -e POSTGRES_DB=flask-app -d postgres
#### Делаем: docker run --network flask-app --network-alias postgres --name postgres -e POSTGRES_USER=flask-app -e POSTGRES_PASSWORD=password -e POSTGRES_DB=flask-app -d postgres
#### если есть активный контейнер, удаляем предварительно. 
##### Параметр --network подключает контейнер к сети
##### Параметр --network-alias дает сетевое имя контейнеру внутри этой сети 
##### Теперь к нему можно обращаться как к postgres



### Запускаем контейнер с API
#### docker run --network flask-app -p 8000:80 --name flask-app -d flask-app
##### Параметр -p – проброс портов. Внутри контейнера flask слушает на порту 80
##### Этим параметром мы совместили 8000 порт на хосте с 80 портом внутри контейнера
##### Игнорируем: Поэтому теперь мы можем открыть браузер, вбить http://localhost:8000 
##### и попасть на 80 порт контейнера. Коммент: Сам лектор имеет 500 ошибку на этом этапе и говорит, что ОК, нужны миграции.  
#### docker logs <container_id> 
##### проверяем контейнеры 


### Применяем миграции к БД, подключившись внутрь самого контейнера
#### docker exec -it flask-app /bin/bash
### Запускаем внутри контейнера миграции:
#### root $ > flask db upgrade
#### теперь запускаем страницу и видим инфу из БД

### На этом всё, можно выходить из контейнера с помощью ctrl+D
###
###

