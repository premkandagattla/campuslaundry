import json
import logging
import connexion
from flask import render_template
from common.json_lib import JsonSerializable
from connexion.exceptions import BadRequestProblem

logging.basicConfig(level=logging.INFO)
app = connexion.FlaskApp(__name__, specification_dir='specs/')

app.template_folder = 'templates'
app.app.logger.info("Flask logger ready!")

app.add_api(
    'campus-laundry.yaml',
    arguments={'title': 'campus-laundry'},
    validate_responses=True,
    strict_validation=True
)


def handle_validation_error(exception):
    response_body = JsonSerializable()
    header = JsonSerializable()
    header.error_code = 4000
    header.error_message = exception.detail
    header.status = exception.status
    header.rows_returned = 0
    header.time_taken = 0
    response_body.header = header
    response_body.results = []

    return json.loads(response_body.to_json()), exception.status


app.add_error_handler(BadRequestProblem, handle_validation_error)


@app.route("/")
@app.route("/campus-laundry")
@app.route("/campus-laundry/")
def home():
    return render_template('home.html')

#
# @app.route("/campus-laundry")
# def campus():
#     return render_template('home.html')


application = app.app

if __name__ == "__main__":
    app.run()
