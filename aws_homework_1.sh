#!/bin/bash
echo ' This weeks homework Homework: Write a script that uses aws command line tool to complete the following'
echo  ' Create an S3 bucket:'
aws s3 mb s3://hawkalicious
echo 'Upload 2 files to that bucket'
mkdir hawkabooty
cd hawkabooty/
echo 'cookin by the book' > yeah.txt
echo 'piece of cake' > prettycake.txt
aws s3 cp . s3://hawkalicious --recursive
echo 'List the files in the bucket'
aws s3 ls s3://hawkalicious
echo 'List the names of S3 buckets in your region'
aws s3 ls
echo 'Get the bucket policy for the bucket you created'
aws s3api get-bucket-policy --bucket mybucket --query Policy --output text
TIMESTAMP=$(date +%Y%m%d%H%M)
POLICY=$(cat<<EOF
{
    "Version": "2008-10-17",
    "Id": "s3-public-read-$TIMESTAMP",
    "Statement": [
        {
            "Sid": "Stmt-$TIMESTAMP",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::hawkalicious"
        },
        {
            "Sid": "Stmt-$TIMESTAMP",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::hawkalicious/*"
        }
    ]
}
EOF
)

echo making hawkalicious public-read
aws s3api put-bucket-policy --bucket hawkalicious --policy "$POLICY"
read -p "Go check the policy if you like and then press enter to continue"
echo "Here is the new policy"
aws s3api get-bucket-policy --bucket hawkalicious --output text
echo 'Delete the two files in the bucket'
aws s3 rm s3://hawkalicious --recursive
echo 'Delete the bucket'
aws s3 rb s3://hawkalicious
cd ..
rm -rf hawkabooty
