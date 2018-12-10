# frozen_string_literal: true

require "spec_helper"

describe Decidim::Antivirus::FileVirusScannable do
  let(:subject) do
    Class.new do
      include ActiveModel::Model # For `attr_accessor`
      include ActiveModel::Validations # Testing the validators

      attr_accessor :file # Getters and setters for `file`

      include Decidim::Antivirus::FileVirusScannable
    end
  end

  it "has the AntivirusValidator attached to the file attribute" do
    validator_kinds = subject.validators.select { |v|
      v.attributes.include?(:file)
    }.map(&:kind)

    expect(validator_kinds).to include(:antivirus)
  end
end
