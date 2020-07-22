#! /usr/bin/env rspec

require_relative "test_helper"
require "y2packager/version_check"

describe Y2Packager::VersionCheck do

  let(:old_packages) do
    {
      "yast2"              => "4.1.77-1.1",
      "yast2-pkg-bindings" => "4.1.2-3.5.9"
    }
  end

  let(:old_yast2) do
    Y2Packager::Resolvable.new("name" => "yast2", "version" => "4.1.69-1.2")
  end
  let(:old_pkg_bindings) do
    Y2Packager::Resolvable.new("name" => "yast2-pkg-bindings", "version" => "4.1.1-1.2")
  end

  describe "#old_packages" do
    it "reports old packages" do
      checker = described_class.new(old_packages)
      selected = Y2Packager::Resolvable.new("name" => "yast2", "version" => "4.1.69-1.2")

      expect(Y2Packager::Resolvable).to receive(:find)
        .with(kind: :package, status: :selected, name: "yast2")
        .and_return([selected])

      expect(Y2Packager::Resolvable).to receive(:find)
        .with(kind: :package, status: :selected, name: "yast2-pkg-bindings")
        .and_return([])

      expect(checker.old_packages).to eq([selected])
    end

    it "does not report new packages" do
      checker = described_class.new(old_packages)
      selected = Y2Packager::Resolvable.new("name" => "yast2", "version" => "4.1.78-1.1")

      expect(Y2Packager::Resolvable).to receive(:find)
        .with(kind: :package, status: :selected, name: "yast2")
        .and_return([selected])

      expect(Y2Packager::Resolvable).to receive(:find)
        .with(kind: :package, status: :selected, name: "yast2-pkg-bindings")
        .and_return([])

      expect(checker.old_packages).to eq([])
    end

    it "reports the same package" do
      checker = described_class.new(old_packages)
      selected = Y2Packager::Resolvable.new("name" => "yast2", "version" => "4.1.77-1.1")

      expect(Y2Packager::Resolvable).to receive(:find)
        .with(kind: :package, status: :selected, name: "yast2")
        .and_return([selected])

      expect(Y2Packager::Resolvable).to receive(:find)
        .with(kind: :package, status: :selected, name: "yast2-pkg-bindings")
        .and_return([])

      expect(checker.old_packages).to eq([selected])
    end

    it "reports all old packages" do
      checker = described_class.new(old_packages)
      selected1 = Y2Packager::Resolvable.new("name" => "yast2", "version" => "4.1.69-1.2")
      selected2 = Y2Packager::Resolvable.new(
        "name" => "yast2-pkg-bindings", "version" => "4.1.1-1.2"
      )

      expect(Y2Packager::Resolvable).to receive(:find)
        .with(kind: :package, status: :selected, name: "yast2")
        .and_return([selected1])

      expect(Y2Packager::Resolvable).to receive(:find)
        .with(kind: :package, status: :selected, name: "yast2-pkg-bindings")
        .and_return([selected2])

      # both are reported
      expect(checker.old_packages.size).to eq(2)
    end
  end
end
