

# # Sign up driver
# @bp.route('/driver_signup', methods=['POST'])
# def driver_signup():  # Renamed from signup to driver_signup
#     data = request.get_json()
#     email = data.get('email')
#     name = data.get('name')
#     phone = data.get('phone')
#     password = data.get('password')
#     bus_number = data.get('bus_number')

#     if not all([email, name, phone, password, bus_number]):
#         return jsonify({'error': 'Please provide all fields!'}), 400

#     cur = mysql.connection.cursor()
#     cur.execute("SELECT * FROM Driver_Information_Table WHERE Email=%s", (email,))
#     if cur.fetchone():
#         return jsonify({'error': 'Driver already exists!'}), 400

#     hashed_password = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())

#     cur.execute("INSERT INTO Driver_Information_Table (Email, Name, Phone_Number, Password, Bus_Number) VALUES (%s, %s, %s, %s, %s)",
#                 (email, name, phone, hashed_password, bus_number))
#     mysql.connection.commit()
#     cur.close()

#     send_email(email, name)

#     return jsonify({'message': 'Driver registered successfully!'}), 201

# def send_email(to_email, name):
#     msg_title = "Welcome to Rootx Mobile App!"
#     sender = "aselarohana0522@gmail.com"
#     msg = Message(msg_title, sender=sender, recipients=[to_email])
#     msg.html = render_template("welcomeEmail.html", username=name)

#     try:
#         mail.send(msg)
#         print(f"Email sent to {to_email} successfully.")
#     except Exception as e:
#         print(f"The email was not sent: {e}")

# @bp.route('/driver_reset_password', methods=['POST'])
# def driver_reset_password():  # Renamed to differentiate from passenger reset password
#     data = request.get_json()
#     email = data.get('email')
#     new_password = data.get('new_password')

#     if not email or not new_password:
#         return jsonify({'error': 'Please provide both email and new password!'}), 400

#     cur = mysql.connection.cursor()
#     cur.execute("SELECT * FROM Driver_Information_Table WHERE Email=%s", (email,))
#     if not cur.fetchone():
#         return jsonify({'error': 'Driver not found!'}), 404

#     hashed_password = bcrypt.hashpw(new_password.encode('utf-8'), bcrypt.gensalt())
#     cur.execute("UPDATE Driver_Information_Table SET Password=%s WHERE Email=%s", (hashed_password, email))
#     mysql.connection.commit()
#     cur.close()

#     return jsonify({'message': 'Password reset successful!'}), 200

# @bp.route('/driver_signin', methods=['POST'])
# def driver_signin():  # Renamed to differentiate from passenger signin
#     data = request.get_json()
#     email = data.get('email')
#     password = data.get('password')

#     if not email or not password:
#         return jsonify({'error': 'Please provide both email and password!'}), 400

#     cur = mysql.connection.cursor()
#     cur.execute("SELECT * FROM Driver_Information_Table WHERE Email=%s", (email,))
#     driver = cur.fetchone()
#     cur.close()

#     if driver is None:
#         return jsonify({'Error': 'Driver does not exist!'}), 404

#     if bcrypt.checkpw(password.encode('utf-8'), driver['Password'].encode('utf-8')):
#         return jsonify({'message': 'Login successful!', 'driver': {
#             'email': driver['Email'],
#             'name': driver['Name'],
#             'phone': driver['Phone_Number'],
#             'bus_number': driver['Bus_Number']
#         }}), 200
#     else:
#         return jsonify({'Error': 'Invalid password!'}), 401
