# Docker Build Library

Library for docker builds
This is a personal library that assists in my own personal workflow

## Neovim

Initiate neovim with kickstart

```sh
./build.sh ./neovim neovim latest
```

## Terraform

Initiate terraform

```sh
./build.sh ./terraform terraform latest

cd ./terraform && docker build -t wtfauonabt/terraform:latest . && cd -
docker push wtfauonabt/terraform:latest
docker build -t wtfauonabt/terraform:latest -f build/terraform/1.3.6/Dockerfile .
```
