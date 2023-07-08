FROM python:3.10-slim

RUN apt-get update \
 && apt-get install unixodbc -y \
 && apt-get install unixodbc-dev -y \
 && apt-get install freetds-dev -y \
 && apt-get install freetds-bin -y \
 && apt-get install tdsodbc -y \
 && apt-get install --reinstall build-essential -y

COPY ./requirements.txt /app/requirements.txt
WORKDIR /app
RUN pip install -r requirements.txt
COPY . /app/

EXPOSE 5000
ENTRYPOINT ["python", "/app/app.py"]