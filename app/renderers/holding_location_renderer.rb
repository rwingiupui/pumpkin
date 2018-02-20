class HoldingLocationRenderer < CurationConcerns::Renderers::AttributeRenderer
  def initialize(value, options = {})
    super(:location, value, options)
  end

  def value_html
    Array(values).map do |value|
      location_string(HoldingLocationService.find(value))
    end.join("")
  end

  private

    def attribute_value_to_html(value)
      loc = HoldingLocationService.find(value)
      li_value location_string(loc)
    end

    def location_string(loc)
      contact_string = safe_join(['Contact at ',
                                  content_tag(:a,
                                              loc.email,
                                              href: "mailto:#{loc.email}"),
                                  ', ',
                                  content_tag(:a,
                                              loc.phone,
                                              href: "tel:#{loc.phone}")])
      safe_join([loc.label, loc.address, contact_string], tag(:br))
    end
end
