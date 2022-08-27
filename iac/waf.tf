resource "aws_wafv2_ip_set" "threat_intel_malicious" {
  name               = "malicious_actors"
  description        = "malicious actors gathered from threat intelligence sources"
  scope              = "CLOUDFRONT"
  ip_address_version = "IPV4"
  addresses          = ["1.2.3.4/32"]
}

resource "aws_wafv2_rule_group" "threat_intel_malicious" {
  name        = "malicious_actors"
  description = "An rule group containing malicious IPs from different sources"
  scope       = "CLOUDFRONT"
  capacity    = 500

  rule {
    name     = "rule-1"
    priority = 1

    action {
      block {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.threat_intel_malicious.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "waftest-rule-malicious-actors"
      sampled_requests_enabled   = false
    }
  }
  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "waftest-rulegroup-malicious-actors"
    sampled_requests_enabled   = false
  }
}

resource "aws_wafv2_web_acl" "block_malicious_actors" {
  name        = "block_malicious_actors"
  description = "Info from threat intelligence"
  scope       = "CLOUDFRONT"

  default_action {
    allow {}
  }

  rule {
    name     = "rule-1"
    priority = 1

    override_action {
      count {}
    }

    statement {
      rule_group_reference_statement {
        arn = aws_wafv2_rule_group.threat_intel_malicious.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "waftest-webacl-rule1-malicious"
      sampled_requests_enabled   = false
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "waftest-webacl-malicious"
    sampled_requests_enabled   = false
  }
}
