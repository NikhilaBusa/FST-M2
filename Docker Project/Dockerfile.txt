FROM node:16-alpine as builder
WORKDIR /usr/app
COPY ./package.json ./
RUN npm install
COPY .  .
RUN npm run build


FROM node:16-alpine
WORKDIR /usr/app
COPY ./package.json ./
RUN npm install
COPY --from=builder /usr/app/dist .
CMD ["node", "server.js"]