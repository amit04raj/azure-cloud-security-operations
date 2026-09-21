resource "azurerm_application_insights_workbook" "operations" {
  name                = "7b4e6d1c-9f32-4a8e-b5c7-2d6f91a03458"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  display_name        = "Cloud Security Operations"
  source_id           = lower(azurerm_log_analytics_workspace.main.id)
  category            = "workbook"

  data_json = <<JSON
{
  "version": "Notebook/1.0",
  "items": [
    {
      "type": 1,
      "content": {
        "json": "# Cloud Security Operations\n\nUtility Hub operational monitoring and investigation."
      },
      "name": "header"
    },
    {
      "type": 3,
      "content": {
        "version": "KqlItem/1.0",
        "query": "AppRequests\n| where TimeGenerated > ago(1h)\n| summarize TotalRequests=count(), SuccessfulRequests=countif(Success == true), FailedRequests=countif(Success == false), AverageDurationMs=round(avg(DurationMs), 2), P95DurationMs=round(percentile(DurationMs, 95), 2)",
        "size": 0,
        "title": "Request Overview",
        "timeContext": {
          "durationMs": 3600000
        },
        "queryType": 0,
        "resourceType": "microsoft.operationalinsights/workspaces"
      },
      "name": "request-overview"
    },
    {
      "type": 3,
      "content": {
        "version": "KqlItem/1.0",
        "query": "AppRequests\n| where TimeGenerated > ago(24h)\n| where Success == false or toint(ResultCode) >= 400\n| project TimeGenerated, ResultCode, Name, Url, DurationMs, Success\n| order by TimeGenerated desc",
        "size": 0,
        "title": "Failed Requests",
        "timeContext": {
          "durationMs": 86400000
        },
        "queryType": 0,
        "resourceType": "microsoft.operationalinsights/workspaces"
      },
      "name": "failed-requests"
    },
    {
      "type": 3,
      "content": {
        "version": "KqlItem/1.0",
        "query": "AppTraces\n| where TimeGenerated > ago(24h)\n| where Message == 'calculator_request_rejected'\n| project TimeGenerated, SeverityLevel, Message, Properties\n| order by TimeGenerated desc",
        "size": 0,
        "title": "Application Rejection Events",
        "timeContext": {
          "durationMs": 86400000
        },
        "queryType": 0,
        "resourceType": "microsoft.operationalinsights/workspaces"
      },
      "name": "application-events"
    },
    {
      "type": 3,
      "content": {
        "version": "KqlItem/1.0",
        "query": "AppExceptions\n| where TimeGenerated > ago(24h)\n| project TimeGenerated, ProblemId, OuterMessage, InnermostMessage, Type, SeverityLevel\n| order by TimeGenerated desc",
        "size": 0,
        "title": "Application Exceptions",
        "timeContext": {
          "durationMs": 86400000
        },
        "queryType": 0,
        "resourceType": "microsoft.operationalinsights/workspaces"
      },
      "name": "exceptions"
    },
    {
      "type": 3,
      "content": {
        "version": "KqlItem/1.0",
        "query": "AppDependencies\n| where TimeGenerated > ago(24h)\n| where Success == false or toint(ResultCode) >= 400\n| project TimeGenerated, Target, DependencyType, Name, ResultCode, Success, DurationMs\n| order by TimeGenerated desc",
        "size": 0,
        "title": "Dependency Failures",
        "timeContext": {
          "durationMs": 86400000
        },
        "queryType": 0,
        "resourceType": "microsoft.operationalinsights/workspaces"
      },
      "name": "dependency-failures"
    }
  ],
  "isLocked": false
}
JSON

  tags = {
    project     = "azure-cloud-security-operations"
    environment = "portfolio"
    managed_by  = "terraform"
  }
}
