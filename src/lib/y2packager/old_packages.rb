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

Yast.import "Report"

module Y2Packager
  # This class checks whether some old packages are selected
  # and displays a warning to the user.
  class OldPackages
    include Yast::Logger
    include Yast::I18n

    attr_reader :checker

    def initialize(checker)
      textdomain "packager"
      @checker = checker
    end

    def check
      old_packages = checker.old_packages

      return if old_packages.empty?

      log.warn("Detected old packages in the package selection: #{old_packages.inspect}")

      pkg_summary = old_packages.reduce("") do |memo, pkg|
        memo + format(_("%{name}-%{version} (minimal recommended version: %{minimal_version})\n"),
          name: pkg.name, version: pkg.version, minimal_version: checker.packages[pkg.name])
      end

      message = format(_("The installer detected old package versions selected " \
        "for installation: \n\n%{list}"), list: pkg_summary)
      message += "\n\n" + _("It is recommended to install newer packages.")

      Yast::Report.Warning(message)
    end
  end
end
