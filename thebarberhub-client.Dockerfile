FROM node:22.19.0 AS build

RUN apt-get update && apt-get install -y git
 
RUN mkdir /opt/app
WORKDIR /opt/app
RUN git clone -b develop https://github.com/TheBarberHub-2/Front-Cliente.git
WORKDIR /opt/app/Front-Cliente/Front-Cliente
RUN npm install
RUN npm run build --prod

FROM nginx:1.28.0-alpine3.21
COPY --from=build /opt/app/Front-Cliente/Front-Cliente/dist/Front-Cliente/browser/ /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
