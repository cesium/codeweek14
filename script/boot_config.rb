# Configuration file.
# Constants used through out the scripts

module BootConfig
  TEMPLATE = 'script/template.slim'
  TARGET = 'index.html'
  DEPENDS = %w(sass slim tilt bourbon)
  ROOT = 'Code-Week-DI-14'
end
