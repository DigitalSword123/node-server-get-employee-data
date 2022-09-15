echo "********************before deploy script start*****************"
echo "APP_VERSION=$APP_VERSION"
# mkdir ~/.ssh && 
ls -alrt ~/.ssh
cat ~/ssh_keys/id_rsa >> ls -alrt ~/.ssh/id_rsa
cat ~/ssh_keys/known_hosts >> ls -alrt ~/.ssh/known_hosts
chmod 400 ~/.ssh/id_rsa && chmod 400 ~/.ssh/known_hosts
ls -alrt ~/.ssh
envl=$(echo "$DEPLOY_ENVIRONMENT" | tr '[:upper]' '[:lower:]')
export AWS_PROFILE=$AWS_PROFILE
export IAM_ROLE=$IAM_ROLE
export STATE_BUCKET=$TERRAGRUNT_S3_STATE_BUCKET
export DYNDB_TBL=$DYNDB_TBL
export AWS_ACCOUNT_NUMBER=$AWS_ACCOUNT
export AWSENV=$DEPLOY_ENVIRONMENT
export AWSENVLOWER=$envl
echo "APP_VERSION=$APP_VERSION"

# echo ">>>>>>>>>>>>> Downloading artifacts from artifactory >>>>>>>>>>>>>>>>>"
# cat ~/$PROJECT_NAME/jfrog_keys/jfrog-cli.conf >> ~/.jfrog/jfrog-cli.pkg-conf
# jf rt ping
# rm -rf CF_OUTPUT
# echo "jfrog rt dl $ARTIFACTORY_TYPE/$PROJECT_NAME/-/$PROJECT_NAME-$APP_VERSION.tgz CF_OUTPUT/ --explode=true --sort-order=desc --limit=1 --flat=true"
# jfrog rt dl $ARTIFACTORY_TYPE/$PROJECT_NAME/-/$PROJECT_NAME-$APP_VERSION.tgz CF_OUTPUT/ --explode=true --sort-order=desc --limit=1 --flat=true

if [ $? -eq 0 ]; then
    echo "success"
else
    echo "failed"
fi
pwd
ls -alrt

echo "********************before deploy script end*****************"
