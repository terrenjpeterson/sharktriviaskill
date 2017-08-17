cd ..

zip -r trivia.zip index.js package.json questions.js node_modules/

aws s3 cp trivia.zip s3://sharktriviaquiz
