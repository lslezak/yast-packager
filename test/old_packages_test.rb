#! /usr/bin/env rspec

require_relative "test_helper"

require "y2packager/old_packages"
require "y2packager/version_check"

describe Y2Packager::OldPackages do
  let(:old_packages) do
    {
      "yast2"              => "4.1.77-3.1.3",
      "yast2-pkg-bindings" => "4.1.2-3.5.9"
    }
  end
  let(:checker) { Y2Packager::VersionCheck.new(old_packages) }
  subject { Y2Packager::OldPackages.new(checker) }

  describe "#check" do
    context "no old packages found" do
      before do
        expect(checker).to receive(:old_packages).and_return([])
      end

      it "does not display any message" do
        expect(Yast::Report).to_not receive(:Warning)
        subject.check
      end
    end

    context "some packages found" do
      let(:old1) { Y2Packager::Resolvable.new("name" => "yast2", "version" => "4.1.69-1.2") }
      let(:old2) do
        Y2Packager::Resolvable.new(
          "name" => "yast2-pkg-bindings", "version" => "4.1.1-1.2"
        )
      end

      before do
        expect(checker).to receive(:old_packages).and_return([old1, old2])
      end

      it "displays a warning message" do
        expect(Yast::Report).to receive(:Warning).with(/old package version/)
        subject.check
      end
    end
  end
end
