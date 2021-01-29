#!/bin/sh
set -euo pipefail

sudo yum install -y nginx
sudo service nginx start
sudo chkconfig nginx on

echo "Hello world" > /usr/share/nginx/html/index.html

<...>
echo "Checking that agent is running"
until $(curl --output /dev/null --silent --head --fail http://localhost:51678/v1/metadata); do
  printf '.'
  sleep 1
done
exit_code=$?
printf "\nDone\n"

# Can't signal back if the stack is in UPDATE_COMPLETE state, so ignore failures to do so.
# CFN will roll back if it expects the signal but doesn't get it anyway.
echo "Reporting $exit_code exit code to Cloudformation"
/opt/aws/bin/cfn-signal \
  --exit-code "$exit_code" \
  --stack "$CFN_STACK" \
  --resource ASG \
  --region "$REGION" || true