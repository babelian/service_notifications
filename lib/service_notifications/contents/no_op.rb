# frozen_string_literal: true

module ServiceNotifications
  module Contents
    # Mail Content
    class NoOp < Content
      def body
        render('plain')
      end
    end
  end
end