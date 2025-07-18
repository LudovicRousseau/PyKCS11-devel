# pylint: disable=missing-module-docstring
# pylint: disable=missing-class-docstring
# pylint: disable=missing-function-docstring

import gc
import unittest

from PyKCS11 import PyKCS11


class TestUtil(unittest.TestCase):
    def test_gc(self):
        res = []
        # we must use at least 2 sessions
        for _ in range(2):
            p11, session = self.createSession()
            res.append([p11, session])

        for p11, session in res:
            self.closeSession(session)
            del p11

            # force the call to __del__() on p11 now
            gc.collect()

    def createSession(self):
        pkcs11 = PyKCS11.PyKCS11Lib()
        pkcs11.load()

        slot = pkcs11.getSlotList(tokenPresent=True)[0]
        session = pkcs11.openSession(
            slot, PyKCS11.CKF_SERIAL_SESSION | PyKCS11.CKF_RW_SESSION
        )

        return (pkcs11, session)

    def closeSession(self, session):
        # this call generated a CKR_CRYPTOKI_NOT_INITIALIZED for the
        # second session because C_Finalize() was already called
        session.logout()
