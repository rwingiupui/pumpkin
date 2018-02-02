class ManifestBuilder
  class CompositeBuilder
    attr_reader :services
    delegate :length, to: :services
    def initialize(*services)
      @services = services.compact
    end

    def apply(manifest)
      services.each do |service|
        service.apply(manifest)
      end
    end

    def respond_to_missing?(meth_name, _include_private)
      meth_name.to_sym.in?(%i[record path canvas]) ||
        services.map { |service| service.respond_to?(meth_name) }.any?
    end

    def method_missing(meth_name, *args, &block)
      if services.any?
        services.map do |service|
          service.__send__(meth_name, *args, &block)
        end
      elsif meth_name.to_sym.in? %i[record path canvas]
        []
      else
        super
      end
    end
  end
end
