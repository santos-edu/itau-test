#!/bin/sh
yum update -y && yum install -y docker
systemctl enable docker.service && sudo systemctl start docker.service
eval $(aws ecr get-login --no-include-email --region sa-east-1)
docker pull 268510435705.dkr.ecr.sa-east-1.amazonaws.com/itau-test:__ID__
docker run -d -ti --privileged --restart=unless-stopped -p 80:80 268510435705.dkr.ecr.sa-east-1.amazonaws.com/itau-test:__ID__


              
