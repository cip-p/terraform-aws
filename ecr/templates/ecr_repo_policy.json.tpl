{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "AllowPullRoleAppRunner",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::${account_id}:role/service-role/AppRunnerECRAccessRole"
        ]
      },
      "Action": [
        "ecr:BatchGetImage",
        "ecr:DescribeImages",
        "ecr:GetDownloadUrlForLayer"
      ]
    },
    {
      "Sid": "AllowPullPush",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::${account}:role/build-role"
        ]
      },
      "Action": [
         "ecr:BatchCheckLayerAvailability",
         "ecr:GetDownloadUrlForLayer",
         "ecr:BatchGetImage",
         "ecr:PutImage",
         "ecr:InitiateLayerUpload",
         "ecr:UploadLayerPart",
         "ecr:CompleteLayerUpload",
         "ecr:DescribeImageScanFindings",
         "ecr:StartImageScan",
         "ecr:CompleteLayerUpload"
      ]
    },
    {
      "Sid": "AllowECRScan",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::${account_id}:role/build-role",
          "arn:aws:iam::${account}:role/build-role"

      },
      "Action": [
         "ecr:DescribeImageScanFindings",
         "ecr:StartImageScan"
      ]
    }
  ]
}
