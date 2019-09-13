Fabricator :template, class_name: 'ServiceNotifications::Template' do
  config(fabricator: :config)

  version { 'v1' }
  notification { 'namespace/test' }
  channel { 'no_op' }
  format { 'plain' }
  data do
    'The company is {{company_name}}'
  end
end

Fabricator :no_op_template, from: :template

Fabricator :mail_template, from: :template do
  config(fabricator: :mail_config)

  channel { 'mail' }

  data do
    <<~STR
      Subject: Plain subject to {{name}}

      Dear {{name}},

      This is your plain mail.

      {{company_name}}
    STR
  end
end

Fabricator :plain_mail_template, from: :mail_template

Fabricator :html_mail_template, from: :template do
  config(fabricator: :mail_config)
  channel { 'mail' }
  format { 'html' }

  data do
    <<~STR
      <html>
        <head>
          <title>HTML Subject to {{name}} </title>
        </head>
        <body>
          <p>
            Dear {{name}}
          </p>

          <p>
           This is your <strong>HTML</strong> mail.
          </p>

          <p>
            {{content}}
          </p>

          <p>
           {{company_name}}
          </p>
        </body>
      </html>
    STR
  end
end

Fabricator :slack_template, from: :template do
  channel { 'slack' }
  format { 'json' }
  data { nil }
end