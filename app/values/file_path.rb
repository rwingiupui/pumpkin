class FilePath
  attr_reader :uri
  def initialize(uri)
    @uri = ::URI.encode(uri).to_s # rubocop:disable Lint/UriEscapeUnescape
  end

  def clean
    ::URI.split(uri).compact.last
  end
end
