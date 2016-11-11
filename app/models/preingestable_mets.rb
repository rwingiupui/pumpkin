class PreingestableMETS
  FILE_PATTERN = '*.mets'
  include PreingestableDocument
  LOCAL_RECORD_CLASS = ::IuMetadata::MetsRecord
  SOURCE_TITLE = ['METS XML']

  def default_attributes
    super.merge(local_record.default_attributes)
  end
end
