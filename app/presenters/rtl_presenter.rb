module RTLPresenter
  include ActionView::Helpers::TagHelper
  extend ActiveSupport::Concern

  included do
    def field_config(field)
      super(field).tap do |config|
        unless config.separator_options
          config.separator_options = { words_connector: "<br/>",
                                       last_word_connector: "<br/>",
                                       two_words_connector: "<br/>" }
        end
      end
    end

    private

      def to_list(values)
        li_entries = values.split('<br/>').map do |value|
          content_tag(:li, value, dir: value.dir)
        end.inject(&:+)
        content_tag(:ul, li_entries)
      end
  end
end
