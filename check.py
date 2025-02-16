from flask import Flask, jsonify, request

app = Flask(__name__)

# Define an endpoint for the kill switch status
@app.route('/kill_switch', methods=['GET'])
def kill_switch():
    # Here you can toggle this to False or True to control the kill switch
    status = True  # For example, set it to True to indicate the kill switch is on
    return jsonify({'status': status})

# Check if the request is from the program (you can use a secret key)
@app.before_request
def check_program_request():
    if request.endpoint == 'kill_switch':
        # Check for a special header that your program will send
        if request.headers.get('X-Program-Access') != 'powerbearsigmaawiwaw2222':
            return 'Unauthorized', 401  # Return 401 Unauthorized for normal users

    return None

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=80)
