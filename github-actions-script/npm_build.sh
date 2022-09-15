
echo "$(pwd)"

ls -al

cd variable_file_init
ls -al
cp ${VARIABLE_FILE} ../${VARIABLE_FILE}
cd ..


# echo '${{ needs.init.outputs.VARIABLE_FILE }}' > ./$VARIABLE_FILE

echo "******************reading VARIABLE_FILE start*****************"
cat ${VARIABLE_FILE}
echo "******************reading VARIABLE_FILE end*****************"

source $VARIABLE_FILE

echo "-------printitng CURRENT_SNAPSHOT_VER---------------"
echo $CURRENT_SNAPSHOT_VER
npm version $CURRENT_SNAPSHOT_VER --no---git-tag-version
git submodule update --init

sudo cp ./npmrc-config/.npmrc /.npmrc
sudo cp ./jfrog_keys/jfrog-cli.conf /jfrog-cli.conf
echo "^^^^^^^^^^^^printing .npmrc file^^^^^^^^^^^^^^^^^"
sudo cat /.npmrc

echo node version=$(node --version)
echo npm version=$(npm --version)
npm install --save-dev

echo "branch name : "
echo $GITHUB_REF_NAME
if [ $GITHUB_REF_NAME == "main" ]
then
    sudo mkdir /.ssh && ls -alrt /.ssh
    git config --global user.name "Amiya Rana"
    git config --global user.email "ranaamiya70@gmail.com"
    # sudo cat ./ssh_keys/id_ed25519 >> ls -alrt /.ssh/id_ed25519
    # sudo cat ./ssh_keys/known_hosts >> ls -alrt /.ssh/known_hosts
    sudo cp ./ssh_keys/id_ed25519 /.ssh/id_ed25519 
    sudo cp ./ssh_keys/known_hosts /.ssh/known_hosts
    sudo chmod 400 /.ssh/id_ed25519 && chmod 400 /.ssh/known_hosts
    ls -alrt /.ssh
    git remote set-url origin $COMPUTED_SSH_URL
    git checkout main
    echo "=================build release Artifacts BEGIN====================="
    npm run release
    echo "=================build release Artifacts END====================="

    echo "=================publish release to Artifactory BEGIN====================="
    # npm publish --registry $ARTIFACTORY_LOC
    echo "=================publish release to Artifactory END====================="

    echo "=================post release - updating the next snapshot version in package.json====================="
    rm -f package-lock.json
    npm version $NEXT_DEVELOPEMENT_VERSION -m "next developement version $NEXT_DEVELOPEMENT_VERSION updated in package.json"
    git push --set-upstream origin main

    ls -al

    cd dist-${MODULE_NAME}

    ls -al 

    echo "*************printing modules of terrafrom  start****************"
    cd modules

    cd lambda

    ls -al

    echo "*************printing modules of terrafrom  end****************"
else
    echo "=================build snapshot Artifacts BEGIN====================="
    echo "building Zip files for deployement"
    npm run build
    echo "=================build snapshot Artifacts END====================="

    echo "ARTIFACTORY_LOC : " $ARTIFACTORY_LOC
    echo "=================publish snapshot to Artifactory BEGIN====================="
    # npm publish --registry $ARTIFACTORY_LOC
    # npm config set registry $ARTIFACTORY_LOC
    # npm publish
    
    # npm login
    # npm publish --registry https://devopsamiya.jfrog.io/artifactory/api/npm/snapshots-npm/
    # jf rt ping
    # cd target
    # jf rt u "(*).zip" https://devopsamiya.jfrog.io/artifactory/api/npm/snapshots-npm/
    echo "=================publish snapshot to Artifactory END====================="
    echo "------------printing project folder files ------------------"

    ls -al

    cd target

    echo "------------printing target folder files ------------------"
    ls -al 

    cd ../dist

    echo "------------printing dist folder files ------------------"
    ls -al 

    cd ..

    zip -r dist-${MODULE_NAME}.zip  dist-${MODULE_NAME}
    echo "------------printing project folder files ------------------"
    ls -al
fi
