#!/bin/bash

# Меняем тут файл и бахаем в прод. :DDDDDDDD
git add .
git commit -m "Change Dockerfile"
git push origin master
docker build -t adteam/gitlab-ci .
docker push adteam/gitlab-ci
