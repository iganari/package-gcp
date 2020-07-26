# https://github.com/GoogleCloudPlatform/python-docs-samples/blob/master/appengine/standard_python3/hello_world/main.py

from flask import Flask

# If `entrypoint` is not defined in app.yaml, App Engine will look for an app
# called `app` in `main.py`.
app = Flask(__name__)


@app.route('/')
def hello():
    """Return a friendly HTTP greeting."""
    return 'Hello World! from App Engine.\n'
@app.route('/<mypath>')
def show_path(mypath):
    # target = os.environ.get('TARGET', 'World')
    return 'Your Path is "/{}" from App Engine.\n'.format(mypath)

if __name__ == '__main__':
    # This is used when running locally only. When deploying to Google App
    # Engine, a webserver process such as Gunicorn will serve the app. This
    # can be configured by adding an `entrypoint` to app.yaml.
    app.run(host='127.0.0.1', port=8080, debug=True)
# [END gae_python38_app]
