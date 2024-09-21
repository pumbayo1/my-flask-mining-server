from flask import Flask, send_file
import os

app = Flask(__name__)

# Ścieżka do pliku mining_history.csv
CSV_PATH = '/root/scripts/mining_history.csv'

@app.route('/mining_data', methods=['GET'])
def get_mining_data():
    if os.path.exists(CSV_PATH):
        return send_file(CSV_PATH, mimetype='text/csv', as_attachment=False)
    return "Brak danych", 404

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
