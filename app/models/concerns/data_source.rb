class DataSource
  def initialize(id, source_attributes, factory: ScannedResource, context: DEFAULT_CONTEXT)
    @id = id
    @source_attributes = source_attributes.stringify_keys
    @factory = factory
    @context = context
  end
  attr_reader :id, :source_attributes, :factory, :context

  def attributes
    @attributes ||=
      begin
        Hash[
          cleaned_attributes.map do |k, _|
            [k, proxy_record_value(k)]
          end
        ]
      end
  end

  def attribute_values
    @attribute_values ||=
      begin
        values = {}
        attributes.each do |k, v|
          values[k] = Array.wrap(v).map(&:value)
          values[k] = values[k].first if single_valued?(k)
        end
        values
      end
  end

  def proxy_record_value(attribute, literal: true)
    values = proxy_record.get_values(attribute, literal: literal)
    values = values.first if single_valued?(attribute)
    values
  end

  def single_valued?(attribute)
    proxy_record.class.properties[attribute.to_s].respond_to?(:multiple?) &&
      !proxy_record.class.properties[attribute.to_s].multiple?
  end

  def appropriate_fields
    outbound_predicates = outbound_graph.predicates.to_a
    result = proxy_record.class.properties.select do |_key, value|
      outbound_predicates.include?(value.predicate)
    end
    result.keys
  end

  private

    def proxy_record
      @proxy_record ||= factory.new.tap do |resource|
        outbound_graph.each do |statement|
          resource.resource << RDF::Statement.new(resource.rdf_subject, statement.predicate, statement.object)
        end
      end
    end

    def cleaned_attributes
      proxy_record.attributes.select do |k, _v|
        appropriate_fields.include?(k)
      end
    end

    def outbound_graph
      @outbound_graph ||= generate_outbound_graph
    end

    DEFAULT_CONTEXT = YAML.load(File.read(Rails.root.join('config/context.yml')))

    def generate_outbound_graph
      jsonld_hash = {}
      jsonld_hash['@context'] = context["@context"]
      jsonld_hash['@id'] = id
      jsonld_hash.merge!(source_attributes)
      outbound_graph = RDF::Graph.new << JSON::LD::API.toRdf(jsonld_hash)
      outbound_graph
    end
end
