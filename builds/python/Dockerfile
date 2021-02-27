FROM python:3.9.2-alpine3.12

ADD . /srv/
RUN pip3 install -r /srv/requirements.txt

ENTRYPOINT ["python3","/srv/main.py"]
