# Lambdas policy
resource "aws_iam_role" "sec-event-driven-arch-lambdas" {
  name               = "sec-event-driven-arch-lambas"
  assume_role_policy = data.aws_iam_policy_document.assume-role-policy-lambdas.json
  inline_policy {
    name   = "sec-event-driven-arch-lambdas"
    policy = data.aws_iam_policy_document.inline-policy-lambdas.json
  }
}

data "aws_caller_identity" "current" {}

locals {
    account_id = data.aws_caller_identity.current.account_id
}

data "aws_iam_policy_document" "inline-policy-lambdas" {
  statement {
    actions   = ["sqs:List*", "sqs:Get*", "sqs:DeleteMessage*", "sqs:ReceiveMessage", "sqs:SendMessage*", "sqs:ChangeMessageVisibility*"]
    resources = ["${aws_sqs_queue.test_queue.arn}"]
  }
  statement {
    actions   = ["dynamodb:Put*", "dynamodb:List*", "dynamodb:Delete*", "dynamodb:Describe*", "dynamodb:Get*", "dynamodb:Query"]
    resources = ["${aws_dynamodb_table.test_dynamodb.arn}/*", "${aws_dynamodb_table.test_dynamodb.arn}"]
  }
  statement {
    actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["arn:aws:logs:us-east-1:${local.account_id}:*"]
  }
  statement {
    actions   = ["sns:*"]
    resources = ["${aws_sns_topic.test_topic.arn}"]
  }
  statement {
    actions   = ["states:*"]
    resources = ["arn:aws:states:us-east-1:${local.account_id}:*"]
  }
  statement {
    actions   = ["lambda:Invoke*"]
    resources = ["arn:aws:lambda:us-east-1:${local.account_id}:*"]
  }
  statement {
    actions   = ["wafv2:*"]
    resources = ["arn:aws:wafv2:us-east-1:${local.account_id}:*"]
  }
}

data "aws_iam_policy_document" "assume-role-policy-lambdas" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# API Gateway policy
resource "aws_iam_role" "sec-event-driven-arch-apigw" {
  name               = "sec-event-driven-arch-apigw"
  assume_role_policy = data.aws_iam_policy_document.assume-role-policy-apigw.json
  inline_policy {
    name   = "sec-event-driven-arch-apigw"
    policy = data.aws_iam_policy_document.inline-policy-apigw.json
  }
}

data "aws_iam_policy_document" "inline-policy-apigw" {
  statement {
    actions   = ["states:Start*", "states:Stop*", "states:Get*"]
    resources = ["arn:aws:states:us-east-1:${local.account_id}:*"]
  }
  statement {
    actions   = ["lambda:Invoke*"]
    resources = ["arn:aws:lambda:us-east-1:${local.account_id}:*"]
  }
}

data "aws_iam_policy_document" "assume-role-policy-apigw" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }
}

# Step Functions policy
resource "aws_iam_role" "sec-event-driven-arch-sf" {
  name               = "sec-event-driven-arch-sf"
  assume_role_policy = data.aws_iam_policy_document.assume-role-policy-sf.json
  inline_policy {
    name   = "sec-event-driven-arch-sf"
    policy = data.aws_iam_policy_document.inline-policy-sf.json
  }
}

data "aws_iam_policy_document" "inline-policy-sf" {
  statement {
    actions   = ["lambda:Invoke*"]
    resources = ["arn:aws:lambda:us-east-1:${local.account_id}:*"]
  }
  
  statement {
    actions   = ["logs:*"]
    resources = ["aws_cloudwatch_log_group.sec-event-driven-arch-prevalidation.arn", "aws_cloudwatch_log_group.sec-event-driven-arch-block.arn", "aws_cloudwatch_log_group.sec-event-driven-arch-unblock.arn"]
  }
  
  statement {
    actions   = ["sns:Publish"]
    resources = ["aws_sns_topic.test_topic.arn"]
  }
}

data "aws_iam_policy_document" "assume-role-policy-sf" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["states.amazonaws.com"]
    }
  }
}