#/usr/bin/python3
# coding: utf-8

import sys
import io
import qrcode
from flask import escape, helpers

def url-qrcode(request):
    img = generate_qr_image(url=request.args.get('q'))
    buf = io.BytesIO()
    img.save(buf, 'png')
    response = helpers.make_response(buf.getvalue())
    response.headers["Content-type"] = "Image"
    
    return response


def generate_qr_image(url='https://www.google.co.jp/'):
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=10,
        border=4,
    )
    qr.add_data(url)
    qr.make(fit=True)

    img = qr.make_image()
    
    return img
