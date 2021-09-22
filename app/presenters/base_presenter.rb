class BasePresenter
  class << self

    def [](version)
      @@version = version
      return self
    end

    def attributes(*attrs)
      if attrs.empty?
        @attrs || []
      else
        @attrs = attrs
      end
    end

    def map(objects, *args)
      objects.map { |object| args.present? ? new(object, *args) : new(object) }
    end
  end

  attr_reader \
  :object,
  :arguments,
  :custom_methods,
  :default_methods

  def initialize(object, arguments = {})
    @object = object
    @arguments = arguments
  end

  def data
    @object
  end

  def as_json(options = {})
    return nil unless @object.present?
    split_attributes
    json = build_default_json(options)
    json = set_custom_methods(json)
    json
  end

  def to_json(options = {})
    MultiJson.dump(as_json)
  end

  private

  def split_attributes
    @custom_methods, @default_methods = self.class.attributes.partition do |attribute|
      self.respond_to?(attribute)
    end
  end

  def build_default_json(options = {})
    data.as_json(
      {
        root: false,
        only: default_methods,
        methods: default_methods
      }.merge(options)
    )
  end

  def set_custom_methods(json)
    custom_methods.each do |method|
      json[method] = self.send method
    end
    json
  end
end
