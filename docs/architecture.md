# Azure Cloud Security Operations — Architecture

## Overview

Azure Cloud Security Operations is a small cloud monitoring and security-operations workload built around an Azure App Service application.

The platform collects application telemetry in Azure Application Insights, stores the workspace-based monitoring data in Log Analytics, uses KQL for investigation, and provides alerting and an operational workbook.

The application itself is a FastAPI-based utility application.

## Architecture

```text
                         USER
                           |
                         HTTPS
                           |
                           v
                +----------------------+
                |    Azure App Service |
                |    FastAPI Utility   |
                +----------+-----------+
                           |
                    Application telemetry
                           |
                           v
                +----------------------+
                |  Application Insights|
                +----------+-----------+
                           |
                           v
                +----------------------+
                |   Log Analytics      |
                |     Workspace        |
                +----+----------+------+
                     |          |
                    KQL        Alerts
                     |          |
                     v          v
             +-------------+  +----------------+
             | Investigation|  | Action Group   |
             | / KQL queries|  | Email receiver |
             +-------------+  +----------------+
                     |
                     v
             +----------------------+
             | Security Operations  |
             | Workbook             |
             +----------------------+
```

## Application Layer

The workload runs on Azure App Service using Python and FastAPI.

The application provides utility functions through its web interface and API endpoints.

Application logging is integrated with Azure Monitor through the Azure Monitor OpenTelemetry package when the Application Insights connection string is available.

The application records an explicit trace when a calculator request is rejected because of an invalid operation.

## Application Insights

Azure Application Insights provides application telemetry for the workload.

The collected telemetry includes application request data, traces, dependencies, and exception-related telemetry.

The deployment uses a workspace-based Application Insights resource connected to the Log Analytics workspace.

## Log Analytics

The Log Analytics workspace provides the central query layer for operational investigation.

The deployed environment uses the available Application Insights tables for queries, including:

```text
requests
traces
dependencies
exceptions
```

KQL queries are used to investigate application behavior and identify failed requests or application-generated events.

For example, failed HTTP 400 requests can be investigated from the `requests` table, while the application rejection event can be searched in `traces`.

## Detection and Alerting

A failed-request alert is configured to detect failed requests in the monitoring environment.

The alert rule:

```text
Name:    alert-failed-requests
Severity: 2 - Warning
Condition: AggregatedValue > 0
```

The alert is connected to the `ag-cloud-security-operations` Action Group.

The Action Group contains a verified email receiver.

The captured alert history demonstrates alert instances firing and subsequently resolving.

## Investigation Workflow

The monitoring workflow is:

```text
Observe
   |
   v
Telemetry
   |
   v
Detect
   |
   v
Alert
   |
   v
Investigate with KQL
   |
   v
Review in Workbook
```

The application was also tested by generating a controlled invalid calculator operation. This produced an HTTP 400 response and the corresponding application trace used for investigation.

## Security Operations Workbook

The project includes an Azure Workbook named:

```text
Cloud Security Operations
```

The workbook provides an operational view of application activity.

The current workbook contains a working Request Overview panel. Other panels were retained as part of the workbook design but may return no results depending on the available telemetry and query time range.

The workbook should therefore be treated as an operational dashboard rather than evidence that every panel currently contains data.

## Infrastructure as Code

Terraform manages the Azure infrastructure, including:

- Resource Group
- App Service
- Log Analytics workspace
- Application Insights
- Application configuration
- Monitoring-related resources

The infrastructure can be checked with Terraform plan to verify that the deployed environment matches the configuration.

## CI/CD

GitHub Actions is used to test and deploy the application to Azure App Service.

The deployment workflow includes application testing, Azure authentication, application deployment, and a post-deployment health check.

## Design Considerations

The project focuses on practical cloud security operations rather than introducing a large security platform.

The architecture uses Azure-native monitoring components to demonstrate:

- Application telemetry
- Centralized log analysis
- KQL investigation
- Detection through alerts
- Alert notification configuration
- Operational visualization
- Infrastructure as Code
- Automated deployment

The design deliberately avoids adding a separate SIEM or additional security services where the current workload does not require them.
