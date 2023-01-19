# Terraform AWS - Cloudwatch Slack alerts

## Features

- SNS topic
- cloudwatch alerts
- slack alerts

### It depends on infra units
- none

- - - -

Send cloudwatch notifications to the `${local.name_prefix}-cloudwatch-alarms` SNS topic.

Add the `SLACK_WEBHOOK_URL` environment property to lambda config.

Create a new slack app and enable webhooks: `https://api.slack.com/apps`
