# frozen_string_literal: true

require "spec_helper"

describe Decidim::Antivirus::FileVirusScannable do
  subject do
    Class.new do
      include ActiveModel::Model # For `attr_accessor`
      include ActiveModel::Validations # Testing the validators

      attr_accessor :file # Getters and setters for `file`

      include Decidim::Antivirus::FileVirusScannable
    end
  end

  it "has the AntivirusValidator attached to the file attribute" do
    validator_kinds = subject.validators.select do |v|
      v.attributes.include?(:file)
    end.map(&:kind)

    expect(validator_kinds).to include(:antivirus)
  end
end
