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

require "yaml"
require "yast"

Yast.import "Directory"

module Y2Packager
  # This class represents configuration for old packages.
  class OldPackageConfig
    include Yast::Logger

    attr_reader :message, :packages

    # Reads the old package configuration files.
    def self.read
      # unfortunately we cannot use Yast::Directory.find_data_file
      # here because it needs an exact file name, it does not accept a glob,
      # use Yast.y2paths to honor the Y2DIR setting
      data_paths = Yast.y2paths.map { |p| File.join(p, "data/old_packages") }
      data_paths.select { |p| File.directory?(p) }

      log.debug "Found data directories: #{data_paths.inspect}"

      data_files = data_paths.each_with_object([]) do |p, obj|
        obj.concat(Dir[File.join(p, "*.yml")])
      end

      log.debug "Found data files: #{data_file.inspect}"

      # remove the duplicates, this ensures the Y2DIR precedence
      data_files.uniq! do |f|
        File.basename(f)
      end

      log.debug "Unique data files: #{data_file.inspect}"

      data_files.map do |f|
        config = YAML.load_file(f)
        new(config)
      end
    end

    def initialize(config = {})
      @message = config["message"] || ""
      @packages = config["packages"] || {}
    end
  end
end
