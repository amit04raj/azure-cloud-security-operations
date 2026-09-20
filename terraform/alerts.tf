resource "azurerm_monitor_action_group" "operations" {
  name                = "ag-cloud-security-operations"
  resource_group_name = azurerm_resource_group.main.name
  short_name          = "CloudOps"

  email_receiver {
    name                    = "primary-email"
    email_address           = "amitraj492@gmail.com"
    use_common_alert_schema = true
  }

  tags = {
    project     = "azure-cloud-security-operations"
    environment = "portfolio"
    managed_by  = "terraform"
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "failed_requests" {
  name                = "alert-failed-requests"
  display_name        = "Utility Hub - Failed Requests"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"
  severity             = 2
  enabled              = true

  scopes = [
    azurerm_log_analytics_workspace.main.id
  ]

  criteria {
    query = <<-QUERY
      AppRequests
      | where Success == false or toint(ResultCode) >= 400
      | summarize AggregatedValue = count()
    QUERY

    time_aggregation_method = "Total"
    metric_measure_column   = "AggregatedValue"
    threshold               = 0
    operator                = "GreaterThan"

    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  action {
    action_groups = [
      azurerm_monitor_action_group.operations.id
    ]
  }

  auto_mitigation_enabled = true

  tags = {
    project     = "azure-cloud-security-operations"
    environment = "portfolio"
    managed_by  = "terraform"
  }
}