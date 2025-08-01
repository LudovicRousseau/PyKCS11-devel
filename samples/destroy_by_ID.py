#!/usr/bin/env python3

"""
#   Copyright (C) 2017 Ludovic Rousseau <ludovic.rousseau@free.fr>
#
# This file is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA.
"""


import PyKCS11

# the CKA_ID of the objects to destroy
object_id = (0x22,)
# slot PIN code
pin = "1234"


pkcs11 = PyKCS11.PyKCS11Lib()
pkcs11.load()
slot = pkcs11.getSlotList(tokenPresent=True)[0]
session = pkcs11.openSession(slot, PyKCS11.CKF_RW_SESSION)
session.login(pin)

template = [(PyKCS11.CKA_ID, object_id)]

objects = session.findObjects(template)
for obj in objects:
    print(obj)
    session.destroyObject(obj)

session.logout()
session.closeSession()
