Fabricator :request, class_name: 'ServiceNotifications::Request' do
  config(fabricator: :config)
  data do
    {
      notification: 'namespace/test',
      channels: {
        no_op: {
          value1: 'from request'
        }
      },
      recipients: [{ uid: SecureRandom.uuid }]
    }
  end
end

Fabricator :no_op_request, from: :request

Fabricator :mail_request, from: :request do
  config(fabricator: :mail_config)
  after_build do |request, _trans|
    request.data.merge!(
      channels: {
        mail: {
          reply_to: 'help@new.co'
        }
      },
      objects: { content: 'Request Content' }
    )
  end
end

Fabricator :slack_request, from: :request do
  config(fabricator: :slack_config)
  after_build do |request, _trans|
    request.data.merge!(
      objects: { username: 'RequestTester' }
    )
  end
end