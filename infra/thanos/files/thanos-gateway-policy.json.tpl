{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "SSMAccess",
      "Effect": "Allow",
      "Action": [
        "ssm:UpdateInstanceInformation",
        "ssmmessages:CreateControlChannel",
        "ssmmessages:CreateDataChannel",
        "ssmmessages:OpenControlChannel",
        "ssmmessages:OpenDataChannel"
      ],
      "Resource": "*"
    },
    {
      "Sid": "ThanosBucketReadOnly",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "${thanos_bucket_arn}",
        "${thanos_bucket_arn}/*"
      ]
    },
    {
      "Sid": "ConfigBucketReadOnly",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": "${config_bucket_arn}/*"
    }
  ]
}