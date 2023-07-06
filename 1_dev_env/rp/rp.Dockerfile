FROM nginx:1.25.1-alpine@sha256:2d4efe74ef541248b0a70838c557de04509d1115dec6bfc21ad0d66e41574a8a
 
COPY nginx.conf /etc/nginx/nginx.conf