Fabricator :post, class_name: 'ServiceNotifications::Post' do
  request(fabricator: :request)
  kind { 'no_op' }
  uid { SecureRandom.uuid }
  data do
    {
      email: '1@example.com'
    }
  end
end

Fabricator :no_op_post, from: :post

Fabricator :mail_post, from: :post do
  request(fabricator: :mail_request)
  kind { 'mail' }
  data do
    {
      email: '1@example.com',
      objects: {
        name: 'UserName'
      }
    }
  end
end

Fabricator :slack_post, from: :post do
  request(fabricator: :slack_request)
  kind { 'slack' }
  data do
    { objects: { channel: '#test', text: 'hello' } }
  end
end