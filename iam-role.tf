# CREATE A ROLE FOR BASTION HOST TO ALLOW ACCESS TO S3

resource "aws_iam_role" "bastion_host_role" {
  name = "ec2-s3-access-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# ATTACH A POLICY TO THE ROLE

resource "aws_iam_role_policy_attachment" "bastion_host_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role = aws_iam_role.bastion_host_role.id
}

# CREATE A INSTANCE PROFILE

resource "aws_iam_instance_profile" "bastion_host_profile" {
  name = "bastion-host-s3-access-profile"
  role = aws_iam_role.bastion_host_role.name
}