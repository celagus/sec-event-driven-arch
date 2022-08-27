# Workflow for IP prevalidation
resource "aws_sfn_state_machine" "sec-event-driven-arch-prevalidation" {
  name     = "pre_validation_workflow"
  role_arn = aws_iam_role.sec-event-driven-arch-sf.arn
  type     = "EXPRESS"

  definition = <<EOF
{
  "Comment": "IP address pre validation workflow",
  "StartAt": "validate_ip",
  "States": {
    "validate_ip": {
      "Type": "Task",
      "Resource": "arn:aws:states:::lambda:invoke",
      "OutputPath": "$.Payload",
      "Parameters": {
        "Payload.$": "$",
        "FunctionName": "arn:aws:lambda:us-east-1:${local.account_id}:function:lambda_validate_ip:$LATEST"
      },
      "Next": "validate_ip_3p",
      "Catch": [
        {
          "ErrorEquals": [
            "States.TaskFailed"
          ],
          "Comment": "Invalid IP",
          "Next": "SNS Publish"
        }
      ]
    },
    "SNS Publish": {
      "Type": "Task",
      "Resource": "arn:aws:states:::sns:publish",
      "Parameters": {
        "TopicArn": "arn:aws:sns:us-east-1:${local.account_id}:test_topic",
        "Message": {
          "msg": "Event not processed due inconsistencies",
          "input": "$.inputValue"
        }
      },
      "End": true
    },
    "validate_ip_3p": {
      "Type": "Task",
      "Resource": "arn:aws:states:::lambda:invoke",
      "OutputPath": "$.Payload",
      "Parameters": {
        "Payload.$": "$",
        "FunctionName": "arn:aws:lambda:us-east-1:${local.account_id}:function:lambda_validate_ip_3p:$LATEST"
      },
      "Next": "put_sqs_msg",
      "Catch": [
        {
          "ErrorEquals": [
            "States.TaskFailed"
          ],
          "Next": "SNS Publish"
        }
      ]
    },
    "put_sqs_msg": {
      "Type": "Task",
      "Resource": "arn:aws:states:::lambda:invoke",
      "OutputPath": "$.Payload",
      "Parameters": {
        "Payload.$": "$",
        "FunctionName": "arn:aws:lambda:us-east-1:${local.account_id}:function:lambda_sqs_put_msg:$LATEST"
      },
      "End": true
    }
  }
}
EOF
  
  logging_configuration {
    log_destination        = "${aws_cloudwatch_log_group.sec-event-driven-arch-prevalidation.arn}:*"
    include_execution_data = false
    level                  = "ERROR"
  }
}

resource "aws_cloudwatch_log_group" "sec-event-driven-arch-prevalidation" {
  name = "sec-event-driven-arch-prevalidation"
}
