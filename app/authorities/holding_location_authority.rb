class HoldingLocationAuthority
  def all
    digital_locations
  end

  def find(id)
    (all.select { |obj| obj['id'] == id } || []).first
  end

  private

    def digital_locations
      locations_path = Rails.root.join('config/digital_locations.yml')
      @digital_locations ||=
        YAML.safe_load(File.read(locations_path))
    end
end
