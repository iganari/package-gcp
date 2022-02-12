FROM python:3.9.10-alpine3.15


ADD ./requirements.txt /tmp/requirements.txt
RUN pip3 install -r /tmp/requirements.txt

RUN mkdir -p /app
ADD ./main.py /app/main.py

CMD [ "/usr/local/bin/python3", "/app/main.py" ]
