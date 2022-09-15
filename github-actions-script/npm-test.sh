echo "Step: Run unit tests"
Login_command=$(aws ecr get-login --profile "PROFILE_NAME" --region "ap-south-1" --no-include-email)
eval $Login_command
if [$? -eq 0]; then
  echo "successfully logged in to ECR"
else
  echo "Failed to log into ECR, exiting with failure..."
  exit 1
fi

psql --version
RETRIES=3
CONNECT_ATTEMPT=1
export PGPASSWORD=$PGPASSWORD
until psql -h buildhost -d $POSTGRESS_DB -U $POSTGRESS_USER   -c "select 1" > /dev/null 2>&1 || [$RETRIES -eq 0]; do
echo "waiting for postgress server, $((RETRIES-=1)) remaining attempts..."
echo "connect attempt: $((CONNECT_ATTEMPT+=1))"
done

echo "connected to DB after retries : $CONNECT_ATTEMPT"
echo "DOCKERIZED COLLECTIONS DATABASE INTIALIZED AND READY FOR TESTS"
echo "=============Mocha Unit Tests BEGIN================="
npm run test-in-pipeline
echo "=============Mocha Unit Tests END================="