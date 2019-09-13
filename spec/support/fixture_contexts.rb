shared_context 'fixtures' do
  let(:mail_config_data) do
    Fabricate.build(:mail_config).data
  end

  let(:mail_channel) do
    ServiceNotifications::Channels::Mail.new mail_config_data[:channels][:mail]
  end

  let(:content) do
    ServiceNotifications::Content.new(post: ServiceNotifications::Post.new)
  end

  def recipient_data(id = 1)
    { uid: id, email: "#{id}@example.com" }
  end

  def fabricate_recipient(id = 1)
    ServiceNotifications::Recipient.new recipient_data(id)
  end

  let(:recipient) do
    fabricate_recipient
  end

  let(:kind) { 'no_op' }
  let(:config) { Fabricate("#{kind}_config") }
  let(:template) { Fabricate("#{kind}_template", config: config) }
  let(:request) { Fabricate("#{kind}_request", config: template.config) }
  let(:post) { Fabricate("#{kind}_post", request: request) }
end