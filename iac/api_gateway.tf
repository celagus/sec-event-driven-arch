# This approach is for testing purposes only, don't use it for production environments without authentication/authorization

resource "aws_apigatewayv2_api" "sec-event-driven-arch" {
  name          = "sec-event-driven-arch"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_route" "sec-event-driven-arch" {
  api_id    = aws_apigatewayv2_api.sec-event-driven-arch.id
  route_key = "POST /incoming_webhook/ioc"
  target    = "integrations/${aws_apigatewayv2_integration.sec-event-driven-arch.id}"
}

resource "aws_apigatewayv2_integration" "sec-event-driven-arch" {
  api_id              = aws_apigatewayv2_api.sec-event-driven-arch.id
  credentials_arn     = aws_iam_role.sec-event-driven-arch-apigw.arn
  description         = "Step Functions integration"
  integration_type    = "AWS_PROXY"
  integration_subtype = "StepFunctions-StartExecution"

  request_parameters = {
    "StateMachineArn" = aws_sfn_state_machine.sec-event-driven-arch-prevalidation.arn
    "Input"           = "$request.body"
  }
}

resource "aws_apigatewayv2_stage" "sec-event-driven-arch" {
  api_id        = aws_apigatewayv2_api.sec-event-driven-arch.id
  name          = "lab"
  deployment_id = aws_apigatewayv2_deployment.sec-event-driven-arch.id
}

resource "aws_apigatewayv2_deployment" "sec-event-driven-arch" {
  api_id      = aws_apigatewayv2_api.sec-event-driven-arch.id
  description = "Lab deployment"

  triggers = {
    redeployment = sha1(join(",", tolist([
      jsonencode(aws_apigatewayv2_integration.sec-event-driven-arch),
      jsonencode(aws_apigatewayv2_route.sec-event-driven-arch)]
    )))
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Add your authN-authZ provider
#resource "aws_apigatewayv2_authorizer" "authn-authz" {
#  api_id           = aws_apigatewayv2_api.sec-event-driven-arch.id
#  authorizer_type  = "JWT"
#  identity_sources = ["$request.header.Authorization"]
#  name             = "sarasa-authorizer"
#
#  jwt_configuration {
#    audience = ["sarasa"]
#    issuer   = "https://sarasa.auth"
#  }
#}