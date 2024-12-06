# BeatHarvest Backend

this repo exposes cli utils to automate the process of downloading a user's spotify playlists.

## instructions to pull dockerhub image and run locally

- `docker-compose build`
- `docker-compose up -d`

## shell access

- `docker-compose exec music-downloader bash`

## Build

### Build for local development

- `./build.sh -D` builds against current directory.

### Build against git repo trunk

- `./build.sh`

### Build against git repo trunk and push to dockerhub, targeting arm and x86

- `docker buildx build --platform linux/amd64,linux/arm64 -t kyledockerizes/beatharvest:latest --push .`
