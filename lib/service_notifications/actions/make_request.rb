# frozen_string_literal: true

module ServiceNotifications
  # Receive the request, validate it, and queue {MakePosts}.
  #
  # @todo add transactional wrapper or error handling for {MakePosts}.
  class MakeRequest < Action
    ERRORS = {
      authorization_failed: 'Authorization failed'
    }.freeze

    input do
      api_key :string

      # do not background {MakePosts}
      instant :boolean, default: false
      debug :boolean, default: false

      # payload data:
      notification :string, default: 'none'
      objects :hash, default: {}
      recipients [:hash], default: []
    end

    output do
      request Request
      config Config, optional: true
      posts [Post], optional: true
      make_posts_job Any(String, Integer), optional: true
    end

    before do
      context.instant = true if debug # always run full functionality in debug mode

      config || fail!(:authorization_failed)
    end

    def call
      fail_unless_persisted!(request)
    end

    after do
      if instant
        context.posts = MakePosts.call!(request: request, instant: true, debug: debug).posts
      else
        context.make_posts_job = MakePosts.delay.call!(request_id: request.id)
      end
    end

    private

    def config
      context { Config.where(api_key: api_key).first }
    end

    def data
      context.to_h(:notification, :objects, :recipients)
    end

    def request
      context do
        request = Request.create(config: config, data: data)
        context.data_errors = request.data_errors if request.new_record?
        request
      end
    end
  end
end