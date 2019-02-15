# frozen_string_literal: true

require "spec_helper"

describe Decidim::Attachment do
  before do
    allow(Ratonvirus.scanner).to receive(:available?).and_return(true)

    # Make sure the to_prepare blocks are called
    Decidim::Antivirus::Engine.config.to_prepare_blocks.each(&:call)
  end

  context "with clean file" do
    subject { build(:attachment, :with_pdf) }

    before do
      expect(Ratonvirus.scanner).to receive(:run_scan)
    end

    it { is_expected.to be_valid }
  end

  context "with infected file" do
    subject { build(:attachment, :with_pdf) }

    before do
      expect(Ratonvirus.scanner).to receive(:run_scan) do
        Ratonvirus.scanner.errors << :antivirus_virus_detected
      end
    end

    it { is_expected.not_to be_valid }
  end
end
