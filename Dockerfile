FROM nginx:alpine
COPY . /usr/share/nginx/html

RUN cat <<'EOF' > /etc/nginx/nginx.conf
events {}
http {
    include /etc/nginx/mime.types;
    server {
        listen 8092;
        root /usr/share/nginx/html;
        index index.html;

        location / {
            try_files $uri $uri/ /index.html;
        }

        # Avisa o navegador para descompactar o JavaScript
        location ~ \.js\.gz$ {
            gzip off;
            add_header Content-Encoding gzip;
            default_type application/javascript;
        }

        # Avisa o navegador para descompactar o WebAssembly
        location ~ \.wasm\.gz$ {
            gzip off;
            add_header Content-Encoding gzip;
            default_type application/wasm;
        }

        # Avisa o navegador para descompactar os dados do jogo
        location ~ \.data\.gz$ {
            gzip off;
            add_header Content-Encoding gzip;
            default_type application/octet-stream;
        }
    }
}
EOF

EXPOSE 8092
CMD ["nginx", "-g", "daemon off;"]
