# Description: Dockerfile to build an image that will run the script to generate music from a prompt using Hugging Face's Text-to-Audio Serverless API

# use the official bash image
FROM bash:4.4

# update and install required packages : curl 
RUN apk update && apk add curl

# create a directory for the app
RUN mkdir -p /app

# set the working directory
WORKDIR /app

# copy the script to the working directory
COPY ./hf_music_gen.sh /app/hf_music_gen.sh

# make the script executable
RUN chmod +x /app/hf_music_gen.sh

# set the working directory
WORKDIR /

# make directory for the musics and prompts
RUN mkdir -p /data/musics \
    && mkdir -p /data/prompts

# set working directory
WORKDIR /app/

# create symbolic links to the directories for the musics and prompts in the /data directory
RUN ln -s /data/musics /app/musics \
    && ln -s /data/prompts /app/prompts

# set permissions for the directories data/musics and data/prompts
RUN chmod o+rw /data/musics \
    && chmod o+rw /data/prompts

# set working directory /data/images
WORKDIR /data/musics

# run the script
# Usage: /usr/bin/hf_music_gen.sh [-m MODEL_URL] [-f PROMPT_FILE]
#  il faut que lors du `docker run` on puisse passer les arguments, donc vu que c'est optionnel rajoute juste de quoi recuperer les arguments qui seront mis dans la variable $@
CMD ["bash", "/app/hf_music_gen.sh", "-f", "/app/prompts/prompt.txt"]



