# ssh key and jade-mw ec2 instance is created externally
# we need to use terraform import to import jade-mw 

aws ec2 describe-instances --endpoint http://aws:4566 --filters "Name=image-id,Values=ami-082b3eca746b12a89" |jq -r '.Reservations[].Instances[].InstanceId'

terraform import aws_instance.jade-mw i-d5f9d00c9ce76dbbe

