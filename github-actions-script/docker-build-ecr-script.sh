# https://nodejs.org/en/docs/guides/nodejs-docker-webapp/

# docker build . -t aws/node-web-get-employee-app

# CONTAINER ID        IMAGE                           COMMAND                  C
# ATED             STATUS                      PORTS               NAMES
# 49dc20b3071b        aws/node-web-get-employee-app   "docker-entrypoint.s"   17
# econds ago      Exited (0) 13 seconds ago                       practical_newt

echo $(pwd)
imageTag=$version
echo $imageTag
declare -A profiles_array
if [ $GITHUB_REF_NAME == "main" ]; then
    profiles_array=(
        [$ACCOUNT]="ACCOUNT"
        [$PROFILE]="PROFILE"
    )
else
  profiles_array=(
    [$ACCOUNT]="ACCOUNT"
  )
fi

for profile in ${profiles_array[@]}; do
    LOGIN_COMMAND=$(aws ecr get-login --profile "$profile" --region "ap-south-1" --no-include-email)
    eval $LOGIN_COMMAND
    AWS_ACCOUNT=$(awk -F\| '{print$1}' <<< ${profiles_array[$profile]})
    ECR_NS=$(awk -F\| '{print$2}'  <<< ${profiles_array[$profile]})
    if [ $? -eq 0 ]; then
        echo "successfully logged in to $profile - $AWS_ACCOUNT account ECR"
    else
        echo "failed to log into $profile - $AWS_ACCOUNT account ECR"
        exit 1
    fi

    ecrDockerImageTag="$AWS_ACCOUNT.dkr.ecr.ap-south-1.amazonaws.com/$ECR_NS:$imageTag"
    echo $ecrDockerImageTag
    docker build --network=host --tag $ecrDockerImageTag .
    echo "docker push started"
    docker push $ecrDockerImageTag
    echo "docker push completed"
    docker image rm $ecrDockerImageTag
done

echo "docker push to ECR sucessfull"