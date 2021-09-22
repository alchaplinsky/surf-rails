class DownloadPresenter

  def initialize(user_agent)
    @browser = Browser.new user_agent, accept_language: 'en-us'
  end

  def as_json
    {
      platform: platform,
      installer: installer_url,
      version: version,
      supported: platform_supported?,
      platforms: {
        mac: {
          installer: mac_installer_url,
          version: mac_version
        },
        windows: {
          installer: windows_installer_url,
          version: windows_version
        }
      }
    }
  end

  protected

  def platform_supported?
    [:mac, :windows].include?(platform)
  end

  def platform
    @platform = @browser.platform.id
  end

  def mac_installer_url
    Settings.desktop.mac.installer_url
  end

  def windows_installer_url
    Settings.desktop.windows.installer_url
  end

  def mac_version
    Settings.desktop.mac.version
  end

  def windows_version
    Settings.desktop.windows.version
  end

  def installer_url
    case platform
    when :mac
      mac_installer_url
    when :windows
      windows_installer_url
    else
      ''
    end
  end

  def version
    case platform
    when :mac
      mac_version
    when :windows
      windows_version
    else
      ''
    end
  end

end
