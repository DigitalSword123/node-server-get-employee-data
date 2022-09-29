echo $(pwd)
imageTag=$version
echo $imageTag
instanceList=$(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-name $AWS_ASG_GROUP_NAME --profile $profile)
echo $instanceList
instanceIds=($($(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-name $AWS_ASG_GROUP_NAME --profile $profile | jq '.AutoScalingGroups[0].Instances' | jq -c '.[]' | grep Healthy | jq '.InstanceId' | sed -e 's/"//g'))
echo "${instanceIds[0]} and ${instanceIds[1]}"
ecrDockerImageTag="$AWS_ACCOUNT.dkr.ecr.ap-south-1.amazonaws.com/$ECR_NS:$imageTag"

# pull docker
pullCmd="docker pull ${ecrDockerImageTag}"
echo "oull command started"
InstanceKeys="[{\"keys\":\"InstanceIds\",\"values\":[\"instanceIds\"]}]"
echo $InstanceKeys
commands="{\"commands\":[\"#!/bin/bash\",\"eval $(aws ecr get-login --profile "$profile" --region "ap-south-1" --no-include-email)\",\"${pullCmd}\"]}"
echo $commands
executeCmds=$(aws ssm send-command --document-name "AWS-RUNSHellscript" --targets "${instanceKeys}" --parameters "${commands}" --profile $profile
echo $executeCmds

env='dev'
echo "deploying to ENV:$env"
# copy props files from param store
createDirsCmd="mkdir -p /home/ec2-user/logs /home/ec2-user/props"
createPropertyCmd="aws ssm get-parameter --region ap-south-1 --name /profile --with-decryption --output text --query Paramter.value > /home/ec2-user/props/app.properties"

permissionPropertyCmd="chmod 664 /home/ec2-user/props/app.properties"


InstanceKeys="[{\"keys\":\"InstanceIds\",\"values\":[\"instanceIds\"]}]"

commands="{\"commands\":[\"#!/bin/bash\",\"${createDirsCmd}\",\"${createDirsCmd}\",\"${createPropertyCmd}\"]}"
echo $commands
executeCmds=$(aws ssm snd-command --document-name "AWS-RunSHellScript" --targets "${InstanceKeys}" --parameters "${commands}" --profile $profile)
echo $executeCmds
date
