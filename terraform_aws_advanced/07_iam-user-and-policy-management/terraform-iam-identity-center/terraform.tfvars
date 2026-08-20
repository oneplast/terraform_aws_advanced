aws_region  = "us-east-1"
aws_profile = "my-profile"

group_name        = "IMF"
user_given_name   = "Tom"
user_family_name  = "Cruise"
user_display_name = "MissonImpossible"
user_email        = "oneplast@gmail.com"

# aws sso-admin list-instances --query 'Instances[0].InstanceArn' --output text
sso_instance_arn = "arn:aws:sso:::instance/ssoins-72236c9f67f4f17f"

# aws sso-admin list-instances --query 'Instances[0].IdentityStoreId' --output text
identity_store_id = "d-90667495c2"
