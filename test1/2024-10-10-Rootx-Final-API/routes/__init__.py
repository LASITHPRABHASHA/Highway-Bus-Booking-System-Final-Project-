from flask import Blueprint
bp = Blueprint('user_routes', __name__)
from .user_routes import *  # Ensure this imports your route functions
