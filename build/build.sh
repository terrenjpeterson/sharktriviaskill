#!/bin/bash
# create build package and deploy a new skill

# get into directory for files
cd ..

# create build package
echo 'creating build package'
zip -r trivia.zip index.js package.json questions.js node_modules/ > temp.log
echo 'build package created'

# stage the file to s3
aws s3 cp trivia.zip s3://sharktrivia

# remove the temporary file
rm trivia.zip

# set which lambda function is being updated
lambdaruntime='sharkTriviaGreen'

# update the lambda function with the binaries that have been staged
echo 'updating lambda function'
aws lambda update-function-code --function-name "$lambdaruntime" --s3-bucket sharktrivia --s3-key trivia.zip >> temp.log
echo 'lambda function updated'

# read in test data required to invoke the lambda function
echo 'test case 1 - basic request to start a new game'
cd testing
request=$(<request.json)
cd ..

# invoke the new lambda function
aws lambda invoke --function-name "$lambdaruntime" --payload "$request" testOutput.json >> temp.log

# read response file into local variable then print on the console
response=$(<testOutput.json)
echo $response
echo 'test case 1 complete'
