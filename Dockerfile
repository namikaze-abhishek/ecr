FROM node:16-alpine

WORKDIR '/app'

COPY package.json .
RUN npm install

COPY . .
ENV CHOKIDAR_USEPOLLING=true


CMD ["npm", "start"]
