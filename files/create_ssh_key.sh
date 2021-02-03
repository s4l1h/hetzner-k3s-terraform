ssh-keygen -o -t rsa -b 4096 -C "k3s" -f ./data/id_rsa -N ""
chmod +x ./data/id_rsa*
chmod 600 ./data/id_rsa