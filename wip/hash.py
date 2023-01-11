#!/usr/bin/env python
from cryptography.hazmat.primitives.kdf.scrypt import Scrypt
import sys

kdf=Scrypt(sys.argv[-1].encode("utf-8"),length=40,n=2**2,r=1,p=1)
key=kdf.derive(sys.argv[-2].encode("utf-8"))

print(key)
