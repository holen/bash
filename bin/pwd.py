#!/usr/bin/env python  
#coding=utf-8 
import os
import sys
import base64
import rijndael

KEY_SIZE = 16
BLOCK_SIZE = 32

url     = ""  # 不需要 /api/index.php
api_id  = ""
api_key = "b427852fcd9a5a1b1228ab22ccd1c934"

def encrypt(key, plaintext):
    padded_key = key.ljust(KEY_SIZE, '\0')
    padded_text = plaintext + (BLOCK_SIZE - len(plaintext) % BLOCK_SIZE) * '\0'

    r = rijndael.rijndael(padded_key, BLOCK_SIZE)

    ciphertext = ''
    for start in range(0, len(padded_text), BLOCK_SIZE):
        ciphertext += r.encrypt(padded_text[start:start+BLOCK_SIZE])

    encoded = base64.b64encode(ciphertext)

    return encoded

def decrypt(key, encoded):
    padded_key = key.ljust(KEY_SIZE, '\0')

    ciphertext = base64.b64decode(encoded)

    r = rijndael.rijndael(padded_key, BLOCK_SIZE)

    padded_text = ''
    for start in range(0, len(ciphertext), BLOCK_SIZE):
        padded_text += r.decrypt(ciphertext[start:start+BLOCK_SIZE])

    plaintext = padded_text.split('\x00', 1)[0]

    return plaintext


def usage():
    print '''
python pwd.py [value]
value =	解密密文/加密明文
python pwd.py xxxxx
'''
    return 0

if ( len( sys.argv ) != 2 ):
    usage()
    sys.exit(1)
try:    
    #s = raw_input('Enter KeyString --> ')
    if len(sys.argv[1]) == 44:
        print sys.argv[1] +  ' 密文->明文 ' + decrypt(api_key,sys.argv[1])
    else:
        print sys.argv[1] +  ' 明文->密文 ' + encrypt(api_key,sys.argv[1])
except:
    print '密文不符合要求'
    sys.exit(1)

