## Terrafrom infra Setup
To Create access keys for an IAM user without interrupting your applications (console)

While the first access key is still active, create a second access key.

Sign in to the AWS Management Console and open the IAM console at https://console.aws.amazon.com/iam/.

In the navigation pane, choose Users.

Choose the name of the intended user, and then choose the Security credentials tab.

Choose Create access key and then choose Download .csv file to save the access key ID and secret access key to a .csv file on your computer. Store the file in a secure location. You will not have access to the secret access key again after this closes. After you have downloaded the .csv file, choose Close.

The new access key is active by default. At this point, the user has two active access keys.

## Update aws-access-key with the new access key
```
source aws-access-key
```
## Update infra/group_vars/all with your domain name 
```
vim infra/group_vars/all
```
## Run terraform init and apply to start it
```
terraform init
terraform plan
terraform apply
```
## Run terraform  to Delete your stack
```
terraform destroy
``` 
