locals {
  managed_rules = {
    AWSManagedRulesCommonRuleSet = {
      priority = 10
    }

    AWSManagedRulesKnownBadInputsRuleSet = {
      priority = 20
    }

    AWSManagedRulesAmazonIpReputationList = {
      priority = 30
    }

    AWSManagedRulesSQLiRuleSet = {
      priority = 40
    }
  }
}