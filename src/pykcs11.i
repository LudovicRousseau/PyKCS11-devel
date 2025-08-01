//   Copyright (C) 2004 Midori (midori -- a-t -- paipai dot net)
//   Copyright (C) 2015-2025 Ludovic Rousseau (ludovic.rousseau@free.fr)
//
// This file is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA.

%module LowLevel
%{

#include <stdlib.h>
#include <memory.h>
#include <string.h>
#include "opensc/pkcs11.h"

#ifdef WIN32
#pragma warning(disable: 4800 4244)
#endif

#include <vector>
#include "pykcs11string.h"
#include "ck_attribute_smart.h"
#include "pkcs11lib.h"

using namespace std;
%}


%inline
%{
    using namespace std;
%}

%include cdata.i
%include cpointer.i
%include typemaps.i
%include std_vector.i

%template(ckulonglist) vector<unsigned long>;
%template(ckbytelist) vector<unsigned char>;
%template(ckattrlist) vector<CK_ATTRIBUTE_SMART>;

%pointer_class(unsigned long, CK_SESSION_HANDLE);
%pointer_class(unsigned long, CK_OBJECT_HANDLE);

#if SWIGPYTHON
%typemap(out) PyKCS11String {
  #ifdef Py_USING_UNICODE
   $result = PyBytes_FromStringAndSize((const char*)($1.m_str.c_str()),(int)($1.m_str.size()));
  #else
   $result = PyUnicode_Decode((const char*)($1.m_str.c_str()),(int)($1.m_str.size()), "utf-8", "ignore");
  #endif
}

%typemap(out) CK_RV {
   $result = PyInt_FromLong((long)$1);
}

#else
#endif


typedef struct CK_VERSION {
%immutable;
  unsigned char       major;
  unsigned char       minor;
%mutable;
} CK_VERSION;


typedef struct CK_INFO {
%immutable;
  CK_VERSION    cryptokiVersion;
  unsigned char   manufacturerID[32];
  unsigned long      flags;
  unsigned char   libraryDescription[32];
  CK_VERSION    libraryVersion;
%mutable;
} CK_INFO;

%extend CK_INFO
{
	PyKCS11String GetManufacturerID()
	{
		return PyKCS11String(self->manufacturerID, sizeof(self->manufacturerID));
	}
    PyKCS11String GetLibraryDescription()
	{
		return PyKCS11String(self->libraryDescription, sizeof(self->libraryDescription));
	}
    PyKCS11String GetLibraryVersion()
	{
		char szVal[10];
		snprintf(szVal, sizeof szVal, "%d.%d", self->libraryVersion.major, self->libraryVersion.minor);
		return PyKCS11String(szVal);
	}
};

typedef struct CK_SLOT_INFO {
%immutable;
  //unsigned char   slotDescription[64];
  //unsigned char   manufacturerID[32];
  unsigned long      flags;
  CK_VERSION    hardwareVersion;
  CK_VERSION    firmwareVersion;
%mutable;
} CK_SLOT_INFO;

%extend CK_SLOT_INFO
{
	PyKCS11String GetManufacturerID()
	{
		return PyKCS11String(self->manufacturerID, sizeof(self->manufacturerID));
	}
    PyKCS11String GetSlotDescription()
	{
		return PyKCS11String(self->slotDescription, sizeof(self->slotDescription));
	}
    PyKCS11String GetHardwareVersion()
	{
		char szVal[10];
		snprintf(szVal, sizeof szVal, "%d.%02d", self->hardwareVersion.major, self->hardwareVersion.minor);
		return PyKCS11String(szVal);
	}
    PyKCS11String GetFirmwareVersion()
	{
		char szVal[10];
		snprintf(szVal, sizeof szVal, "%d.%02d", self->firmwareVersion.major, self->firmwareVersion.minor);
		return PyKCS11String(szVal);
	}
};

typedef struct CK_TOKEN_INFO {
%immutable;
  //unsigned char   label[32];
  //unsigned char   manufacturerID[32];
  //unsigned char   model[16];
  //unsigned char       serialNumber[16];
  unsigned long      flags;
  unsigned long      ulMaxSessionCount;
  unsigned long      ulSessionCount;
  unsigned long      ulMaxRwSessionCount;
  unsigned long      ulRwSessionCount;
  unsigned long      ulMaxPinLen;
  unsigned long      ulMinPinLen;
  unsigned long      ulTotalPublicMemory;
  unsigned long      ulFreePublicMemory;
  unsigned long      ulTotalPrivateMemory;
  unsigned long      ulFreePrivateMemory;
  CK_VERSION    hardwareVersion;
  CK_VERSION    firmwareVersion;
  //unsigned char       utcTime[16];
%mutable;
} CK_TOKEN_INFO;

%extend CK_TOKEN_INFO
{
	PyKCS11String GetLabel()
	{
		return PyKCS11String(self->label, sizeof(self->label));
	}
    PyKCS11String GetManufacturerID()
	{
		return PyKCS11String(self->manufacturerID, sizeof(self->manufacturerID));
	}
    PyKCS11String GetModel()
	{
		return PyKCS11String(self->model, sizeof(self->model));
	}
    PyKCS11String GetSerialNumber()
	{
		return PyKCS11String(self->serialNumber, sizeof(self->serialNumber));
	}
    PyKCS11String GetFirmwareVersion()
	{
		char szVal[10];
		snprintf(szVal, sizeof szVal, "%d.%02d", self->firmwareVersion.major, self->firmwareVersion.minor);
		return PyKCS11String(szVal);
	}
    PyKCS11String GetUtcTime()
	{
		return PyKCS11String(self->utcTime, sizeof(self->utcTime));
	}
};

typedef struct CK_SESSION_INFO {
%immutable;
  unsigned long    slotID;
  unsigned long      state;
  unsigned long      flags;
  unsigned long      ulDeviceError;
%mutable;
} CK_SESSION_INFO;


typedef struct CK_DATE{
 //unsigned char       year[4];
 //unsigned char       month[2];
 // unsigned char       day[2];
} CK_DATE;

%extend CK_DATE
{
	PyKCS11String GetYear()
	{
		char szVal[10];
		memcpy(szVal, self->year, sizeof(self->year) );
		return PyKCS11String(szVal);
	}
    PyKCS11String GetMonth()
	{
		char szVal[10];
		memcpy(szVal, self->month, sizeof(self->month) );
		return PyKCS11String(szVal);
	}
    PyKCS11String GetDay()
	{
		char szVal[10];
		memcpy(szVal, self->day, sizeof(self->day) );
		return PyKCS11String(szVal);
	}
};

%typemap(in) void* {
    vector<unsigned char> *vect;
    // If the value being set is of ckbytelist type:
    if (SWIG_IsOK(SWIG_ConvertPtr($input, (void **)&vect, $descriptor(vector<unsigned char> *), 0)))
    {
        // Get the data from the vector
        // Only set value if not null
        if (vect)
            arg2 = vect->data();
        else
            arg2 = NULL;
    }
    else
    {
        // If the value isn't a ckbytelist, then it must be a pointer to a mechanism parameter
        int res2 = -1;
        do { // Add mechanism parameters here
            res2 = SWIG_ConvertPtr($input, &arg2, $descriptor(CK_RSA_PKCS_OAEP_PARAMS*), 0);
            if( SWIG_IsOK( res2 ) )
                break;

            res2 = SWIG_ConvertPtr($input, &arg2, $descriptor(CK_RSA_PKCS_PSS_PARAMS*), 0);
            if( SWIG_IsOK( res2 ) )
                break;

            res2 = SWIG_ConvertPtr($input, &arg2, $descriptor(CK_GCM_PARAMS*), 0);
            if( SWIG_IsOK( res2 ) )
                break;

            res2 = SWIG_ConvertPtr($input, &arg2, $descriptor(CK_ECDH1_DERIVE_PARAMS*), 0);
            if( SWIG_IsOK( res2 ) )
                break;

            res2 = SWIG_ConvertPtr($input, &arg2, $descriptor(CK_AES_CTR_PARAMS*), 0);
            if( SWIG_IsOK( res2 ) )
                break;

            res2 = SWIG_ConvertPtr($input, &arg2, $descriptor(CK_KEY_DERIVATION_STRING_DATA*), 0);
            if( SWIG_IsOK( res2 ) )
                break;

            res2 = SWIG_ConvertPtr($input, &arg2, $descriptor(CK_EXTRACT_PARAMS*), 0);
            if( SWIG_IsOK( res2 ) )
                break;

            res2 = SWIG_ConvertPtr($input, &arg2, $descriptor(CK_EDDSA_PARAMS*), 0);
            if( SWIG_IsOK( res2 ) )
                break;

            res2 = SWIG_ConvertPtr($input, &arg2, $descriptor(CK_OBJECT_HANDLE*), 0);
            if( SWIG_IsOK( res2 ) )
                break;
        } while(0);

        if (!SWIG_IsOK(res2)) {
            SWIG_exception_fail(SWIG_ArgError(res2), "unsupported CK_MECHANISM Parameter type.");
        }
    }
}

// typemap for CK_BYTE_PTR (unsigned char*) mechanism parameters
%typemap(in) unsigned char* {
    vector<unsigned char> *vect;
    // If the value being set is of ckbytelist type:
    int res = SWIG_ConvertPtr($input, (void **)&vect, $descriptor(vector<unsigned char> *), 0);
    if (SWIG_IsOK(res))
    {
        // Get the data from the vector
        // Only set value if not null
        if (vect)
            arg2 = vect->data();
        else
            arg2 = NULL;
    }
    else
    {
        // If a mechanism parameter has a 'CK_BYTE_PTR' as a member, it must be represented as a ckbytelist
        SWIG_exception_fail(SWIG_ArgError(res), "CK_BYTE_PTR members of CK_* mechanism params must be represented as ckbytelist type");
    }
}

// typemap for CK_BYTE static arrays
%typemap(in) unsigned char[ANY](unsigned char out[$1_dim0]) {
    vector<unsigned char> *vect;
    // Expect a value of ckbytelist type:
    int res = SWIG_ConvertPtr($input, (void **)&vect, $descriptor(vector<unsigned char> *), 0);
    if (SWIG_IsOK(res))
    {
        if (vect->size() != $1_dim0)
        {
            SWIG_exception_fail(SWIG_ValueError, "Expected a ckbytelist with $1_dim0 elements");
        }

        for (size_t i = 0; i < $1_dim0; i++)
        {
            out[i] = (*vect)[i];
        }
    }
    else
    {
        // If a mechanism parameter has a CK_BYTE array as a member, it must be represented as a ckbytelist
        SWIG_exception_fail(SWIG_ArgError(res), "CK_BYTE arrays of CK_* mechanism params must be represented as ckbytelist type");
    }
    $1 = &out[0];
}

typedef struct CK_MECHANISM {
  unsigned long mechanism;
  void*       pParameter;
  unsigned long          ulParameterLen;
} CK_MECHANISM;

%extend CK_MECHANISM
{
	CK_MECHANISM()
	{
		CK_MECHANISM* m = new CK_MECHANISM();
		m->ulParameterLen = m->mechanism = 0; m->pParameter = NULL;
		return m;
	}
};

// For all complex mechanism parameters which has 'void *' as a member, it must a ckbytelist
%typemap(in) void* {
    vector<unsigned char> *vect;
    int res = SWIG_ConvertPtr($input, (void **)&vect, $descriptor(vector<unsigned char> *), 0);
    if (SWIG_IsOK(res))
    {
        // Get the data from the vector
        // Only set value if not null
        if (vect)
            arg2 = vect->data();
        else
            arg2 = NULL;
    }
    else
    {
        SWIG_exception_fail(SWIG_ArgError(res), "void * members of CK_* mechanism params must be represented as ckbytelist type");
    }
}

%constant int CK_OBJECT_HANDLE_LENGTH = sizeof(CK_OBJECT_HANDLE);

typedef struct CK_GCM_PARAMS {
    unsigned char * pIv;
    unsigned long ulIvLen;
    unsigned long ulIvBits;
    unsigned char * pAAD;
    unsigned long ulAADLen;
    unsigned long ulTagBits;
} CK_GCM_PARAMS;

%extend CK_GCM_PARAMS
{
    CK_GCM_PARAMS()
    {
        CK_GCM_PARAMS *p = new CK_GCM_PARAMS();
        p->pIv = p->pAAD = NULL;
        p->ulIvLen = p->ulIvBits = p->ulAADLen = p->ulTagBits = 0;
        return p;
    }
};

%constant int CK_GCM_PARAMS_LENGTH = sizeof(CK_GCM_PARAMS);

typedef struct CK_AES_CTR_PARAMS {
    unsigned long ulCounterBits;
    unsigned char cb[16];
} CK_AES_CTR_PARAMS;

%extend CK_AES_CTR_PARAMS
{
    CK_AES_CTR_PARAMS()
    {
        CK_AES_CTR_PARAMS *p = new CK_AES_CTR_PARAMS();
        p->ulCounterBits = 128;
        memset(p->cb, 0, sizeof(p->cb));
        return p;
    }
};

%constant int CK_AES_CTR_PARAMS_LENGTH = sizeof(CK_AES_CTR_PARAMS);

typedef struct CK_RSA_PKCS_OAEP_PARAMS {
  unsigned long hashAlg;
  unsigned long mgf;
  unsigned long source;
  void* pSourceData;
  unsigned long ulSourceDataLen;
} CK_RSA_PKCS_OAEP_PARAMS;

%extend CK_RSA_PKCS_OAEP_PARAMS
{
	CK_RSA_PKCS_OAEP_PARAMS()
	{
		CK_RSA_PKCS_OAEP_PARAMS* p = new CK_RSA_PKCS_OAEP_PARAMS();
		p->hashAlg = 0;
		p->mgf = 0;
		p->source = 0;
		p->pSourceData = NULL;
		p->ulSourceDataLen = 0;
    return p;
	}
};

%constant int CK_RSA_PKCS_OAEP_PARAMS_LENGTH = sizeof(CK_RSA_PKCS_OAEP_PARAMS);

typedef struct CK_RSA_PKCS_PSS_PARAMS {
    unsigned long hashAlg;
    unsigned long mgf;
    unsigned long sLen;
} CK_RSA_PKCS_PSS_PARAMS;

%extend CK_RSA_PKCS_PSS_PARAMS
{
    CK_RSA_PKCS_PSS_PARAMS()
    {
        CK_RSA_PKCS_PSS_PARAMS *p = new CK_RSA_PKCS_PSS_PARAMS();
        p->hashAlg = 0;
        p->mgf = 0;
        p->sLen = 0;
        return p;
    }
};

%constant int CK_RSA_PKCS_PSS_PARAMS_LENGTH = sizeof(CK_RSA_PKCS_PSS_PARAMS);

typedef struct CK_ECDH1_DERIVE_PARAMS {
    unsigned long kdf;
    unsigned long ulSharedDataLen;
    unsigned char* pSharedData;
    unsigned long ulPublicDataLen;
    unsigned char* pPublicData;
} CK_ECDH1_DERIVE_PARAMS;

%extend CK_ECDH1_DERIVE_PARAMS
{
	CK_ECDH1_DERIVE_PARAMS()
	{
		CK_ECDH1_DERIVE_PARAMS *p = new CK_ECDH1_DERIVE_PARAMS();
		p->kdf = CKD_NULL;
		p->pSharedData = NULL;
		p->ulSharedDataLen = 0;
		p->pPublicData = NULL;
		p->ulPublicDataLen = 0;

		return p;
	}
};

%constant int CK_ECDH1_DERIVE_PARAMS_LENGTH = sizeof(CK_ECDH1_DERIVE_PARAMS);

typedef struct CK_KEY_DERIVATION_STRING_DATA {
    unsigned char * pData;
    unsigned long ulLen;
} CK_KEY_DERIVATION_STRING_DATA;

%extend CK_KEY_DERIVATION_STRING_DATA
{
    CK_KEY_DERIVATION_STRING_DATA()
    {
        CK_KEY_DERIVATION_STRING_DATA *p = new CK_KEY_DERIVATION_STRING_DATA();
        p->ulLen = 0;
        p->pData = NULL;
        return p;
    }
};

%constant int CK_KEY_DERIVATION_STRING_DATA_LENGTH = sizeof(CK_KEY_DERIVATION_STRING_DATA);

%pointer_class(unsigned long, CK_EXTRACT_PARAMS);

%constant int CK_EXTRACT_PARAMS_LENGTH = sizeof(CK_EXTRACT_PARAMS);

typedef struct CK_EDDSA_PARAMS {
    unsigned char phFlag;
    unsigned long ulContextDataLen;
    unsigned char * pContextData;
} CK_EDDSA_PARAMS;

%extend CK_EDDSA_PARAMS
{
    CK_EDDSA_PARAMS()
    {
        CK_EDDSA_PARAMS *p = new CK_EDDSA_PARAMS();
        p->phFlag = 0;
        p->ulContextDataLen = 0;
        p->pContextData = NULL;
        return p;
    }
};

%constant int CK_EDDSA_PARAMS_LENGTH = sizeof(CK_EDDSA_PARAMS);

typedef struct CK_MECHANISM_INFO {
%immutable;
    unsigned long    ulMinKeySize;
    unsigned long    ulMaxKeySize;
    unsigned long    flags;
%mutable;
} CK_MECHANISM_INFO;

typedef unsigned long CK_RV;

#define FALSE 0
#define TRUE !(FALSE)

#define CK_TRUE 1
#define CK_FALSE 0
#define CK_UNAVAILABLE_INFORMATION (~0UL)
#define CK_EFFECTIVELY_INFINITE    0
#define CK_INVALID_HANDLE 0

#define CKN_SURRENDER       0
#define CKN_OTP_CHANGED     1

#define CKF_TOKEN_PRESENT     0x00000001
#define CKF_REMOVABLE_DEVICE  0x00000002
#define CKF_HW_SLOT           0x00000004
#define CKF_RNG                     0x00000001
#define CKF_WRITE_PROTECTED         0x00000002
#define CKF_LOGIN_REQUIRED          0x00000004
#define CKF_USER_PIN_INITIALIZED    0x00000008
#define CKF_RESTORE_KEY_NOT_NEEDED  0x00000020
#define CKF_CLOCK_ON_TOKEN          0x00000040
#define CKF_PROTECTED_AUTHENTICATION_PATH 0x00000100
#define CKF_DUAL_CRYPTO_OPERATIONS  0x00000200
#define CKF_TOKEN_INITIALIZED       0x00000400
#define CKF_SECONDARY_AUTHENTICATION  0x00000800
#define CKF_USER_PIN_COUNT_LOW       0x00010000
#define CKF_USER_PIN_FINAL_TRY       0x00020000
#define CKF_USER_PIN_LOCKED          0x00040000
#define CKF_USER_PIN_TO_BE_CHANGED   0x00080000
#define CKF_SO_PIN_COUNT_LOW         0x00100000
#define CKF_SO_PIN_FINAL_TRY         0x00200000
#define CKF_SO_PIN_LOCKED            0x00400000
#define CKF_SO_PIN_TO_BE_CHANGED     0x00800000
#define CKF_ERROR_STATE              0x01000000
#define CKF_ARRAY_ATTRIBUTE          (1 << 30)

#define CKU_SO                0
#define CKU_USER              1
#define CKU_CONTEXT_SPECIFIC  2

#define CKS_RO_PUBLIC_SESSION  0
#define CKS_RO_USER_FUNCTIONS  1
#define CKS_RW_PUBLIC_SESSION  2
#define CKS_RW_USER_FUNCTIONS  3
#define CKS_RW_SO_FUNCTIONS    4

#define CKF_RW_SESSION          0x00000002
#define CKF_SERIAL_SESSION      0x00000004

#define CKO_DATA              0x00000000
#define CKO_CERTIFICATE       0x00000001
#define CKO_PUBLIC_KEY        0x00000002
#define CKO_PRIVATE_KEY       0x00000003
#define CKO_SECRET_KEY        0x00000004
#define CKO_HW_FEATURE        0x00000005
#define CKO_DOMAIN_PARAMETERS 0x00000006
#define CKO_MECHANISM         0x00000007
#define CKO_OTP_KEY           0x00000008
#define CKO_PROFILE           0x00000009
#define CKO_VENDOR_DEFINED    0x80000000UL

#define CKH_MONOTONIC_COUNTER  0x00000001
#define CKH_CLOCK           0x00000002
#define CKH_USER_INTERFACE  0x00000003
#define CKH_VENDOR_DEFINED  0x80000000UL

#define CKK_RSA             0x00000000
#define CKK_DSA             0x00000001
#define CKK_DH              0x00000002
#define CKK_ECDSA           0x00000003
#define CKK_EC              0x00000003
#define CKK_X9_42_DH        0x00000004
#define CKK_KEA             0x00000005
#define CKK_GENERIC_SECRET  0x00000010
#define CKK_RC2             0x00000011
#define CKK_RC4             0x00000012
#define CKK_DES             0x00000013
#define CKK_DES2            0x00000014
#define CKK_DES3            0x00000015
#define CKK_CAST            0x00000016
#define CKK_CAST3           0x00000017
#define CKK_CAST5           0x00000018
#define CKK_CAST128         0x00000018
#define CKK_RC5             0x00000019
#define CKK_IDEA            0x0000001A
#define CKK_SKIPJACK        0x0000001B
#define CKK_BATON           0x0000001C
#define CKK_JUNIPER         0x0000001D
#define CKK_CDMF            0x0000001E
#define CKK_AES             0x0000001F
#define CKK_BLOWFISH        0x00000020
#define CKK_TWOFISH         0x00000021
#define CKK_SECURID         0x00000022
#define CKK_HOTP            0x00000023
#define CKK_ACTI            0x00000024
#define CKK_CAMELLIA        0x00000025
#define CKK_ARIA            0x00000026
#define CKK_MD5_HMAC        0x00000027
#define CKK_SHA_1_HMAC      0x00000028
#define CKK_RIPEMD128_HMAC  0x00000029
#define CKK_RIPEMD160_HMAC  0x0000002A
#define CKK_SHA256_HMAC     0x0000002B
#define CKK_SHA384_HMAC     0x0000002C
#define CKK_SHA512_HMAC     0x0000002D
#define CKK_SHA224_HMAC     0x0000002E
#define CKK_GOSTR3410       0x00000030
#define CKK_GOSTR3411       0x00000031
#define CKK_GOST28147       0x00000032
#define CKK_CHACHA20        0x00000033
#define CKK_POLY1305        0x00000034
#define CKK_AES_XTS         0x00000035
#define CKK_SHA3_224_HMAC   0x00000036
#define CKK_SHA3_256_HMAC   0x00000037
#define CKK_SHA3_384_HMAC   0x00000038
#define CKK_SHA3_512_HMAC   0x00000039
#define CKK_BLAKE2B_160_HMAC 0x0000003a
#define CKK_BLAKE2B_256_HMAC 0x0000003b
#define CKK_BLAKE2B_384_HMAC 0x0000003c
#define CKK_BLAKE2B_512_HMAC 0x0000003d
#define CKK_SALSA20         0x0000003e
#define CKK_X2RATCHET       0x0000003f
#define CKK_EC_EDWARDS      0x00000040
#define CKK_EC_MONTGOMERY   0x00000041
#define CKK_HKDF            0x00000042
#define CKK_VENDOR_DEFINED  0x80000000UL

#define CKC_X_509           0x00000000
#define CKC_X_509_ATTR_CERT 0x00000001
#define CKC_WTLS            0x00000002
#define CKC_VENDOR_DEFINED  0x80000000UL

#define CKA_CLASS              0x00000000
#define CKA_TOKEN              0x00000001
#define CKA_PRIVATE            0x00000002
#define CKA_LABEL              0x00000003
#define CKA_UNIQUE_ID          0x00000004
#define CKA_APPLICATION        0x00000010
#define CKA_VALUE              0x00000011
#define CKA_OBJECT_ID          0x00000012
#define CKA_CERTIFICATE_TYPE   0x00000080
#define CKA_ISSUER             0x00000081
#define CKA_SERIAL_NUMBER      0x00000082
#define CKA_AC_ISSUER          0x00000083
#define CKA_OWNER              0x00000084
#define CKA_ATTR_TYPES         0x00000085
#define CKA_TRUSTED            0x00000086
#define CKA_CERTIFICATE_CATEGORY        0x00000087
#define CKA_JAVA_MIDP_SECURITY_DOMAIN   0x00000088
#define CKA_URL                         0x00000089
#define CKA_HASH_OF_SUBJECT_PUBLIC_KEY  0x0000008A
#define CKA_HASH_OF_ISSUER_PUBLIC_KEY   0x0000008B
#define CKA_NAME_HASH_ALGORITHM         0x0000008C
#define CKA_CHECK_VALUE                 0x00000090
#define CKA_KEY_TYPE           0x00000100
#define CKA_SUBJECT            0x00000101
#define CKA_ID                 0x00000102
#define CKA_SENSITIVE          0x00000103
#define CKA_ENCRYPT            0x00000104
#define CKA_DECRYPT            0x00000105
#define CKA_WRAP               0x00000106
#define CKA_UNWRAP             0x00000107
#define CKA_SIGN               0x00000108
#define CKA_SIGN_RECOVER       0x00000109
#define CKA_VERIFY             0x0000010A
#define CKA_VERIFY_RECOVER     0x0000010B
#define CKA_DERIVE             0x0000010C
#define CKA_START_DATE         0x00000110
#define CKA_END_DATE           0x00000111
#define CKA_MODULUS            0x00000120
#define CKA_MODULUS_BITS       0x00000121
#define CKA_PUBLIC_EXPONENT    0x00000122
#define CKA_PRIVATE_EXPONENT   0x00000123
#define CKA_PRIME_1            0x00000124
#define CKA_PRIME_2            0x00000125
#define CKA_EXPONENT_1         0x00000126
#define CKA_EXPONENT_2         0x00000127
#define CKA_COEFFICIENT        0x00000128
#define CKA_PUBLIC_KEY_INFO    0x00000129
#define CKA_PRIME              0x00000130
#define CKA_SUBPRIME           0x00000131
#define CKA_BASE               0x00000132
#define CKA_PRIME_BITS         0x00000133
#define CKA_SUBPRIME_BITS      0x00000134
#define CKA_SUB_PRIME_BITS     CKA_SUBPRIME_BITS
#define CKA_VALUE_BITS         0x00000160
#define CKA_VALUE_LEN          0x00000161
#define CKA_EXTRACTABLE        0x00000162
#define CKA_LOCAL              0x00000163
#define CKA_NEVER_EXTRACTABLE  0x00000164
#define CKA_ALWAYS_SENSITIVE   0x00000165
#define CKA_KEY_GEN_MECHANISM  0x00000166
#define CKA_MODIFIABLE         0x00000170
#define CKA_COPYABLE           0x00000171
#define CKA_DESTROYABLE        0x00000172
#define CKA_ECDSA_PARAMS       0x00000180
#define CKA_EC_PARAMS          0x00000180
#define CKA_EC_POINT           0x00000181
#define CKA_SECONDARY_AUTH     0x00000200
#define CKA_AUTH_PIN_FLAGS     0x00000201
#define CKA_ALWAYS_AUTHENTICATE  0x00000202
#define CKA_WRAP_WITH_TRUSTED    0x00000210
#define CKA_WRAP_TEMPLATE        (CKF_ARRAY_ATTRIBUTE|0x00000211)
#define CKA_UNWRAP_TEMPLATE      (CKF_ARRAY_ATTRIBUTE|0x00000212)
#define CKA_DERIVE_TEMPLATE      (CKF_ARRAY_ATTRIBUTE|0x00000213)
#define CKA_OTP_FORMAT                0x00000220
#define CKA_OTP_LENGTH                0x00000221
#define CKA_OTP_TIME_INTERVAL         0x00000222
#define CKA_OTP_USER_FRIENDLY_MODE    0x00000223
#define CKA_OTP_CHALLENGE_REQUIREMENT 0x00000224
#define CKA_OTP_TIME_REQUIREMENT      0x00000225
#define CKA_OTP_COUNTER_REQUIREMENT   0x00000226
#define CKA_OTP_PIN_REQUIREMENT       0x00000227
#define CKA_OTP_COUNTER               0x0000022E
#define CKA_OTP_TIME                  0x0000022F
#define CKA_OTP_USER_IDENTIFIER       0x0000022A
#define CKA_OTP_SERVICE_IDENTIFIER    0x0000022B
#define CKA_OTP_SERVICE_LOGO          0x0000022C
#define CKA_OTP_SERVICE_LOGO_TYPE     0x0000022D
#define CKA_GOSTR3410_PARAMS          0x00000250
#define CKA_GOSTR3411_PARAMS          0x00000251
#define CKA_GOST28147_PARAMS          0x00000252
#define CKA_HW_FEATURE_TYPE    0x00000300
#define CKA_RESET_ON_INIT      0x00000301
#define CKA_HAS_RESET          0x00000302
#define CKA_PIXEL_X                     0x00000400
#define CKA_PIXEL_Y                     0x00000401
#define CKA_RESOLUTION                  0x00000402
#define CKA_CHAR_ROWS                   0x00000403
#define CKA_CHAR_COLUMNS                0x00000404
#define CKA_COLOR                       0x00000405
#define CKA_BITS_PER_PIXEL              0x00000406
#define CKA_CHAR_SETS                   0x00000480
#define CKA_ENCODING_METHODS            0x00000481
#define CKA_MIME_TYPES                  0x00000482
#define CKA_MECHANISM_TYPE              0x00000500
#define CKA_REQUIRED_CMS_ATTRIBUTES     0x00000501
#define CKA_DEFAULT_CMS_ATTRIBUTES      0x00000502
#define CKA_SUPPORTED_CMS_ATTRIBUTES    0x00000503
#define CKA_ALLOWED_MECHANISMS          (CKF_ARRAY_ATTRIBUTE|0x00000600)
#define CKA_PROFILE_ID                  0x00000601
#define CKA_VENDOR_DEFINED     0x80000000UL

#define CKM_RSA_PKCS_KEY_PAIR_GEN      0x00000000
#define CKM_RSA_PKCS                   0x00000001
#define CKM_RSA_9796                   0x00000002
#define CKM_RSA_X_509                  0x00000003
#define CKM_MD2_RSA_PKCS               0x00000004
#define CKM_MD5_RSA_PKCS               0x00000005
#define CKM_SHA1_RSA_PKCS              0x00000006
#define CKM_RIPEMD128_RSA_PKCS         0x00000007
#define CKM_RIPEMD160_RSA_PKCS         0x00000008
#define CKM_RSA_PKCS_OAEP              0x00000009
#define CKM_RSA_X9_31_KEY_PAIR_GEN     0x0000000A
#define CKM_RSA_X9_31                  0x0000000B
#define CKM_SHA1_RSA_X9_31             0x0000000C
#define CKM_RSA_PKCS_PSS               0x0000000D
#define CKM_SHA1_RSA_PKCS_PSS          0x0000000E
#define CKM_DSA_KEY_PAIR_GEN           0x00000010
#define CKM_DSA                        0x00000011
#define CKM_DSA_SHA1                   0x00000012
#define CKM_DSA_SHA224                 0x00000013
#define CKM_DSA_SHA256                 0x00000014
#define CKM_DSA_SHA384                 0x00000015
#define CKM_DSA_SHA512                 0x00000016
#define CKM_DSA_SHA3_224               0x00000018
#define CKM_DSA_SHA3_256               0x00000019
#define CKM_DSA_SHA3_384               0x0000001A
#define CKM_DSA_SHA3_512               0x0000001B
#define CKM_DH_PKCS_KEY_PAIR_GEN       0x00000020
#define CKM_DH_PKCS_DERIVE             0x00000021
#define CKM_X9_42_DH_KEY_PAIR_GEN      0x00000030
#define CKM_X9_42_DH_DERIVE            0x00000031
#define CKM_X9_42_DH_HYBRID_DERIVE     0x00000032
#define CKM_X9_42_MQV_DERIVE           0x00000033
#define CKM_SHA256_RSA_PKCS            0x00000040
#define CKM_SHA384_RSA_PKCS            0x00000041
#define CKM_SHA512_RSA_PKCS            0x00000042
#define CKM_SHA256_RSA_PKCS_PSS        0x00000043
#define CKM_SHA384_RSA_PKCS_PSS        0x00000044
#define CKM_SHA512_RSA_PKCS_PSS        0x00000045
#define CKM_SHA224_RSA_PKCS            0x00000046
#define CKM_SHA224_RSA_PKCS_PSS        0x00000047
#define CKM_SHA512_224                 0x00000048
#define CKM_SHA512_224_HMAC            0x00000049
#define CKM_SHA512_224_HMAC_GENERAL    0x0000004A
#define CKM_SHA512_224_KEY_DERIVATION  0x0000004B
#define CKM_SHA512_256                 0x0000004C
#define CKM_SHA512_256_HMAC            0x0000004D
#define CKM_SHA512_256_HMAC_GENERAL    0x0000004E
#define CKM_SHA512_256_KEY_DERIVATION  0x0000004F
#define CKM_SHA512_T                   0x00000050
#define CKM_SHA512_T_HMAC              0x00000051
#define CKM_SHA512_T_HMAC_GENERAL      0x00000052
#define CKM_SHA512_T_KEY_DERIVATION    0x00000053
#define CKM_SHA3_256_RSA_PKCS          0x00000060
#define CKM_SHA3_384_RSA_PKCS          0x00000061
#define CKM_SHA3_512_RSA_PKCS          0x00000062
#define CKM_SHA3_256_RSA_PKCS_PSS      0x00000063
#define CKM_SHA3_384_RSA_PKCS_PSS      0x00000064
#define CKM_SHA3_512_RSA_PKCS_PSS      0x00000065
#define CKM_SHA3_224_RSA_PKCS          0x00000066
#define CKM_SHA3_224_RSA_PKCS_PSS      0x00000067
#define CKM_RC2_KEY_GEN                0x00000100
#define CKM_RC2_ECB                    0x00000101
#define CKM_RC2_CBC                    0x00000102
#define CKM_RC2_MAC                    0x00000103
#define CKM_RC2_MAC_GENERAL            0x00000104
#define CKM_RC2_CBC_PAD                0x00000105
#define CKM_RC4_KEY_GEN                0x00000110
#define CKM_RC4                        0x00000111
#define CKM_DES_KEY_GEN                0x00000120
#define CKM_DES_ECB                    0x00000121
#define CKM_DES_CBC                    0x00000122
#define CKM_DES_MAC                    0x00000123
#define CKM_DES_MAC_GENERAL            0x00000124
#define CKM_DES_CBC_PAD                0x00000125
#define CKM_DES2_KEY_GEN               0x00000130
#define CKM_DES3_KEY_GEN               0x00000131
#define CKM_DES3_ECB                   0x00000132
#define CKM_DES3_CBC                   0x00000133
#define CKM_DES3_MAC                   0x00000134
#define CKM_DES3_MAC_GENERAL           0x00000135
#define CKM_DES3_CBC_PAD               0x00000136
#define CKM_DES3_CMAC_GENERAL          0x00000137
#define CKM_DES3_CMAC                  0x00000138
#define CKM_CDMF_KEY_GEN               0x00000140
#define CKM_CDMF_ECB                   0x00000141
#define CKM_CDMF_CBC                   0x00000142
#define CKM_CDMF_MAC                   0x00000143
#define CKM_CDMF_MAC_GENERAL           0x00000144
#define CKM_CDMF_CBC_PAD               0x00000145
#define CKM_DES_OFB64                  0x00000150
#define CKM_DES_OFB8                   0x00000151
#define CKM_DES_CFB64                  0x00000152
#define CKM_DES_CFB8                   0x00000153
#define CKM_MD2                        0x00000200
#define CKM_MD2_HMAC                   0x00000201
#define CKM_MD2_HMAC_GENERAL           0x00000202
#define CKM_MD5                        0x00000210
#define CKM_MD5_HMAC                   0x00000211
#define CKM_MD5_HMAC_GENERAL           0x00000212
#define CKM_SHA_1                      0x00000220
#define CKM_SHA_1_HMAC                 0x00000221
#define CKM_SHA_1_HMAC_GENERAL         0x00000222
#define CKM_RIPEMD128                  0x00000230
#define CKM_RIPEMD128_HMAC             0x00000231
#define CKM_RIPEMD128_HMAC_GENERAL     0x00000232
#define CKM_RIPEMD160                  0x00000240
#define CKM_RIPEMD160_HMAC             0x00000241
#define CKM_RIPEMD160_HMAC_GENERAL     0x00000242
#define CKM_SHA256                     0x00000250
#define CKM_SHA256_HMAC                0x00000251
#define CKM_SHA256_HMAC_GENERAL        0x00000252
#define CKM_SHA224                     0x00000255
#define CKM_SHA224_HMAC                0x00000256
#define CKM_SHA224_HMAC_GENERAL        0x00000257
#define CKM_SHA384                     0x00000260
#define CKM_SHA384_HMAC                0x00000261
#define CKM_SHA384_HMAC_GENERAL        0x00000262
#define CKM_SHA512                     0x00000270
#define CKM_SHA512_HMAC                0x00000271
#define CKM_SHA512_HMAC_GENERAL        0x00000272
#define CKM_SECURID_KEY_GEN            0x00000280
#define CKM_SECURID                    0x00000282
#define CKM_HOTP_KEY_GEN               0x00000290
#define CKM_HOTP                       0x00000291
#define CKM_ACTI                       0x000002A0
#define CKM_ACTI_KEY_GEN               0x000002A1
#define CKM_SHA3_256                   0x000002B0
#define CKM_SHA3_256_HMAC              0x000002B1
#define CKM_SHA3_256_HMAC_GENERAL      0x000002B2
#define CKM_SHA3_256_KEY_GEN           0x000002B3
#define CKM_SHA3_224                   0x000002B5
#define CKM_SHA3_224_HMAC              0x000002B6
#define CKM_SHA3_224_HMAC_GENERAL      0x000002B7
#define CKM_SHA3_224_KEY_GEN           0x000002B8
#define CKM_SHA3_384                   0x000002C0
#define CKM_SHA3_384_HMAC              0x000002C1
#define CKM_SHA3_384_HMAC_GENERAL      0x000002C2
#define CKM_SHA3_384_KEY_GEN           0x000002C3
#define CKM_SHA3_512                   0x000002D0
#define CKM_SHA3_512_HMAC              0x000002D1
#define CKM_SHA3_512_HMAC_GENERAL      0x000002D2
#define CKM_SHA3_512_KEY_GEN           0x000002D3
#define CKM_CAST_KEY_GEN               0x00000300
#define CKM_CAST_ECB                   0x00000301
#define CKM_CAST_CBC                   0x00000302
#define CKM_CAST_MAC                   0x00000303
#define CKM_CAST_MAC_GENERAL           0x00000304
#define CKM_CAST_CBC_PAD               0x00000305
#define CKM_CAST3_KEY_GEN              0x00000310
#define CKM_CAST3_ECB                  0x00000311
#define CKM_CAST3_CBC                  0x00000312
#define CKM_CAST3_MAC                  0x00000313
#define CKM_CAST3_MAC_GENERAL          0x00000314
#define CKM_CAST3_CBC_PAD              0x00000315
#define CKM_CAST5_KEY_GEN              0x00000320
#define CKM_CAST128_KEY_GEN            0x00000320
#define CKM_CAST5_ECB                  0x00000321
#define CKM_CAST128_ECB                0x00000321
#define CKM_CAST5_CBC                  0x00000322
#define CKM_CAST128_CBC                0x00000322
#define CKM_CAST5_MAC                  0x00000323
#define CKM_CAST128_MAC                0x00000323
#define CKM_CAST5_MAC_GENERAL          0x00000324
#define CKM_CAST128_MAC_GENERAL        0x00000324
#define CKM_CAST5_CBC_PAD              0x00000325
#define CKM_CAST128_CBC_PAD            0x00000325
#define CKM_RC5_KEY_GEN                0x00000330
#define CKM_RC5_ECB                    0x00000331
#define CKM_RC5_CBC                    0x00000332
#define CKM_RC5_MAC                    0x00000333
#define CKM_RC5_MAC_GENERAL            0x00000334
#define CKM_RC5_CBC_PAD                0x00000335
#define CKM_IDEA_KEY_GEN               0x00000340
#define CKM_IDEA_ECB                   0x00000341
#define CKM_IDEA_CBC                   0x00000342
#define CKM_IDEA_MAC                   0x00000343
#define CKM_IDEA_MAC_GENERAL           0x00000344
#define CKM_IDEA_CBC_PAD               0x00000345
#define CKM_GENERIC_SECRET_KEY_GEN     0x00000350
#define CKM_CONCATENATE_BASE_AND_KEY   0x00000360
#define CKM_CONCATENATE_BASE_AND_DATA  0x00000362
#define CKM_CONCATENATE_DATA_AND_BASE  0x00000363
#define CKM_XOR_BASE_AND_DATA          0x00000364
#define CKM_EXTRACT_KEY_FROM_KEY       0x00000365
#define CKM_SSL3_PRE_MASTER_KEY_GEN    0x00000370
#define CKM_SSL3_MASTER_KEY_DERIVE     0x00000371
#define CKM_SSL3_KEY_AND_MAC_DERIVE    0x00000372
#define CKM_SSL3_MASTER_KEY_DERIVE_DH  0x00000373
#define CKM_TLS_PRE_MASTER_KEY_GEN     0x00000374
#define CKM_TLS_MASTER_KEY_DERIVE      0x00000375
#define CKM_TLS_KEY_AND_MAC_DERIVE     0x00000376
#define CKM_TLS_MASTER_KEY_DERIVE_DH   0x00000377
#define CKM_TLS_PRF                    0x00000378
#define CKM_SSL3_MD5_MAC               0x00000380
#define CKM_SSL3_SHA1_MAC              0x00000381
#define CKM_MD5_KEY_DERIVATION         0x00000390
#define CKM_MD2_KEY_DERIVATION         0x00000391
#define CKM_SHA1_KEY_DERIVATION        0x00000392
#define CKM_SHA256_KEY_DERIVATION      0x00000393
#define CKM_SHA384_KEY_DERIVATION      0x00000394
#define CKM_SHA512_KEY_DERIVATION      0x00000395
#define CKM_SHA224_KEY_DERIVATION      0x00000396
#define CKM_SHA3_256_KEY_DERIVE        0x00000397
#define CKM_SHA3_224_KEY_DERIVE        0x00000398
#define CKM_SHA3_384_KEY_DERIVE        0x00000399
#define CKM_SHA3_512_KEY_DERIVE        0x0000039A
#define CKM_SHAKE_128_KEY_DERIVE       0x0000039B
#define CKM_SHAKE_256_KEY_DERIVE       0x0000039C
#define CKM_PBE_MD2_DES_CBC            0x000003A0
#define CKM_PBE_MD5_DES_CBC            0x000003A1
#define CKM_PBE_MD5_CAST_CBC           0x000003A2
#define CKM_PBE_MD5_CAST3_CBC          0x000003A3
#define CKM_PBE_MD5_CAST5_CBC          0x000003A4
#define CKM_PBE_MD5_CAST128_CBC        0x000003A4
#define CKM_PBE_SHA1_CAST5_CBC         0x000003A5
#define CKM_PBE_SHA1_CAST128_CBC       0x000003A5
#define CKM_PBE_SHA1_RC4_128           0x000003A6
#define CKM_PBE_SHA1_RC4_40            0x000003A7
#define CKM_PBE_SHA1_DES3_EDE_CBC      0x000003A8
#define CKM_PBE_SHA1_DES2_EDE_CBC      0x000003A9
#define CKM_PBE_SHA1_RC2_128_CBC       0x000003AA
#define CKM_PBE_SHA1_RC2_40_CBC        0x000003AB
#define CKM_SP800_108_COUNTER_KDF      0x000003ac
#define CKM_SP800_108_FEEDBACK_KDF     0x000003ad
#define CKM_SP800_108_DOUBLE_PIPELINE_KDF 0x000003ae
#define CKM_PKCS5_PBKD2                0x000003B0
#define CKM_PBA_SHA1_WITH_SHA1_HMAC    0x000003C0
#define CKM_WTLS_PRE_MASTER_KEY_GEN         0x000003D0
#define CKM_WTLS_MASTER_KEY_DERIVE          0x000003D1
#define CKM_WTLS_MASTER_KEY_DERIVE_DH_ECC   0x000003D2
#define CKM_WTLS_PRF                        0x000003D3
#define CKM_WTLS_SERVER_KEY_AND_MAC_DERIVE  0x000003D4
#define CKM_WTLS_CLIENT_KEY_AND_MAC_DERIVE  0x000003D5
#define CKM_TLS10_MAC_SERVER                0x000003D6
#define CKM_TLS10_MAC_CLIENT                0x000003D7
#define CKM_TLS12_MAC                       0x000003D8
#define CKM_TLS12_KDF                       0x000003D9
#define CKM_TLS12_MASTER_KEY_DERIVE         0x000003E0
#define CKM_TLS12_KEY_AND_MAC_DERIVE        0x000003E1
#define CKM_TLS12_MASTER_KEY_DERIVE_DH      0x000003E2
#define CKM_TLS12_KEY_SAFE_DERIVE           0x000003E3
#define CKM_TLS_MAC                         0x000003E4
#define CKM_TLS_KDF                         0x000003E5
#define CKM_KEY_WRAP_LYNKS             0x00000400
#define CKM_KEY_WRAP_SET_OAEP          0x00000401
#define CKM_CMS_SIG                    0x00000500
#define CKM_KIP_DERIVE                 0x00000510
#define CKM_KIP_WRAP                   0x00000511
#define CKM_KIP_MAC                    0x00000512
#define CKM_CAMELLIA_KEY_GEN           0x00000550
#define CKM_CAMELLIA_ECB               0x00000551
#define CKM_CAMELLIA_CBC               0x00000552
#define CKM_CAMELLIA_MAC               0x00000553
#define CKM_CAMELLIA_MAC_GENERAL       0x00000554
#define CKM_CAMELLIA_CBC_PAD           0x00000555
#define CKM_CAMELLIA_ECB_ENCRYPT_DATA  0x00000556
#define CKM_CAMELLIA_CBC_ENCRYPT_DATA  0x00000557
#define CKM_CAMELLIA_CTR               0x00000558
#define CKM_ARIA_KEY_GEN               0x00000560
#define CKM_ARIA_ECB                   0x00000561
#define CKM_ARIA_CBC                   0x00000562
#define CKM_ARIA_MAC                   0x00000563
#define CKM_ARIA_MAC_GENERAL           0x00000564
#define CKM_ARIA_CBC_PAD               0x00000565
#define CKM_ARIA_ECB_ENCRYPT_DATA      0x00000566
#define CKM_ARIA_CBC_ENCRYPT_DATA      0x00000567
#define CKM_SEED_KEY_GEN               0x00000650
#define CKM_SEED_ECB                   0x00000651
#define CKM_SEED_CBC                   0x00000652
#define CKM_SEED_MAC                   0x00000653
#define CKM_SEED_MAC_GENERAL           0x00000654
#define CKM_SEED_CBC_PAD               0x00000655
#define CKM_SEED_ECB_ENCRYPT_DATA      0x00000656
#define CKM_SEED_CBC_ENCRYPT_DATA      0x00000657
#define CKM_SKIPJACK_KEY_GEN           0x00001000
#define CKM_SKIPJACK_ECB64             0x00001001
#define CKM_SKIPJACK_CBC64             0x00001002
#define CKM_SKIPJACK_OFB64             0x00001003
#define CKM_SKIPJACK_CFB64             0x00001004
#define CKM_SKIPJACK_CFB32             0x00001005
#define CKM_SKIPJACK_CFB16             0x00001006
#define CKM_SKIPJACK_CFB8              0x00001007
#define CKM_SKIPJACK_WRAP              0x00001008
#define CKM_SKIPJACK_PRIVATE_WRAP      0x00001009
#define CKM_SKIPJACK_RELAYX            0x0000100a
#define CKM_KEA_KEY_PAIR_GEN           0x00001010
#define CKM_KEA_KEY_DERIVE             0x00001011
#define CKM_KEA_DERIVE                 0x00001012
#define CKM_FORTEZZA_TIMESTAMP         0x00001020
#define CKM_BATON_KEY_GEN              0x00001030
#define CKM_BATON_ECB128               0x00001031
#define CKM_BATON_ECB96                0x00001032
#define CKM_BATON_CBC128               0x00001033
#define CKM_BATON_COUNTER              0x00001034
#define CKM_BATON_SHUFFLE              0x00001035
#define CKM_BATON_WRAP                 0x00001036
#define CKM_ECDSA_KEY_PAIR_GEN         0x00001040
#define CKM_EC_KEY_PAIR_GEN            0x00001040
#define CKM_ECDSA                      0x00001041
#define CKM_ECDSA_SHA1                 0x00001042
#define CKM_ECDSA_SHA224               0x00001043
#define CKM_ECDSA_SHA256               0x00001044
#define CKM_ECDSA_SHA384               0x00001045
#define CKM_ECDSA_SHA512               0x00001046
#define CKM_ECDSA_SHA3_224             0x00001047
#define CKM_ECDSA_SHA3_256             0x00001048
#define CKM_ECDSA_SHA3_384             0x00001049
#define CKM_ECDSA_SHA3_512             0x0000104a
#define CKM_ECDH1_DERIVE               0x00001050
#define CKM_ECDH1_COFACTOR_DERIVE      0x00001051
#define CKM_ECMQV_DERIVE               0x00001052
#define CKM_ECDH_AES_KEY_WRAP          0x00001053
#define CKM_RSA_AES_KEY_WRAP           0x00001054
#define CKM_EC_EDWARDS_KEY_PAIR_GEN    0x00001055
#define CKM_EC_MONTGOMERY_KEY_PAIR_GEN 0x00001056
#define CKM_EDDSA                      0x00001057
#define CKM_JUNIPER_KEY_GEN            0x00001060
#define CKM_JUNIPER_ECB128             0x00001061
#define CKM_JUNIPER_CBC128             0x00001062
#define CKM_JUNIPER_COUNTER            0x00001063
#define CKM_JUNIPER_SHUFFLE            0x00001064
#define CKM_JUNIPER_WRAP               0x00001065
#define CKM_FASTHASH                   0x00001070
#define CKM_AES_XTS                    0x00001071
#define CKM_AES_XTS_KEY_GEN            0x00001072
#define CKM_AES_KEY_GEN                0x00001080
#define CKM_AES_ECB                    0x00001081
#define CKM_AES_CBC                    0x00001082
#define CKM_AES_MAC                    0x00001083
#define CKM_AES_MAC_GENERAL            0x00001084
#define CKM_AES_CBC_PAD                0x00001085
#define CKM_AES_CTR                    0x00001086
#define CKM_AES_GCM                    0x00001087
#define CKM_AES_CCM                    0x00001088
#define CKM_AES_CTS                    0x00001089
#define CKM_AES_CMAC                   0x0000108A
#define CKM_AES_CMAC_GENERAL           0x0000108B
#define CKM_AES_XCBC_MAC               0x0000108C
#define CKM_AES_XCBC_MAC_96            0x0000108D
#define CKM_AES_GMAC                   0x0000108E
#define CKM_BLOWFISH_KEY_GEN           0x00001090
#define CKM_BLOWFISH_CBC               0x00001091
#define CKM_TWOFISH_KEY_GEN            0x00001092
#define CKM_TWOFISH_CBC                0x00001093
#define CKM_BLOWFISH_CBC_PAD           0x00001094
#define CKM_TWOFISH_CBC_PAD            0x00001095
#define CKM_DES_ECB_ENCRYPT_DATA       0x00001100
#define CKM_DES_CBC_ENCRYPT_DATA       0x00001101
#define CKM_DES3_ECB_ENCRYPT_DATA      0x00001102
#define CKM_DES3_CBC_ENCRYPT_DATA      0x00001103
#define CKM_AES_ECB_ENCRYPT_DATA       0x00001104
#define CKM_AES_CBC_ENCRYPT_DATA       0x00001105
#define CKM_GOSTR3410_KEY_PAIR_GEN     0x00001200
#define CKM_GOSTR3410                  0x00001201
#define CKM_GOSTR3410_WITH_GOSTR3411   0x00001202
#define CKM_GOSTR3410_KEY_WRAP         0x00001203
#define CKM_GOSTR3410_DERIVE           0x00001204
#define CKM_GOSTR3411                  0x00001210
#define CKM_GOSTR3411_HMAC             0x00001211
#define CKM_GOST28147_KEY_GEN          0x00001220
#define CKM_GOST28147_ECB              0x00001221
#define CKM_GOST28147                  0x00001222
#define CKM_GOST28147_MAC              0x00001223
#define CKM_GOST28147_KEY_WRAP         0x00001224
#define CKM_CHACHA20_KEY_GEN           0x00001225
#define CKM_CHACHA20                   0x00001226
#define CKM_POLY1305_KEY_GEN           0x00001227
#define CKM_POLY1305                   0x00001228
#define CKM_DSA_PARAMETER_GEN          0x00002000
#define CKM_DH_PKCS_PARAMETER_GEN      0x00002001
#define CKM_X9_42_DH_PARAMETER_GEN     0x00002002
#define CKM_DSA_PROBABLISTIC_PARAMETER_GEN    0x00002003
#define CKM_DSA_SHAWE_TAYLOR_PARAMETER_GEN    0x00002004
#define CKM_AES_OFB                    0x00002104
#define CKM_AES_CFB64                  0x00002105
#define CKM_AES_CFB8                   0x00002106
#define CKM_AES_CFB128                 0x00002107
#define CKM_AES_CFB1                   0x00002108
#define CKM_AES_KEY_WRAP               0x00002109
#define CKM_AES_KEY_WRAP_PAD           0x0000210A
#define CKM_AES_KEY_WRAP_KWP           0x0000210B
#define CKM_RSA_PKCS_TPM_1_1           0x00004001
#define CKM_RSA_PKCS_OAEP_TPM_1_1      0x00004002
#define CKM_SHA_1_KEY_GEN              0x00004003
#define CKM_SHA224_KEY_GEN             0x00004004
#define CKM_SHA256_KEY_GEN             0x00004005
#define CKM_SHA384_KEY_GEN             0x00004006
#define CKM_SHA512_KEY_GEN             0x00004007
#define CKM_SHA512_224_KEY_GEN         0x00004008
#define CKM_SHA512_256_KEY_GEN         0x00004009
#define CKM_SHA512_T_KEY_GEN           0x0000400a
#define CKM_NULL                       0x0000400b
#define CKM_BLAKE2B_160                0x0000400c
#define CKM_BLAKE2B_160_HMAC           0x0000400d
#define CKM_BLAKE2B_160_HMAC_GENERAL   0x0000400e
#define CKM_BLAKE2B_160_KEY_DERIVE     0x0000400f
#define CKM_BLAKE2B_160_KEY_GEN        0x00004010
#define CKM_BLAKE2B_256                0x00004011
#define CKM_BLAKE2B_256_HMAC           0x00004012
#define CKM_BLAKE2B_256_HMAC_GENERAL   0x00004013
#define CKM_BLAKE2B_256_KEY_DERIVE     0x00004014
#define CKM_BLAKE2B_256_KEY_GEN        0x00004015
#define CKM_BLAKE2B_384                0x00004016
#define CKM_BLAKE2B_384_HMAC           0x00004017
#define CKM_BLAKE2B_384_HMAC_GENERAL   0x00004018
#define CKM_BLAKE2B_384_KEY_DERIVE     0x00004019
#define CKM_BLAKE2B_384_KEY_GEN        0x0000401a
#define CKM_BLAKE2B_512                0x0000401b
#define CKM_BLAKE2B_512_HMAC           0x0000401c
#define CKM_BLAKE2B_512_HMAC_GENERAL   0x0000401d
#define CKM_BLAKE2B_512_KEY_DERIVE     0x0000401e
#define CKM_BLAKE2B_512_KEY_GEN        0x0000401f
#define CKM_SALSA20                    0x00004020
#define CKM_CHACHA20_POLY1305          0x00004021
#define CKM_SALSA20_POLY1305           0x00004022
#define CKM_X3DH_INITIALIZE            0x00004023
#define CKM_X3DH_RESPOND               0x00004024
#define CKM_X2RATCHET_INITIALIZE       0x00004025
#define CKM_X2RATCHET_RESPOND          0x00004026
#define CKM_X2RATCHET_ENCRYPT          0x00004027
#define CKM_X2RATCHET_DECRYPT          0x00004028
#define CKM_XEDDSA                     0x00004029
#define CKM_HKDF_DERIVE                0x0000402a
#define CKM_HKDF_DATA                  0x0000402b
#define CKM_HKDF_KEY_GEN               0x0000402c
#define CKM_VENDOR_DEFINED             0x80000000UL

#define CKG_MGF1_SHA1    0x00000001
#define CKG_MGF1_SHA256  0x00000002
#define CKG_MGF1_SHA384  0x00000003
#define CKG_MGF1_SHA512  0x00000004

#define CKF_HW                 0x00000001
#define CKF_MESSAGE_ENCRYPT    0x00000002
#define CKF_MESSAGE_DECRYPT    0x00000004
#define CKF_MESSAGE_SIGN       0x00000008
#define CKF_MESSAGE_VERIFY     0x00000010
#define CKF_MULTI_MESSGE       0x00000020
#define CKF_FIND_OBJECTS       0x00000040
#define CKF_ENCRYPT            0x00000100
#define CKF_DECRYPT            0x00000200
#define CKF_DIGEST             0x00000400
#define CKF_SIGN               0x00000800
#define CKF_SIGN_RECOVER       0x00001000
#define CKF_VERIFY             0x00002000
#define CKF_VERIFY_RECOVER     0x00004000
#define CKF_GENERATE           0x00008000
#define CKF_GENERATE_KEY_PAIR  0x00010000
#define CKF_WRAP               0x00020000
#define CKF_UNWRAP             0x00040000
#define CKF_DERIVE             0x00080000
#define CKF_EC_F_P             0x00100000
#define CKF_EC_F_2M            0x00200000
#define CKF_EC_ECPARAMETERS    0x00400000
#define CKF_EC_NAMEDCURVE      0x00800000
#define CKF_EC_UNCOMPRESS      0x01000000
#define CKF_EC_COMPRESS        0x02000000
#define CKF_EC_CURVENAME       0x04000000
#define CKF_EXTENSION          0x80000000UL

#define CKR_OK                                0x00000000
#define CKR_CANCEL                            0x00000001
#define CKR_HOST_MEMORY                       0x00000002
#define CKR_SLOT_ID_INVALID                   0x00000003
#define CKR_GENERAL_ERROR                     0x00000005
#define CKR_FUNCTION_FAILED                   0x00000006
#define CKR_ARGUMENTS_BAD                     0x00000007
#define CKR_NO_EVENT                          0x00000008
#define CKR_NEED_TO_CREATE_THREADS            0x00000009
#define CKR_CANT_LOCK                         0x0000000A
#define CKR_ATTRIBUTE_READ_ONLY               0x00000010
#define CKR_ATTRIBUTE_SENSITIVE               0x00000011
#define CKR_ATTRIBUTE_TYPE_INVALID            0x00000012
#define CKR_ATTRIBUTE_VALUE_INVALID           0x00000013
#define CKR_DATA_INVALID                      0x00000020
#define CKR_DATA_LEN_RANGE                    0x00000021
#define CKR_DEVICE_ERROR                      0x00000030
#define CKR_DEVICE_MEMORY                     0x00000031
#define CKR_DEVICE_REMOVED                    0x00000032
#define CKR_ENCRYPTED_DATA_INVALID            0x00000040
#define CKR_ENCRYPTED_DATA_LEN_RANGE          0x00000041
#define CKR_FUNCTION_CANCELED                 0x00000050
#define CKR_FUNCTION_NOT_PARALLEL             0x00000051
#define CKR_FUNCTION_NOT_SUPPORTED            0x00000054
#define CKR_KEY_HANDLE_INVALID                0x00000060
#define CKR_KEY_SIZE_RANGE                    0x00000062
#define CKR_KEY_TYPE_INCONSISTENT             0x00000063
#define CKR_KEY_NOT_NEEDED                    0x00000064
#define CKR_KEY_CHANGED                       0x00000065
#define CKR_KEY_NEEDED                        0x00000066
#define CKR_KEY_INDIGESTIBLE                  0x00000067
#define CKR_KEY_FUNCTION_NOT_PERMITTED        0x00000068
#define CKR_KEY_NOT_WRAPPABLE                 0x00000069
#define CKR_KEY_UNEXTRACTABLE                 0x0000006A
#define CKR_MECHANISM_INVALID                 0x00000070
#define CKR_MECHANISM_PARAM_INVALID           0x00000071
#define CKR_OBJECT_HANDLE_INVALID             0x00000082
#define CKR_OPERATION_ACTIVE                  0x00000090
#define CKR_OPERATION_NOT_INITIALIZED         0x00000091
#define CKR_PIN_INCORRECT                     0x000000A0
#define CKR_PIN_INVALID                       0x000000A1
#define CKR_PIN_LEN_RANGE                     0x000000A2
#define CKR_PIN_EXPIRED                       0x000000A3
#define CKR_PIN_LOCKED                        0x000000A4
#define CKR_SESSION_CLOSED                    0x000000B0
#define CKR_SESSION_COUNT                     0x000000B1
#define CKR_SESSION_HANDLE_INVALID            0x000000B3
#define CKR_SESSION_PARALLEL_NOT_SUPPORTED    0x000000B4
#define CKR_SESSION_READ_ONLY                 0x000000B5
#define CKR_SESSION_EXISTS                    0x000000B6
#define CKR_SESSION_READ_ONLY_EXISTS          0x000000B7
#define CKR_SESSION_READ_WRITE_SO_EXISTS      0x000000B8
#define CKR_SIGNATURE_INVALID                 0x000000C0
#define CKR_SIGNATURE_LEN_RANGE               0x000000C1
#define CKR_TEMPLATE_INCOMPLETE               0x000000D0
#define CKR_TEMPLATE_INCONSISTENT             0x000000D1
#define CKR_TOKEN_NOT_PRESENT                 0x000000E0
#define CKR_TOKEN_NOT_RECOGNIZED              0x000000E1
#define CKR_TOKEN_WRITE_PROTECTED             0x000000E2
#define CKR_UNWRAPPING_KEY_HANDLE_INVALID     0x000000F0
#define CKR_UNWRAPPING_KEY_SIZE_RANGE         0x000000F1
#define CKR_UNWRAPPING_KEY_TYPE_INCONSISTENT  0x000000F2
#define CKR_USER_ALREADY_LOGGED_IN            0x00000100
#define CKR_USER_NOT_LOGGED_IN                0x00000101
#define CKR_USER_PIN_NOT_INITIALIZED          0x00000102
#define CKR_USER_TYPE_INVALID                 0x00000103
#define CKR_USER_ANOTHER_ALREADY_LOGGED_IN    0x00000104
#define CKR_USER_TOO_MANY_TYPES               0x00000105
#define CKR_WRAPPED_KEY_INVALID               0x00000110
#define CKR_WRAPPED_KEY_LEN_RANGE             0x00000112
#define CKR_WRAPPING_KEY_HANDLE_INVALID       0x00000113
#define CKR_WRAPPING_KEY_SIZE_RANGE           0x00000114
#define CKR_WRAPPING_KEY_TYPE_INCONSISTENT    0x00000115
#define CKR_RANDOM_SEED_NOT_SUPPORTED         0x00000120
#define CKR_RANDOM_NO_RNG                     0x00000121
#define CKR_DOMAIN_PARAMS_INVALID             0x00000130
#define CKR_CURVE_NOT_SUPPORTED               0x00000140
#define CKR_BUFFER_TOO_SMALL                  0x00000150
#define CKR_SAVED_STATE_INVALID               0x00000160
#define CKR_INFORMATION_SENSITIVE             0x00000170
#define CKR_STATE_UNSAVEABLE                  0x00000180
#define CKR_CRYPTOKI_NOT_INITIALIZED          0x00000190
#define CKR_CRYPTOKI_ALREADY_INITIALIZED      0x00000191
#define CKR_MUTEX_BAD                         0x000001A0
#define CKR_MUTEX_NOT_LOCKED                  0x000001A1
#define CKR_NEW_PIN_MODE                      0x000001B0
#define CKR_NEXT_OTP                          0x000001B1
#define CKR_EXCEEDED_MAX_ITERATIONS           0x000001B5
#define CKR_FIPS_SELF_TEST_FAILED             0x000001B6
#define CKR_LIBRARY_LOAD_FAILED               0x000001B7
#define CKR_PIN_TOO_WEAK                      0x000001B8
#define CKR_PUBLIC_KEY_INVALID                0x000001B9
#define CKR_FUNCTION_REJECTED                 0x00000200
#define CKR_VENDOR_DEFINED                    0x80000000UL

#define CKF_LIBRARY_CANT_CREATE_OS_THREADS 0x00000001
#define CKF_OS_LOCKING_OK                  0x00000002
#define CKF_DONT_BLOCK     1

#define CKG_MGF1_SHA1         0x00000001
#define CKG_MGF1_SHA256       0x00000002
#define CKG_MGF1_SHA384       0x00000003
#define CKG_MGF1_SHA512       0x00000004
#define CKG_MGF1_SHA224       0x00000005

#define CKZ_DATA_SPECIFIED    0x00000001

#define CKD_NULL                 0x00000001
#define CKD_SHA1_KDF             0x00000002
#define CKD_SHA1_KDF_ASN1        0x00000003
#define CKD_SHA1_KDF_CONCATENATE 0x00000004
#define CKD_SHA224_KDF           0x00000005
#define CKD_SHA256_KDF           0x00000006
#define CKD_SHA384_KDF           0x00000007
#define CKD_SHA512_KDF           0x00000008
#define CKD_CPDIVERSIFY_KDF      0x00000009
#define CKD_SHA3_224_KDF         0x0000000A
#define CKD_SHA3_256_KDF         0x0000000B
#define CKD_SHA3_384_KDF         0x0000000C
#define CKD_SHA3_512_KDF         0x0000000D
#define CKD_SHA1_KDF_SP800       0x0000000E
#define CKD_SHA224_KDF_SP800     0x0000000F
#define CKD_SHA256_KDF_SP800     0x00000010
#define CKD_SHA384_KDF_SP800     0x00000011
#define CKD_SHA512_KDF_SP800     0x00000012
#define CKD_SHA3_224_KDF_SP800   0x00000013
#define CKD_SHA3_256_KDF_SP800   0x00000014
#define CKD_SHA3_384_KDF_SP800   0x00000015
#define CKD_SHA3_512_KDF_SP800   0x00000016
#define CKD_BLAKE2B_160_KDF      0x00000017
#define CKD_BLAKE2B_256_KDF      0x00000018
#define CKD_BLAKE2B_384_KDF      0x00000019
#define CKD_BLAKE2B_512_KDF      0x0000001a

#define CKP_PKCS5_PBKD2_HMAC_SHA1 0x00000001
#define CKP_PKCS5_PBKD2_HMAC_GOSTR3411     0x00000002
#define CKP_PKCS5_PBKD2_HMAC_SHA224        0x00000003
#define CKP_PKCS5_PBKD2_HMAC_SHA256        0x00000004
#define CKP_PKCS5_PBKD2_HMAC_SHA384        0x00000005
#define CKP_PKCS5_PBKD2_HMAC_SHA512        0x00000006
#define CKP_PKCS5_PBKD2_HMAC_SHA512_224    0x00000007
#define CKP_PKCS5_PBKD2_HMAC_SHA512_256    0x00000008

#define CKZ_SALT_SPECIFIED        0x00000001


%include "pkcs11lib.h"


class CK_ATTRIBUTE_SMART
{
	public:
	void Reset();
	void ResetValue();
	void Reserve(long len);
	unsigned long GetType() const;
	void SetType(unsigned long attrType);
	int GetLen() const;

	bool IsString() const;
	bool IsBool() const;
	bool IsNum() const;
	bool IsAttributeList() const;
	bool IsBin() const;

	PyKCS11String GetString() const;
	void SetString(unsigned long attrType, const char* szValue);

	long GetNum() const;
	void SetNum(unsigned long attrType, unsigned long ulValue);

	bool GetBool() const;
	void SetBool(unsigned long attrType, bool bValue);
	void SetList(unsigned long attrType, const vector<CK_ATTRIBUTE_SMART>& val);

	vector<unsigned char> GetBin();
	void SetBin(unsigned long attrType, const vector<unsigned char>& pBuf);
};
