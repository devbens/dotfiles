SUBJECT="/C=BE/ST=Vlaams-Brabant/L=Leuven/O=Devbens/OU=IT/CN=Devbens Engineering"

mkdir ~/.ssl/
openssl genrsa -out ~/.ssl/rootCA.key 2048
openssl req -x509 -new -nodes -key ~/.ssl/rootCA.key -sha256 -days 2048 -subj "$SUBJECT" -out ~/.ssl/rootCA.pem
