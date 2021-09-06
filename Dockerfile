# import base image
FROM node:alpine AS builder_phase
# everything from this point on will fall under builder_phase

WORKDIR '/app'

COPY package.json .

RUN npm install

COPY . .

RUN npm run build

# ------------- end builder_phase

# -------------- start start process

FROM nginx
# this is only in prod
# this is how we will handle port mapping with BeanStalk
# to map incoming traffic
# locally EXPOSE does nothing
EXPOSE 80

COPY --from=builder_phase /app/build /usr/share/nginx/html

# default command in nginx will auto-start nginx