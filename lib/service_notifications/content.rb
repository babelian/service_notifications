# frozen_string_literal: true

module ServiceNotifications
  # Content for an {Adapter}, can have multiple formats (eg html, plain)
  #
  # @abstract
  class Content < Initializer
    params do
      post Post
    end

    delegate :channel, :objects, to: :post

    # @param [String] format (html, plain, etc)
    # @return [String]
    def render(format)
      return unless template = template_for(format)

      Renderer.new(template: template).call(objects)
    end

    private

    # @param [String] format for a template
    # @return [Template]
    def template_for(format)
      post.templates.find { |t| t.format == format }
    end
  end
end