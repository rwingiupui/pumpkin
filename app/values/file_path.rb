class FilePath
  attr_reader :uri
  def initialize(uri)
    @uri = ::URI.encode_www_form_component(uri).to_s
  end

  def clean
    ::URI.split(uri).compact.last
  end
end
