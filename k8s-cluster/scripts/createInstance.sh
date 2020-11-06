# !/bin/bash

# Fill default values
KEY_NAME=${1:-"roozbeh"} 
BASE_IMAGEID=${2:-"ami-0edb80a008f3dc3fe"} # gw-k8s
SECURITY_GROUP=${3:-"gw-singke-k8s-sg"}
INSTANCE_NAME=${4:-"gw-k8s"}
INSTANCE_TYPE=${5:-"t2.medium"}
REGION=${6:-"us-east-1"}

if [[ $KEY_NAME == --help ]]
then
    echo "Please set your parameters as metioned below"
    echo "./createInstance.sh KEY_NAME BASE_IMAGEID SECURITY_GROUP INSTANCE_NAME INSTANCE_TYPE REGION"
    exit 0
fi

echo "KEY_NAME: ${KEY_NAME}"
echo "BASE_IMAGEID: ${BASE_IMAGEID}"
echo "SECURITY_GROUP: ${SECURITY_GROUP}"
echo "INSTANCE_NAME: ${INSTANCE_NAME}"
echo "REGION: ${REGION}"

# Generating instance skeleton
cp ./run-instances-skeleton.json ./run-instances-skeleton-out.json
sed -i "s/KEY_NAME/${KEY_NAME}/g" ./run-instances-skeleton-out.json
sed -i "s/INSTANCE_TYPE/${INSTANCE_TYPE}/g" ./run-instances-skeleton-out.json
sed -i "s/BASE_IMAGEID/${BASE_IMAGEID}/g" ./run-instances-skeleton-out.json
sed -i "s/SECURITY_GROUP/${SECURITY_GROUP}/g" ./run-instances-skeleton-out.json
sed -i "s/INSTANCE_NAME/${INSTANCE_NAME}/g" ./run-instances-skeleton-out.json

# Create instance
INSTANCE_ID=$(aws ec2 run-instances --region ${REGION} --output json --cli-input-json file://run-instances-skeleton-out.json | jq -r '.Instances[0].InstanceId')

# Check if instance creation is successful
if [[ $INSTANCE_ID == i-* ]]
then
    echo "Instance with ID: ${INSTANCE_ID} created."
else
    echo "aws ec2 run-instances --region ${REGION} --output json --cli-input-json file://run-instances-skeleton.json"
    exit 1
fi
