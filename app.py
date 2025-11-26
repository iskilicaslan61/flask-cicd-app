from flask import Flask, render_template, request, jsonify
from datetime import datetime
import os

app = Flask(__name__)

# Simple in-memory data store
visitors = []
visit_count = 0

@app.route('/')
def index():
    global visit_count
    visit_count += 1
    return render_template('index.html', visit_count=visit_count)

@app.route('/about')
def about():
    return render_template('about.html')

@app.route('/api/visitors', methods=['GET', 'POST'])
def api_visitors():
    global visitors

    if request.method == 'POST':
        data = request.get_json()
        visitor = {
            'name': data.get('name'),
            'message': data.get('message'),
            'timestamp': datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        }
        visitors.append(visitor)
        return jsonify({'success': True, 'visitor': visitor})

    return jsonify({'visitors': visitors, 'count': len(visitors)})

@app.route('/health')
def health():
    return jsonify({
        'status': 'healthy',
        'timestamp': datetime.now().isoformat(),
        'version': os.getenv('APP_VERSION', '1.0.0')
    })

if __name__ == '__main__':
    port = int(os.getenv('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=False)
