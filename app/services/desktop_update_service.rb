class DesktopUpdateService
  ARCHS = %w(ia32 x64).freeze
  DARWIN_ALIASES = %w(darwin mac).freeze
  WINDOWS_ALIASES = %w(win32 windows).freeze
  LINUX_ALIASES = %w(linux).freeze
  SUPPORTED_PLATFORMS = %w(darwin_x64 windows_x64).freeze

  attr_reader :os, :arch, :platform

  def initialize(os, arch = 'x64', mode = 'live')
    @os = os_name os
    @arch = arch_name arch
    @platform = "#{@os}_#{@arch}"
    @mode = mode
  end

  def update_available?(version)
    platform_supported? and newer_version_available?(version)
  end

  def update_url
    case platform
    when 'darwin_x64'
      settings_root.mac.update_url
    when 'windows_x64'
      settings_root.windows.update_url
    else
      raise 'Unsupported platform'
    end
  end

  protected

  def platform_supported?
    SUPPORTED_PLATFORMS.include? platform
  end

  def newer_version_available?(version)
    Gem::Version.new(current_version) > Gem::Version.new(version)
  end

  def current_version
    case platform
    when 'darwin_x64'
      settings_root.mac.version
    when 'windows_x64'
      settings_root.windows.version
    else
      raise 'Unsupported platform'
    end
  end

  def os_name(name)
    case name
    when *DARWIN_ALIASES
      'darwin'
    when *WINDOWS_ALIASES
      'windows'
    when *LINUX_ALIASES
      'linux'
    else
      false
    end
  end

  def arch_name(name)
    ARCHS.include?(name) ? name : false
  end

  def settings_root
    if @mode == 'live'
      Settings.desktop
    else
      Settings.desktop_test
    end
  end

end
