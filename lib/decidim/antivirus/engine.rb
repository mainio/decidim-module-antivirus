# frozen_string_literal: true

module Decidim
  module Antivirus
    class Engine < ::Rails::Engine
      initializer "decidim_antivirus.setup", before: :load_config_initializers do
        Ratonvirus.configure do |config|
          config.scanner = :clamby
          config.storage = :multi, {
            storages: [:filepath, :carrierwave]
          }
        end
      end

      config.to_prepare do
        if Ratonvirus.scanner.available?
          # Add virus scanning to the Decidim attachments
          Decidim::Attachment.send(:include, FileVirusScannable)
        end
      end
    end
  end
end
