data "aws_iam_role" "vprofileEC2_S3" {
  name = "vprofileCoder"
}

#Create an IAM POLICY TO attach the IAM ROLE
# resource "aws_iam_policy_attachment" "ec2_s3_role" {
#   name = "EC2roletoS3"
#   roles = [ data.aws_iam_role.vprofileEC2_S3.var.ec2_name ]
#   policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
# }

#instance profile
resource "aws_iam_instance_profile" "EC2_s3_role_profile" {
  name = "s3AccessProfile"
  role = data.aws_iam_role.vprofileEC2_S3.name
}