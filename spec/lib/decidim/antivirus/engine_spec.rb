# frozen_string_literal: true

require "spec_helper"

describe Decidim::Antivirus::Engine do
  it "sets up antivirus during initialization" do
    expect(Ratonvirus).to receive(:configure).and_call_original

    config = described_class.initializers.find do |i|
      i.name == "decidim_antivirus.setup"
    end
    config.run

    expect(Ratonvirus.scanner).to be_a(Ratonvirus::Scanner::Clamby)
    expect(Ratonvirus.storage).to be_a(Ratonvirus::Storage::Multi)
    expect(Ratonvirus.storage.config[:storages]).to eq(
      [:filepath, :carrierwave]
    )
  end

  context "when scanner is available" do
    before do
      allow(Ratonvirus.scanner).to receive(:available?).and_return(true)
    end

    it "adds FileVirusScannable to Decidim::Attachment" do
      expect(Decidim::Attachment).to receive(:include).with(
        Decidim::Antivirus::FileVirusScannable
      )
      run_to_prepare
    end
  end

  context "when scanner does not exist" do
    before do
      allow(Ratonvirus.scanner).to receive(:available?).and_return(false)
    end

    it "does not add FileVirusScannable to Decidim::Attachment" do
      expect(Decidim::Attachment).not_to receive(:include).with(
        Decidim::Antivirus::FileVirusScannable
      )
      run_to_prepare
    end
  end

  def run_to_prepare
    to_prepare = described_class.config.to_prepare_blocks
    to_prepare.each(&:call)
  end
end
