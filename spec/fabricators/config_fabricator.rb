Fabricator :config, class_name: 'ServiceNotifications::Config' do
  data do
    {
      channels: {
        no_op: {
          value1: 'from config',
          value2: 'from config',
          adapter: {
            name: 'no_op',
            status: 'OK'
          }
        }
      },
      template_version: 'v1',
      objects: { company_name: 'NewCo' },
      interpolations: { company_url: 'http://www.new.co' }
    }
  end
end

Fabricator :no_op_config, from: :config

Fabricator :mail_config, from: :config do
  after_build do |config, _trans|
    config.data.merge!(
      channels: {
        mail: {
          from: 'NewCo <from@new.co>',
          reply_to: 'noreply@newco.co',
          adapter: {
            name: 'mailgun',
            domain: ENV['MAILGUN_DOMAIN'],
            api_key: ENV['MAILGUN_API_KEY']
          }
        }
      }
    )
  end
end

Fabricator :slack_config, from: :config do
  after_build do |config, _trans|
    config.data.merge!(
      channels: {
        slack: {
          adapter: {
            name: 'slack',
            url: ENV['SLACK_URL'] || 'https://hooks.slack.com/services/XXX'
          }
        }
      },
      objects: { username: 'Config Tester' }
    )
  end
end