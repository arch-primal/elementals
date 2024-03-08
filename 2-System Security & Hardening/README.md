docker build -t ssh-lab .
docker run -d -p 2222:22 -e SSH_METHOD=password -e SSH_PASSWORD=tuContraseñaSegura ssh-lab

docker run -d -p 2222:22 -e SSH_METHOD=pubkey -e SSH_KEY="$(cat tuLlavePublica.pub)" ssh-lab
