# Utiliser une image Nginx comme base
FROM nginx:alpine

# Copier tous les fichiers HTML/CSS dans le répertoire de service Nginx
COPY ./*.html /usr/share/nginx/html/
COPY ./*.css /usr/share/nginx/html/


EXPOSE 80

# Démarrer Nginx en mode foreground
CMD ["nginx", "-g", "daemon off;"]