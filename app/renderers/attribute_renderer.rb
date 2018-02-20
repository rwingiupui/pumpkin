class AttributeRenderer < CurationConcerns::Renderers::AttributeRenderer
  # Draw the table row for the attribute
  # rubocop:disable Metrics/AbcSize, Rails/OutputSafety
  def render
    markup = ''

    return markup if values.blank? && !options[:include_empty]
    markup << %(<tr><th>#{label}</th>\n<td><ul class='tabular'>)
    attributes = microdata_object_attributes(field) \
                 .merge(class: "attribute #{field}")
    Array(values).each do |value|
      markup << li_markup(value, attributes)
    end
    markup << %(</ul></td></tr>)
    markup.html_safe
  end
  # rubocop:enable Metrics/AbcSize, Rails/OutputSafety

  def li_markup(value, attributes)
    "<li#{html_attributes(attributes)}" \
    " dir=#{value.dir}>#{attribute_value_to_html(value.to_s)}</li>"
  end
end
