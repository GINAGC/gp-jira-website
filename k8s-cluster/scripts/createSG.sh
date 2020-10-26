# !/bin/bash

# Fill default values
GROUP_NAME=${1:-"gw-singke-k8s-sg"} 
DESC=${2:-"SG for test env"} # gw-k8s

if [[ $GROUP_NAME == --help ]]
then
    echo "Please set your parameters as metioned below"
    echo "./createSG.sh GROUP_NAME DESC"
    exit 0
fi

echo "GROUP_NAME: ${GROUP_NAME}"
echo "DESC: ${DESC}"

# Create instance
GROUP_ID=$(aws ec2 create-security-group --group-name ${GROUP_NAME} --description "${DESC}" | jq -r '.GroupId')

# Check if instance creation is successful
if [[ $GROUP_ID == sg-* ]]
then
    aws ec2 authorize-security-group-ingress \
    --group-name $GROUP_NAME \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0

    aws ec2 authorize-security-group-ingress \
    --group-name $GROUP_NAME \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/0

    aws ec2 authorize-security-group-ingress \
    --group-name $GROUP_NAME \
    --protocol tcp \
    --port 6443 \
    --cidr 0.0.0.0/0

    aws ec2 authorize-security-group-ingress \
    --group-name $GROUP_NAME \
    --protocol tcp \
    --port 1344 \
    --cidr 0.0.0.0/0

    aws ec2 authorize-security-group-ingress \
    --group-name $GROUP_NAME \
    --protocol tcp \
    --port 443 \
    --cidr 0.0.0.0/0

    echo "SG with ID: ${GROUP_ID} created."
else
    echo "aws ec2 create-security-group --group-name ${GROUP_NAME} --description "${DESC}""
    exit 1
fi
