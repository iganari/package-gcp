# coding: utf-8

"""
実行方法
$ python3 main.py
"""

import urllib.request

url = 'http://ipecho.net/plain'

def getGlobalIp():
    """
    自分の所属するグローバルIPアドレスを返す
    """
    
    ip = urllib.request.urlopen(url).read().decode('utf-8')
    return ip

def main():
    print(getGlobalIp())

if __name__ == '__main__':
    main()
