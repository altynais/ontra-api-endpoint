from flask import Flask, jsonify
import time

app = Flask(__name__)

@app.route('/')
def get_current_epoch_time():
    current_time = int(time.time())
    response = {"The current epoch time": current_time}
    return jsonify(response)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)