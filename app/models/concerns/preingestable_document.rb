module PreingestableDocument
  def initialize(source_file)
    @source_file = source_file.to_s
    @source_content = File.read(@source_file)
    @local_record = self.class.const_get(:LOCAL_RECORD_CLASS).new('file:///' + @source_file, @source_content)
    @source_title = self.class.const_get(:SOURCE_TITLE)
    @local_data = DataSource.new(@local_record.id, @local_record.local_attributes, factory: resource_class)
  end

  attr_reader :source_file, :source_title, :local_record, :local_data

  delegate :source_metadata_identifier, to: :local_record
  delegate :multi_volume?, to: :local_record
  delegate :files, :structure, :volumes, :thumbnail_path, to: :local_record

  DEFAULT_ATTRIBUTES = {
    state: 'final_review',
    viewing_direction: 'left-to-right',
    rights_statement: 'http://rightsstatements.org/vocab/NKC/1.0/',
    visibility: Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
  }

  def yaml_file
    @yaml_file ||= source_file.sub(/#{Pathname.new(source_file).extname}$/, '.yml')
  end

  def attributes
    { default: default_attributes, local: local_attributes, remote: remote_attributes }
  end

  def default_attributes
    @default_attributes ||= DEFAULT_ATTRIBUTES
  end

  def local_attributes
    @local_attributes ||= local_data.attribute_values
  end

  def remote_attributes
    @remote_attributes ||= remote_data.attribute_values
  end

  def source_metadata
    return unless remote_data.source
    @source_metadata ||= remote_data.source.dup.try(:force_encoding, 'utf-8')
  end

  def resource_class
    @resource_class ||= (multi_volume? ? MultiVolumeWork : ScannedResource)
  end

  def collection_slugs(collections = [])
    collections += Array.wrap(local_record.collection_slugs) if local_record.respond_to?(:collection_slugs)
    collections
  end

  private

    def remote_data
      @remote_data ||= remote_metadata_factory.retrieve(source_metadata_identifier)
    end

    def remote_metadata_factory
      if RemoteRecord.bibdata?(source_metadata_identifier)
        JSONLDRecord::Factory.new(resource_class)
      else
        RemoteRecord
      end
    end
end
