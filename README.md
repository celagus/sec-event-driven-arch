# Event-driven architecture for Security automation purposes

Still working in some features  👷‍♂️

## Requisites
* [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
* [Terraform CLI](https://learn.hashicorp.com/tutorials/terraform/install-cli)
* [Serverless Framework CLI](https://www.serverless.com/framework/docs/getting-started)

## Components
* __API Gateway__: expose incoming webhook and routes the input tu Step Functions pre-validation workflow
* __Step Functions__: acts like SOAR and executes a series of steps to validate input
* __Lambda__: the glue that makes all this integrations work fine
* __SQS__: the message queue that receive curated events ready to be store
* __Dynamo DB__: state DB that store IoCs and
* __SNS__: notification gateway
* __WAF__: acts like final consumer of IoC events. Deny bad actors to reach example website
* __CloudFront__: CDN that delivers example website
* __S3__: host example web site files

## Expected input (JSON)
```bash
{
  "alert_name": str,
  "alert_timestamp": timestamp_iso8601,
  "alert_severity": critical | high | medium | low,
  "source": str,
  "ip_address": str
}
```

## Diagram
![diagram](img/arch.png) 

## ⚠️ Warning ⚠️

This is a project prepared for lab purposes.

__Make sure you have hardened it before deploy it on production-like environments.__

## How to use it

Make sure you have configured your AWS CLI variables with your credentials

### Prepare your environment

Replace environment data at least from these files:
```bash
app/serverless.yml
iac/main.tf
```
### Deploy infrastructure as code with Terraform
Deploy infrastructure as code:
```bash
cd iac/
terraform init
terraform plan
terraform apply -auto-approve
```
### Deploy your lambdas with Serverless
Deploy Lambdas:
```bash
serverless deploy
```

### Check-it out
Check on AWS console if your resources were successfully created and get API URL (it should looks like https://{some_id}.execute-api.us-east-1.amazonaws.com/lab/incoming_webhook/ioc)





