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
      "Sid": "ConfigBucketReadOnly",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "${config_bucket_arn}",
        "${config_bucket_arn}/*"
      ]
    },
    {
      "Sid": "ThanosBucketReadWrite",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "${thanos_bucket_arn}",
        "${thanos_bucket_arn}/*"
      ]
    }
  ]
}