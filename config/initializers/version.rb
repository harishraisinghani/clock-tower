# Read the version in from ./VERSION and set constant
VERSION = File.open((Pathname.new(__dir__) + "../../VERSION").to_path, "r").gets
