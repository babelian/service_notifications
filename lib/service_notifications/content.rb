# frozen_string_literal: true

module ServiceNotifications
  # Content for an {Adapter}
  class Content < Initializer
    params do
      post Post
    end

    delegate :channel, :objects, to: :post

    def template_for(format)
      post.templates.find { |t| t.format == format }
    end

    def render(format)
      return unless template = template_for(format)
      Renderer.new(template: template).call(objects)
    end
  end
end