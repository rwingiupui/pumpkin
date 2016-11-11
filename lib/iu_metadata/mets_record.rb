module IuMetadata
  class MetsRecord < METSDocument
    def initialize(id, source)
      @id = id
      @source = source
      @mets = Nokogiri::XML(source)
      @source_file = 'foo'
    end
    attr_reader :id, :source, :mets

    def local_attributes
      { identifier: identifier,
        replaces: replaces,
        source_metadata_identifier: source_metadata_identifier,
        viewing_direction: viewing_direction
      }
    end

    def default_attributes
      { viewing_direction: viewing_direction }
    end

    def volumes
      volumes = []
      volume_ids.each do |volume_id|
        volume_hash = {}
        volume_hash[:title] = [label_for_volume(volume_id)]
        volume_hash[:structure] = structure_for_volume(volume_id)
        volume_hash[:files] = files_for_volume(volume_id)
        volumes << volume_hash
      end
      volumes
    end

    def identifier
      ark_id
    end

    def replaces
      pudl_id
    end

    def source_metadata_identifier
      bib_id
    end

    def files
      add_file_attributes super
    end

    private

      def add_file_attributes(file_hash_array)
        file_hash_array.each do |f|
          f[:file_opts] = file_opts(f)
          f[:attributes] ||= {}
          f[:attributes][:title] = [file_label(f[:id])]
          f[:attributes][:replaces] = "#{pudl_id}/#{File.basename(f[:path], File.extname(f[:path]))}"
          f[:attributes][:source_metadata_identifier] = "#{File.basename(f[:path]).sub(/\..*?$/, '').upcase}"
        end
        file_hash_array
      end

      def files_for_volume(volume_id)
        add_file_attributes super
      end
  end
end
