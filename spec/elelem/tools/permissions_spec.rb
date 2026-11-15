# frozen_string_literal: true

RSpec.describe Elelem::Tools::Permissions do
  subject { described_class.new }

  let(:input) { double(ask: nil, interactive?: false) }

  describe "#check" do
    context "with default allow policies" do
      it "allows verify, whose commands are still checked as execute" do
        expect(subject.check("verify", { "path" => "a.rb" }, input: input)).to be true
      end

      it "allows read without prompting" do
        expect(subject.check("read", {}, input: input)).to be true
        expect(input).not_to have_received(:ask)
      end
    end

    context "with deny policy" do
      subject { described_class.new(rules: { write: :deny }) }

      it { expect { subject.check("write", {}, input: input) }.to raise_error(/Permission denied/) }
    end

    context "with ask policy on a non-interactive input" do
      it "returns true without prompting" do
        expect(subject.check("execute", {}, input: input)).to be true
        expect(input).not_to have_received(:ask)
      end
    end

    context "with ask policy on an interactive input" do
      let(:input) { double(ask: answer, interactive?: true) }

      context "when approved" do
        let(:answer) { "y" }

        it "prompts and returns true" do
          expect(subject.check("execute", {}, input: input)).to be true
          expect(input).to have_received(:ask)
        end
      end

      context "when denied" do
        let(:answer) { "n" }

        it { expect { subject.check("execute", {}, input: input) }.to raise_error(/User denied permission/) }
      end

      context "at end of input" do
        let(:answer) { nil }

        it { expect { subject.check("execute", {}, input: input) }.to raise_error(/User denied permission/) }
      end

      context "when the answer is an empty line" do
        let(:answer) { "" }

        it { expect(subject.check("execute", {}, input: input)).to be true }
      end

      context "with arguments" do
        let(:answer) { "y" }

        it "shows the whole command" do
          subject.check("execute", { "command" => "rg -n foo ." }, input: input)

          expect(input).to have_received(:ask).with("  Allow execute `rg -n foo .`? [Y/n] > ")
        end

        it "escapes newlines so no line is hidden" do
          subject.check("execute", { "command" => "ls\nrm -rf x" }, input: input)

          expect(input).to have_received(:ask).with("  Allow execute `\"ls\\nrm -rf x\"`? [Y/n] > ")
        end

        it "escapes characters that could redraw the prompt" do
          subject.check("execute", { "command" => "rm -rf ~ \r  Allow execute `ls" }, input: input)

          expect(input).to have_received(:ask).with("  Allow execute `\"rm -rf ~ \\r  Allow execute `ls\"`? [Y/n] > ")
        end

        it "shows other tools' arguments as JSON" do
          subject.check("grep", { "pattern" => "foo" }, input: input)

          expect(input).to have_received(:ask).with("  Allow grep `{\"pattern\":\"foo\"}`? [Y/n] > ")
        end
      end
    end

    context "with a misspelled policy on an interactive input" do
      subject { described_class.new(rules: { execute: :dney }) }

      let(:input) { double(ask: "n", interactive?: true) }

      it "asks" do
        expect { subject.check("execute", {}, input: input) }.to raise_error(/User denied permission/)
        expect(input).to have_received(:ask)
      end
    end
  end

  describe "loading a config" do
    it "asks for a value that is not a string" do
      Dir.mktmpdir do |dir|
        path = File.join(dir, "permissions.json")
        File.write(path, '{"execute": false}')
        rules = subject.send(:load_config, path)
        input = double(ask: "n", interactive?: true)
        expect { described_class.new(rules: rules).check("execute", {}, input: input) }
          .to raise_error(/User denied permission/)
      end
    end

    it "ignores a file that is not an object" do
      Dir.mktmpdir do |dir|
        path = File.join(dir, "permissions.json")
        File.write(path, "[]")
        expect(subject.send(:load_config, path)).to eq({})
      end
    end
  end
end
