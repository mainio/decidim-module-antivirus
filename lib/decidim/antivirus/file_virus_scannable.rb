# frozen_string_literal: true

module Decidim
  module Antivirus
    module FileVirusScannable
      extend ActiveSupport::Concern

      included do
        validates :file, antivirus: true
      end
    end
  end
end
