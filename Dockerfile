FROM python

WORKDIR /app

COPY requirements.txt .

ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV SECRET_KEY="stringuesshardto"

# We must install all the libraries listed in requirement.txt
RUN pip install --upgrade pip && pip install -r requirements.txt

COPY . .

#The python code should wait for the database server to be ready before connecting to it 

RUN wget https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh -P /scripts
RUN chmod +x /scripts/wait-for-it.sh
ENTRYPOINT ["/scripts/wait-for-it.sh", "db:5432", "--"]

#The Flask application uses the port 5000
EXPOSE 5000


CMD ["python","app.py", "runserver", "--host=0.0.0.0", "--threaded"]

