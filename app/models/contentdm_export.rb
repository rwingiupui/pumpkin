class ContentdmExport
  FILE_PATTERN = '*.xml'
  include PreingestableDocument
  LOCAL_RECORD_CLASS = ::IuMetadata::ContentdmRecord
  SOURCE_TITLE = ['Contentdm XML']

  def remote_attributes
    {}
  end

  def source_metadata
    nil
  end
end
