class VariationsDocument
  FILE_PATTERN = '*.xml'
  include PreingestableDocument
  LOCAL_RECORD_CLASS = ::IuMetadata::VariationsRecord
  SOURCE_TITLE = ['Variations XML']

  delegate :default_attributes, to: :local_record
end
