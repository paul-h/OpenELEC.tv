################################################################################
# This file is part of OpenELEC - http://www.openelec.tv
# Copyright (C) 2015 Anton Voyl (awiouy@gmail.com)
#
# OpenELEC is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# OpenELEC is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with OpenELEC. If not, see <http://www.gnu.org/licenses/>.
################################################################################
import subprocess
import xbmcgui

networks = []
for network in subprocess.check_output(['tinc', 'network']).splitlines():
  if subprocess.call(['tinc', '-n', network, 'pid']):
    state = ' (down)'
  else:
    state = ' (up)'
  networks.append(network + state)
dialog = xbmcgui.Dialog()
dialog.select('tinc networks', networks)
del dialog
