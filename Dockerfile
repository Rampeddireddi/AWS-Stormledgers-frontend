FROM node:alpine3.18 as build

# Declare build time environment variables
ARG REACT_APP_NODE_ENV
ARG REACT_APP_SERVER_BASE_URL
ARG VITE_API_URL

# Set default values for environment variables
ENV REACT_APP_NODE_ENV=$REACT_APP_NODE_ENV
ENV REACT_APP_SERVER_BASE_URL=$REACT_APP_SERVER_BASE_URL
ENV VITE_API_URL=$VITE_API_URL

# Build App
WORKDIR /app
COPY package.json ./
RUN npm install
COPY . ./

# Debug log (optional)
RUN echo "VITE_API_URL: $VITE_API_URL"

RUN npm run build

# Serve with Nginx
FROM nginx:1.23-alpine
WORKDIR /usr/share/nginx/html
RUN rm -rf *
COPY --from=build /app/dist ./
EXPOSE 80
ENTRYPOINT [ "nginx", "-g", "daemon off;" ]
