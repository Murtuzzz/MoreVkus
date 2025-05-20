from flask import Flask, jsonify, request
from flask_cors import CORS

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}}, supports_credentials=True)

# Sample product data
products = [
    {"id":1,"name":"Milk","description":"Fresh milk","price":"99.00","in_stock":True,"product_count":50.0,"category":1},
    {"id":2,"name":"Cheese","description":"Cheddar cheese","price":"299.00","in_stock":True,"product_count":30.0,"category":1},
    {"id":3,"name":"Yogurt","description":"Greek yogurt","price":"129.00","in_stock":True,"product_count":40.0,"category":1},
    {"id":4,"name":"Butter","description":"Farm butter","price":"189.00","in_stock":True,"product_count":25.0,"category":1},
    {"id":5,"name":"Cream","description":"Heavy cream","price":"159.00","in_stock":True,"product_count":20.0,"category":1},
    {"id":6,"name":"Ice Cream","description":"Vanilla ice cream","price":"249.00","in_stock":True,"product_count":15.0,"category":1}
]

@app.route('/get-url', methods=['GET'])
def get_products():
    response = jsonify(products)
    response.headers.add('Access-Control-Allow-Origin', '*')
    return response

@app.route('/api/products', methods=['GET'])
def get_products_alt():
    return jsonify(products)

@app.route('/', methods=['GET'])
def index():
    return """
    <html>
      <head><title>Product API Server</title></head>
      <body>
        <h1>Product API Server is running</h1>
        <p>Available endpoints:</p>
        <ul>
          <li><a href="/get-url">/get-url</a> - Returns product data</li>
          <li><a href="/api/products">/api/products</a> - Alternative endpoint</li>
        </ul>
      </body>
    </html>
    """

if __name__ == '__main__':
    print("Server running at http://localhost:5002/")
    print("API endpoints:")
    print("- http://localhost:5002/get-url")
    print("- http://localhost:5002/api/products")
    app.run(host='0.0.0.0', port=5002, debug=True) 