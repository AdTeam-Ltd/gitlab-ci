#!/bin/bash

# Меняем тут файл и бахаем

docker build -t adteam/gitlab-ci .
docker push adteam/gitlab-ci
git add .
git commit -m "Change Dockerfile"
git push origin master