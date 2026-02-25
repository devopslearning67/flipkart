FROM amazonlinux:2023

RUN sudo yum install httpd -y

COPY index.html /var/www/html/index.html

EXPOSE 80

CMD ["httpd","-D","FOREGROUND"]

