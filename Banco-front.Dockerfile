FROM node:22.19.0 AS build

RUN apt-get install -y git
 
RUN mkdir /opt/app
WORKDIR /opt/app
RUN git clone https://github.com/TheBarberHub-2/Banco-Front.git
WORKDIR /opt/app/Banco-Front
RUN git switch --detach origin/develop
RUN npm ci
RUN npm run build --prod

FROM nginx:1.28.0-alpine3.21
COPY --from=build /opt/app/Banco-Front/dist/a/browser/ /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

