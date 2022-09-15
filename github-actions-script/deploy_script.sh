
ls -al
cp build_output_1/${VARIABLE_FILE} ./${VARIABLE_FILE}

cp build_output_1/dist-${MODULE_NAME}.zip .

unzip dist-${MODULE_NAME}.zip

source ${VARIABLE_FILE}
echo "******************reading VARIABLE_FILE start*****************"
cat ${VARIABLE_FILE}
echo "******************reading VARIABLE_FILE end*****************"

echo "--------------------Switching to dist directory-------------------"
cd dist-${MODULE_NAME}
echo "printing all files in target directory"

ls -altr

echo total size of the deployement package=$(du -sh .)
echo "------------------printing all files in target directory end --------------------------"
echo "STATE_BUCKET" $STATE_BUCKET
echo "AWSENV" $AWSENV
echo "AWS_REGION" $AWS_REGION
echo "AWS_ACCOUNT_NUMBER" $AWS_ACCOUNT_NUMBER
echo "DYNDB_TBL" $DYNDB_TBL
echo "IAM_ROLE" $IAM_ROLE

echo "**********************************************************"
pwd
# echo "unzip ZIP from tgz from tgz_output directory"
# unzip -o *.zip -d TF_OUTPUT
# pwd
# ls -altr
# RESULT=$?

# if  [ $RESULT -eq 0 ]; then
#     echo "success"
# else
#     echo "failed"
# fi

# echo "switching to TF_OUTPUT_DIR"
# cd TF_OUTPUT
# echo "printing all files in TF_OUTPUT directory"
# pwd
# ls -altr
# pip install envsubst
# envsubst < terragrunt.hcl_template > tearragrunt.hcl

# if  [ $? -eq 0 ]; then
#     echo "success"
# else
#     echo "failed"
# fi
# envl=$(echo "$DEPLOY_ENVIRONMENT" | tr '[:upper:]' '[:lower:]')
# export AWSENVLOWER=$envl
# echo "printing terragrunt.hcl file"
# cat terragrunt.hcl
# echo "printing $AWSENVLOWER-terraform.tfvars file"
# echo "Terraform Version : "
# terraform --version

# cd terraform_project

# echo "$(pwd)"

# ls -al

export VAR_FILE=vars/$DEPLOY_ENVIRONMENT-ap-south-1.tfvars

cat ${VAR_FILE}

echo "DEPLOY_ENVIRONMENT : " $DEPLOY_ENVIRONMENT

echo "----------creating zip file for lambda deployement------------"
# zip -r ${ARTIFACT_ID}.current.zip *.js *.json lib node_modules
zip -r ${ARTIFACT_ID}.current.zip . -x '*.tf*' 'vars/*' 'modules/*' -x '*.tfplan' -x 'tfplan'
echo "----------creating zip file for lambda deployement end------------"

echo "***************printing all files after zip************************"
ls -al
echo "***************printing all files after zip end************************"

echo "app version : " ${APP_VERSION}
export TF_VAR_version=${APP_VERSION}
echo "TF_VAR_version : " ${TF_VAR_version}

terraform init \
 -backend-config="bucket=node-terraform-state-bucket" \
 -backend-config="key=get-node-employee-data/$DEPLOY_ENVIRONMENT/terraform.tfstate" \
 -backend-config="access_key=${AWS_ACCESS_KEY}" \
 -backend-config="secret_key=${AWS_SECRET_KEY}"

terraform plan -var-file="${VAR_FILE}" -out=plan.tfplan

terraform apply "plan.tfplan"