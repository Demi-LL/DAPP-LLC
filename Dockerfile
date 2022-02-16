FROM node:14-alpine

COPY ./front ./front
COPY ./build ./build

WORKDIR /front

RUN export NODE_OPTIONS="--max-old-space-size=8192" && \
    yarn install && yarn run build
