RSpec.configure do |config|
  if defined?(CarrierWave)
    CarrierWave::Uploader::Base.descendants.each do |klass|
      next if klass.anonymous?

      klass.class_eval do
        def cache_dir
          "uploads/spec/cache"
        end

        def store_dir
          "uploads/spec/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
        end
      end
    end
  end
  config.after(:all) do
    if Rails.env.test?
      FileUtils.rm_rf(Dir["#{Rails.root}/public/uploads/spec"])
    end
  end
end
