FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/ai/easings.net.git && \
    cd easings.net && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM node as build

WORKDIR /easings.net
COPY --from=base /git/easings.net .
RUN yarn install && \
    yarn build

FROM lipanski/docker-static-website

COPY --from=build /easings.net/dist .
