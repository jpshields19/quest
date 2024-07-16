FROM node:16

WORKDIR /app

RUN groupadd -g 3000 rearc && useradd -u 1001 -g 3000 -m rearc

RUN chown rearc:rearc /app

COPY ./quest/package.json .

RUN npm install

COPY ./quest/. .

USER rearc

EXPOSE 3000

CMD ["npm", "start"]