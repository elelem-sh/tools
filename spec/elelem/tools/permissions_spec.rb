# frozen_string_literal: true

RSpec.describe Elelem::Tools::Permissions do
  subject { described_class.new }

  let(:input) { double(ask: nil, interactive?: false) }

  describe "#check" do
    context "with default allow policies" do
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
    end
  end
end
