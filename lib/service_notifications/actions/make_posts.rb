# frozen_string_literal: true

module ServiceNotifications
  # Make each {Post} for the {Request}.
  #
  # @todo add transactional wrapper or error handling for {ProcessPosts}.
  class MakePosts < Action
    input do
      instant :boolean, optional: true
      debug :boolean, optional: true

      request_id :integer, optional: true
      request Request, optional: true
    end

    output do
      posts [Post]
      request Request
    end

    before do
      require_at_least_one_of(:request_id, :request)
    end

    def call
      return if processed? && posts # idempotent check and set {#posts} as its assured in output.

      recipients.each do |recipient|
        channels.keys.each do |channel|
          create_post(channel, recipient)
        end
      end

      request.update_attributes(processed_at: Time.now)
    end

    after do
      if instant
        ProcessPosts.call!(context)
      else
        context.process_posts_job = ProcessPosts.delay.call!(request_id: request.id)
      end
    end

    delegate :channels, :config, :notification, to: :request

    private

    def processed?
      request.processed_at
    end

    #
    # Data
    #

    def posts
      context { request.posts }
    end

    def request
      context { Request.find(request_id) }
    end

    def recipients
      request.recipients.any? ? request.recipients : [Recipient.new(uid: 'none')]
    end

    #
    # Actions
    #

    def create_post(channel, recipient = nil)
      return unless recipient.post?(notification, channel) # check recipient is subscribed.

      posts.create!(
        kind: channel.to_s, uid: recipient.uid, data: recipient.data, request_id: request.id
      )
    end
  end
end