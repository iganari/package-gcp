import os
from flask import Flask

container_port = int(os.environ['PORT'])

app = Flask(__name__)

@app.route('/')
def index():
    return 'Hello World!! :D'

if __name__ == '__main__':
    app.run(debug=False, host='0.0.0.0', port=container_port)
