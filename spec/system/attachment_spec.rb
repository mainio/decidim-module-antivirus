# frozen_string_literal: true

require "spec_helper"

module Decidim::Admin
  describe "Admin manages attachments" do
    let(:organization) { create(:organization) }
    let!(:participatory_process) { create(:participatory_process, organization:) }
    let!(:admin) { create(:user, :admin, :confirmed, organization:) }

    let(:eicar_virus) { 'X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*' }
    let(:virus_file_path) { Rails.root.join("tmp/eicar_test.txt") }

    before do
      allow(Ratonvirus.scanner).to receive(:available?).and_return(true)

      File.write(virus_file_path, eicar_virus)

      Decidim::Antivirus::Engine.config.to_prepare_blocks.each(&:call)

      switch_to_host(organization.host)
      login_as admin, scope: :user
      visit decidim_admin_participatory_processes.edit_participatory_process_path(participatory_process)
    end

    context "when uploading infected file" do
      it "shows error message when virus is detected" do
        within_admin_sidebar_menu do
          click_on "Attachments"
        end

        within "#attachments" do
          click_on "New attachment"
        end

        within ".new_attachment" do
          fill_in_i18n(
            :attachment_title,
            "#attachment-title-tabs",
            en: "Test attachment",
            es: "Test attachment",
            ca: "Test attachment"
          )
          fill_in_i18n(
            :attachment_description,
            "#attachment-description-tabs",
            en: "Test description",
            es: "Test description",
            ca: "Test description"
          )
        end

        within ".new_attachment" do
          click_on("Add file")
        end

        within "[role='dialog']" do
          attach_file("attachment[file]", virus_file_path, make_visible: true)
        end

        expect(page).to have_content("Validation error!")
      end
    end
  end
end
