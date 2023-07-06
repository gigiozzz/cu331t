FROM node:12.22.12-alpine@sha256:4517380049fc3c9aacceae7764fcf3500354b0ac8a47e4afb35b5bbeb75b9498 as build

RUN apk add --no-cache git
RUN git clone https://github.com/Rahul-Pandey7/react-image-compressor.git /data/app
ENV NODE_ENV=production
WORKDIR /data/app
RUN npm install --production

# sec 4 tampering
FROM node:12.22.12-alpine@sha256:4517380049fc3c9aacceae7764fcf3500354b0ac8a47e4afb35b5bbeb75b9498
# choosen from https://endoflife.date/nodejs a 4 year old node (lots of sec bugs)
ENV NODE_ENV=production

WORKDIR /app
COPY --chown=node:node --from=build /data/app/node_modules /app/node_modules 
COPY --chown=node:node --from=build /data/app/public /app/public
COPY --chown=node:node --from=build /data/app/src /app/src
COPY --chown=node:node --from=build /data/app/package-lock.json /app/package-lock.json
COPY --chown=node:node --from=build /data/app/package.json /app/package.json

### FIXME where are the images to download placed ? maybe we should use a volume for it <<< stupid question is client side app! blob://

EXPOSE 3000
# no root
USER node

CMD ["npm", "start"]