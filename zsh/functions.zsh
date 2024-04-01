#!/bin/zsh

# docker
dcup() {
  docker compose up $@
}

dcrun() {
  docker compose run --rm $@
}

dbash() {
if [ $# -eq 1 ]; then
  docker compose exec -it $1 /bin/bash
else
  echo "Sorry. Please enter one argument."
fi
}
