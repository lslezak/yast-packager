# ------------------------------------------------------------------------------
# Copyright (c) 2020 SUSE LLC, All Rights Reserved.
#
# This program is free software; you can redistribute it and/or modify it under
# the terms of version 2 of the GNU General Public License as published by the
# Free Software Foundation.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# ------------------------------------------------------------------------------

require "yast"
require "y2packager/resolvable"

Yast.import "Pkg"

module Y2Packager
  # This class checks whether some old package is selected to install
  class VersionCheck
    attr_reader :packages

    def initialize(packages)
      @packages = packages
    end

    def old_packages
      packages.inject([]) do |memo, (name, version)|
        selected_packages = Resolvable.find(kind: :package, status: :selected, name: name)
        # 1 = the selected is newer, the opposite is older or the same
        memo.concat(selected_packages.select do |s|
          Yast::Pkg.CompareVersions(s.version, version) != 1
        end)
      end
    end
  end
end
