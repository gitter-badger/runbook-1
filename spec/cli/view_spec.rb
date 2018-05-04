require "spec_helper"

RSpec.describe "runbook view", type: :aruba do
  let(:runbook_file) { "my_runbook.rb" }
  let(:runbook_registration) {}
  let(:content) do
    <<-RUNBOOK
    runbook = Runbook.book "My Runbook" do
      section "First Section" do
        step "Print stuff" do
          command "echo 'hi'"
          ruby_command {}
        end
      end
    end
    #{runbook_registration}
    RUNBOOK
  end

  before(:each) { write_file(runbook_file, content) }
  before(:each) { run(command) }

  describe "input specification" do
    context "runbook is passed as an argument" do
      let(:command) { "runbook view #{runbook_file}" }

      it "prints a markdown representation of the runbook" do
        expect(last_command_started).to have_output(/echo 'hi'/)
      end

      context "without runbook_registration" do
        let(:runbook_registration) {}

        it "does not render code blocks" do
          expect(last_command_started).to have_output(/Unable to retrieve source code/)
        end
      end

      context "with runbook_registration" do
        let(:runbook_registration) do
          "Runbook.books[:my_runbook] = runbook"
        end

        it "renders code blocks" do
          expect(last_command_started).to_not have_output(/Unable to retrieve source code/)
        end
      end
    end

    context "when an unknown file is passed in as an argument" do
      let(:command) { "runbook view unknown" }
      let(:unknown_file_output) {
        "view: cannot access unknown: No such file or directory"
      }

      it "prints an unknown file message" do
        expect(last_command_started).to have_output(unknown_file_output)
      end
    end

    context "runbook is written to standard in" do
      it "prints a markdown representation of the runbook"
    end

    context "when input is specified as ruby" do
      it "reads the file as a ruby file"
    end

    context "when input is specified as unknown" do
      it "prints an unknown input format message"
    end
  end

  describe "output specification" do
    context "when output is specified as markdown" do
      it "prints a markdown representation of the runbook"
    end

    context "when output is specified as unknown" do
      it "prints an unknown output format message"
    end
  end
end
