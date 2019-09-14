# ServiceNotifications

Provides a uniform method for pushing notifications to users.

[![Build Status](https://www.travis-ci.com/babelian/service_notifications.svg?branch=master)](https://www.travis-ci.com/babelian/service_notifications)

[![Maintainability](https://api.codeclimate.com/v1/badges/67caebc2fd1519c837ec/maintainability)](https://codeclimate.com/github/babelian/service_notifications/maintainability)

[![Test Coverage](https://api.codeclimate.com/v1/badges/67caebc2fd1519c837ec/test_coverage)](https://codeclimate.com/github/babelian/service_notifications/test_coverage)

[![Inline docs](http://inch-ci.org/github/babelian/service_notifications.svg?branch=master)](http://inch-ci.org/github/babelian/service_notifications)

## Features

* Run as a gem inside your application (with an [ActiveRecord](https://github.com/rails/rails) backend) or stand alone via AWS [Lambda](https://aws.amazon.com/lambda/) (with [DynamoDB](https://aws.amazon.com/dynamodb/)).
* Store multiple configurations (each with their own templates) to support a multi-tenant model.
* Templating:
 * Separate templates for each configuration with versioning.
 * Rendered via [Liquid](http://liquidmarkup.org), with support for object interpolations.
 * Optional [Premailer](https://github.com/premailer/premailer) processing.
* Adapters for:
 * [MailGun](https://mailgun.com)
 * [Slack](https://slack.com)
 * ... Apple/Android/Twilio etc to come.


## Lifecycle

Data:

A `Request` is injected with `Config` and creates one or more `Post` records for processing asyncronously.

Each `Post` is associated with a `Channel` and a `Recipient`.

The `Channel` will inject the `Post` data into a `Content` class which optionally uses a `Template` to render the output. The result is then passed to an `Adapter` to push out to a third-party system.


## Sample Setup

```ruby

  config = Config.create(
    data: {
      template_version: 'v1',
      channels: {
        mail: {
          adapter: { name: 'mailgun' },
          from: 'Notification<noreply@orgname.org>', reply_to: 'Notification<noreply@orgname.org>'
        }
      }
    }
  )

  html_template = Template.create(
    config_id: config.id, version: 'v1',
    notification: 'inline', channel: 'mail', format: 'html', data: '{{html}}'
  )

  plain_template = Template.create(
    config_id: config.id, version: 'v1',
    notification: 'inline', channel: 'mail', format: 'plain', data: '{{plain}}'
  )

  result = MakeRequest.call(
    instant: true, api_key: config.api_key, notification: 'inline',
    recipients: [
      { uid: 1, email: 'your@email.com' }
    ],
    objects: {
      plain: 'Plain content',
      html: '<title>Email Subject</title><strong>HTML</strong> content.'
    }
  )
```

## AWS Deployment

* See `Makefile` for setup and deployment.
* Use `AWS=1 guard` to run specs against the AWS setup.

## TODO

- [] Separate out gems for ActiveRecord and AWS dependencies (eg `service_notifications-active_record`) to remove gem dependencies.
- [] Better environment/configuration setup (mostly ENV or hardcoded).
- [] Documentation