#! /usr/bin/env rspec

require_relative "test_helper"

require "y2packager/old_package"

describe Y2Packager::OldPackage do
  describe ".read" do
    it "reads the data files" do
      pkgs = Y2Packager::OldPackage.read([File.join(DATA_PATH, "old_packages")])
      expect(pkgs.size).to eq(4)
      pkgs.each { |p| expect(p).to be_a(Y2Packager::OldPackage) }
    end
  end

  describe "#selected_old" do
    subject { Y2Packager::OldPackage.read([File.join(DATA_PATH, "old_packages")]).first }

    context "no package is selected" do
      before do
        expect(Y2Packager::Resolvable).to receive(:find).and_return([])
      end

      it "returns nil" do
        expect(subject.selected_old).to be_nil
      end
    end

    context "an old package is selected" do
      let(:old_package) { Y2Packager::Resolvable.new("name" => "yast2", "version" => "4.1.69-1.2") }

      before do
        expect(Y2Packager::Resolvable).to receive(:find).and_return([old_package])
      end

      it "returns the old package Resolvable" do
        expect(subject.selected_old).to be(old_package)
      end
    end

    context "a new package is selected" do
      let(:new_package) { Y2Packager::Resolvable.new("name" => "yast2", "version" => "4.1.99-1.2") }

      before do
        expect(Y2Packager::Resolvable).to receive(:find).and_return([new_package])
      end

      it "returns nil" do
        expect(subject.selected_old).to be_nil
      end
    end
  end
end
