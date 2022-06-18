# hoge

## 概要

hoge

```
Google Stackdriver Uptime Checks API Python Samples
https://github.com/googleapis/python-monitoring/tree/main/samples/snippets/v3/uptime-check-client
```

## やってみる

+ Python の Version 確認

```
$ python --version
Python 3.9.2
```

+ src

```
git clone https://github.com/googleapis/python-monitoring.git
```

+ hoge

```
virtualenv env
source env/bin/activate
```

+ hoge

```
cd python-monitoring/samples/snippets/v3/uptime-check-client/
```

+ hoge

```
pip3 install -r requirements.txt
```

+ help の表示

```
$ python3 snippets.py -h
usage: snippets.py [-h]
                   {list-uptime-check-configs,list-uptime-check-ips,create-uptime-check-get,create-uptime-check-post,get-uptime-check-config,delete-uptime-check-config,update-uptime-check-config}
                   ...

Demonstrates Uptime Check API operations.

positional arguments:
  {list-uptime-check-configs,list-uptime-check-ips,create-uptime-check-get,create-uptime-check-post,get-uptime-check-config,delete-uptime-check-config,update-uptime-check-config}
    list-uptime-check-configs
    list-uptime-check-ips
    create-uptime-check-get
    create-uptime-check-post
    get-uptime-check-config
    delete-uptime-check-config
    update-uptime-check-config

optional arguments:
  -h, --help            show this help message and exit
```

+ 試しに IP アドレスを取得してみる

```
$ python3 snippets.py list-uptime-check-ips
  region  location           ip_address
--------  -----------------  ---------------
       4  Singapore          35.187.242.246
       4  Singapore          35.186.144.97
       4  Singapore          35.198.221.49
       4  Singapore          35.198.194.122
       4  Singapore          35.198.248.66
       4  Singapore          35.185.178.105
       4  Singapore          35.198.224.104
       4  Singapore          35.240.151.105
       4  Singapore          35.186.159.51
       3  Sao Paulo, Brazil  35.199.66.47
       3  Sao Paulo, Brazil  35.198.18.224
       3  Sao Paulo, Brazil  35.199.67.79
       3  Sao Paulo, Brazil  35.198.36.209
       3  Sao Paulo, Brazil  35.199.90.14
       3  Sao Paulo, Brazil  35.199.123.150
       3  Sao Paulo, Brazil  35.198.39.162
       3  Sao Paulo, Brazil  35.199.77.186
       3  Sao Paulo, Brazil  35.199.126.168
       1  Oregon             35.197.117.125
       1  Oregon             35.203.157.42
       1  Oregon             35.199.157.7
       1  Oregon             35.233.206.171
       1  Oregon             35.197.32.224
       1  Oregon             35.233.167.246
       1  Oregon             35.203.129.73
       1  Oregon             35.185.252.44
       1  Oregon             35.233.165.146
       1  Iowa               146.148.59.114
       1  Iowa               23.251.144.62
       1  Iowa               146.148.41.163
       1  Iowa               35.239.194.85
       1  Iowa               104.197.30.241
       1  Iowa               35.192.92.84
       1  Iowa               35.238.3.7
       1  Iowa               35.224.249.156
       1  Iowa               35.238.118.210
       1  Virginia           35.186.164.184
       1  Virginia           35.188.230.101
       1  Virginia           35.199.27.30
       1  Virginia           35.186.176.31
       1  Virginia           35.236.207.68
       1  Virginia           35.236.221.2
       1  Virginia           35.221.55.249
       1  Virginia           35.199.12.162
       1  Virginia           35.186.167.85
       2  Belgium            104.155.77.122
       2  Belgium            104.155.110.139
       2  Belgium            146.148.119.250
       2  Belgium            35.195.128.75
       2  Belgium            35.240.124.58
       2  Belgium            35.205.234.10
       2  Belgium            35.205.72.231
       2  Belgium            35.187.114.193
       2  Belgium            35.205.205.242
```

+ hoge

```
deactivate
```
