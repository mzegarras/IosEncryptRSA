# IosEncryptRSA

Steps generate certificates:

openssl genrsa -des3 -out private.pem 2048

//Create a certificate signing request with the private key
openssl req -new -key private.pem -out rsaCertReq.csr

//Create a self-signed certificate with the private key and signing request
openssl x509 -req -days 3650 -in rsaCertReq.csr -signkey private.pem -out rsaCert.crt

//Convert the certificate to DER format: the certificate contains the public key
openssl x509 -outform der -in rsaCert.crt -out rsaCert.cer

//Export the private key and certificate to p12 file
//openssl pkcs12 -export -out rsaPrivate.p12 -inkey rsaPrivate.pem -in rsaCert.crt
