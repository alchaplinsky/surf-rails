CarrierWave.configure do |config|
  config.storage           = Settings.carrierwave.storage
  config.asset_host        = Settings.carrierwave.asset_host
end
