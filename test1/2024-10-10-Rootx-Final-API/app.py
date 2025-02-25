from flask import Flask
from flask_mysqldb import MySQL
from flask_bcrypt import Bcrypt
from flask_mail import Mail
from routes import bp as user_routes

app = Flask(__name__)

# MySQL Configuration for MAMP
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_PORT'] = 8889  # MAMP default MySQL port
app.config['MYSQL_USER'] = 'root'  # Default MAMP MySQL user
app.config['MYSQL_PASSWORD'] = 'YES'  # Default MAMP MySQL password
app.config['MYSQL_DB'] = 'smart_digital_mobility_experience'  # Database name
app.config['MYSQL_CURSORCLASS'] = 'DictCursor'

# Initialize MySQL
mysql = MySQL(app)

# Initialize Bcrypt
bcrypt = Bcrypt(app)

# Initialize Flask-Mail
app.config['MAIL_SERVER'] = "smtp.googlemail.com"
app.config['MAIL_PORT'] = 587
app.config['MAIL_USE_TLS'] = True
app.config['MAIL_USERNAME'] = "aselarohana0522@gmail.com"  # Your email address
app.config['MAIL_PASSWORD'] = "hsdm rnre mrbz ptta"  # Your email password (consider securing this)

mail = Mail(app)

# Register Blueprints
app.register_blueprint(user_routes)

if __name__ == '__main__':
    app.run(port=8888, debug=True, host='192.168.1.2')
