# routes/user_routes.py

from flask import Blueprint, request, jsonify, render_template
from flask_mysqldb import MySQL
import bcrypt
from flask_mail import Mail, Message
from app import app, mysql

bp = Blueprint('user_routes', __name__)

mail = Mail(app)

# Sign up passenger (matches passenger_information_table schema)
@bp.route('/passenger_signup', methods=['POST'])
def passenger_signup():  # Renamed from signup to passenger_signup
    data = request.get_json()
    email = data.get('email')
    name = data.get('name')  # 'username' changed to 'name'
    phone = data.get('phone')
    password = data.get('password')

    if not email or not name or not phone or not password:
        return jsonify({'error': 'Please provide all fields!'}), 400

    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM passenger_information_table WHERE email=%s", (email,))
    existing_user = cur.fetchone()

    if existing_user:
        return jsonify({'error': 'User already exists!'}), 400

    hashed_password = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())

    cur.execute("INSERT INTO passenger_information_table (Email, Name, Phone_Number, Password) VALUES (%s, %s, %s, %s)",
                (email, name, phone, hashed_password))
    mysql.connection.commit()
    cur.close()
    
    send_email(email, name)

    # Return success response after user registration
    return jsonify({'message': 'User registered successfully!'}), 201


def send_email(to_email, name):
    msg_title = "Welcome to Rootx Mobile App!"
    sender = "aselarohana0522@gmail.com"
    msg = Message(msg_title, sender=sender, recipients=[to_email])

    # Render the welcome email HTML template
    msg.html = render_template("welcomeEmail.html", username=name)  # Pass the name to the template

    try:
        mail.send(msg)  # Use the mail instance to send the message
        print(f"Email sent to {to_email} successfully.")
    except Exception as e:
        print(f"The email was not sent: {e}")


@bp.route('/passenger_reset_password', methods=['POST'])
def reset_password():
    data = request.get_json()
    email = data.get('email')
    new_password = data.get('new_password')

    if not email or not new_password:
        return jsonify({'error': 'Please provide both email and new password!'}), 400

    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM passenger_information_table WHERE email=%s", (email,))
    existing_user = cur.fetchone()

    if not existing_user:
        return jsonify({'error': 'User not found!'}), 404

    hashed_password = bcrypt.hashpw(new_password.encode('utf-8'), bcrypt.gensalt())

    cur.execute("UPDATE passenger_information_table SET password=%s WHERE email=%s", (hashed_password, email))
    mysql.connection.commit()
    cur.close()

    return jsonify({'message': 'Password reset successful!'}), 200


@bp.route('/passenger_signin', methods=['POST'])
def passenger_signin():  # Renamed to differentiate from driver signin
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')

    if not email or not password:
        return jsonify({'error': 'Please provide both email and password!'}), 400

    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM passenger_information_table WHERE email=%s", (email,))
    user = cur.fetchone()
    cur.close()

    if user is None:
        return jsonify({'Error': 'User does not exist!'}), 404

    if bcrypt.checkpw(password.encode('utf-8'), user['Password'].encode('utf-8')):
        return jsonify({'message': 'Login successful!', 'user': {
            'email': user['Email'],
            'name': user['Name'],
            'phone': user['Phone_Number']
        }}), 200
    else:
        return jsonify({'Error': 'Invalid password!'}), 401


# Get distinct start locations from Bus_Information_Table
@bp.route('/fromLocations', methods=['GET'])
def get_from_locations():
    try:
        cur = mysql.connection.cursor()
        cur.execute("SELECT DISTINCT Start_Location FROM Bus_Information_Table")
        locations = cur.fetchall()
        cur.close()

        # Extract the locations from the query result
        start_locations = [location['Start_Location'] for location in locations]
        return jsonify(start_locations)  # Return as JSON response
    except Exception as e:
        print(f"Error: {e}")
        return jsonify({"error": "Error fetching locations"}), 500


# Get distinct end locations from Bus_Information_Table
@bp.route('/toLocations', methods=['GET'])
def get_to_locations():
    try:
        cur = mysql.connection.cursor()
        cur.execute("SELECT DISTINCT End_Location FROM Bus_Information_Table")
        locations = cur.fetchall()
        cur.close()

        # Extract the locations from the query result
        end_locations = [location['End_Location'] for location in locations]
        return jsonify(end_locations)  # Return as JSON response
    except Exception as e:
        print(f"Error: {e}")
        return jsonify({"error": "Error fetching locations"}), 500


@bp.route('/buses', methods=['GET'])
def get_buses():
    try:
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM Bus_Information_Table")  # Fetch all bus information
        buses = cur.fetchall()
        cur.close()

        # Convert each bus record into a serializable format
        bus_list = []
        for bus in buses:
            bus_data = {
                'Bus_ID': bus['Bus_ID'],
                'Start_Location': bus['Start_Location'],
                'End_Location': bus['End_Location'],
                'Bus_Number': bus['Bus_Number'],
                'Ticket_Price': float(bus['Ticket_Price']),  # Ensure decimal is converted to float
                'Bus_Name': bus['Bus_Name'],
                'Total_Seats': bus['Total_Seats'],
                'Route_Number': bus['Route_Number'],
                'Start_Time': str(bus['Start_Time']), # Convert timedelta or time object to string
                'Travel_date': str(bus['travel_date']) # Convert date object to string

            }
            bus_list.append(bus_data)

        # Return bus data as JSON response
        return jsonify(bus_list)
    except Exception as e:
        print(f"Error: {e}")
        return jsonify({"error": "Error fetching bus information"}), 500



# Process payment API (make sure a payments table exists)
@bp.route('/process_payment', methods=['POST'])
def process_payment():
    data = request.get_json()

    bus_id = data.get('bus_id')
    ticket_price = data.get('ticket_price')
    payment_method = data.get('payment_method')

    if not bus_id or not ticket_price or not payment_method:
        return jsonify({'status': 'error', 'message': 'Missing data'}), 400

    try:
        cur = mysql.connection.cursor()
        
        # Insert payment record into the database
        query = "INSERT INTO payments (Bus_ID, ticket_price, payment_method) VALUES (%s, %s, %s)"
        cur.execute(query, (bus_id, ticket_price, payment_method))
        
        mysql.connection.commit()
        cur.close()

        return jsonify({'status': 'success', 'message': 'Payment processed successfully'}), 200
    except Exception as err:
        print(f"Error: {err}")
        return jsonify({'status': 'error', 'message': 'Database error'}), 500



# Sign up driver
@bp.route('/driver_signup', methods=['POST'])
def driver_signup():  # Renamed from signup to driver_signup
    data = request.get_json()
    email = data.get('email')
    name = data.get('name')
    phone = data.get('phone')
    password = data.get('password')
    bus_number = data.get('bus_number')

    if not all([email, name, phone, password, bus_number]):
        return jsonify({'error': 'Please provide all fields!'}), 400

    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM Driver_Information_Table WHERE Email=%s", (email,))
    if cur.fetchone():
        return jsonify({'error': 'Driver already exists!'}), 400

    hashed_password = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())

    cur.execute("INSERT INTO Driver_Information_Table (Email, Name, Phone_Number, Password, Bus_Number) VALUES (%s, %s, %s, %s, %s)",
                (email, name, phone, hashed_password, bus_number))
    mysql.connection.commit()
    cur.close()

    send_email(email, name)

    return jsonify({'message': 'Driver registered successfully!'}), 201

def send_email(to_email, name):
    msg_title = "Welcome to Rootx Mobile App!"
    sender = "aselarohana0522@gmail.com"
    msg = Message(msg_title, sender=sender, recipients=[to_email])
    msg.html = render_template("welcomeEmail.html", username=name)

    try:
        mail.send(msg)
        print(f"Email sent to {to_email} successfully.")
    except Exception as e:
        print(f"The email was not sent: {e}")

@bp.route('/driver_reset_password', methods=['POST'])
def driver_reset_password():  # Renamed to differentiate from passenger reset password
    data = request.get_json()
    email = data.get('email')
    new_password = data.get('new_password')

    if not email or not new_password:
        return jsonify({'error': 'Please provide both email and new password!'}), 400

    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM Driver_Information_Table WHERE Email=%s", (email,))
    if not cur.fetchone():
        return jsonify({'error': 'Driver not found!'}), 404

    hashed_password = bcrypt.hashpw(new_password.encode('utf-8'), bcrypt.gensalt())
    cur.execute("UPDATE Driver_Information_Table SET Password=%s WHERE Email=%s", (hashed_password, email))
    mysql.connection.commit()
    cur.close()

    return jsonify({'message': 'Password reset successful!'}), 200

@bp.route('/driver_signin', methods=['POST'])
def driver_signin():  # Renamed to differentiate from passenger signin
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')

    if not email or not password:
        return jsonify({'error': 'Please provide both email and password!'}), 400

    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM Driver_Information_Table WHERE Email=%s", (email,))
    driver = cur.fetchone()
    cur.close()

    if driver is None:
        return jsonify({'Error': 'Driver does not exist!'}), 404

    if bcrypt.checkpw(password.encode('utf-8'), driver['Password'].encode('utf-8')):
        return jsonify({'message': 'Login successful!', 'driver': {
            'email': driver['Email'],
            'name': driver['Name'],
            'phone': driver['Phone_Number'],
            'bus_number': driver['Bus_Number']
        }}), 200
    else:
        return jsonify({'Error': 'Invalid password!'}), 401
