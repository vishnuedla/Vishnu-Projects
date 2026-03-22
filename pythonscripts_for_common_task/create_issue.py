from flask import Flask
import requests
from requests.auth import HTTPBasicAuth
import json

app = Flask(__name__)

@app.route('/githubissue', methods=["POST"])
def Jira_issue():
    url = "https://domain.atlassian.net/rest/api/3/issue"
    
    auth = HTTPBasicAuth("email", token)

    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json"
    }

    payload = json.dumps({
        "fields": {
            "description": {
                "content": [
                    {
                        "content": [
                            {
                                "text": "Kindly check git hub issue",
                                "type": "text"
                            }
                        ],
                        "type": "paragraph"
                    }
                ],
                "type": "doc",
                "version": 1
            },
            "issuetype": {
                "id": "10008"
            },
            "project": {
                "id": "10001"
            },
            "summary": "Summary of github issue"
        },
        "update": {}
    })


    response = requests.request(
       "POST",
       url,
       data=payload,
       headers=headers,
       auth=auth
    )

    if 201 == response.status_code:
        return "sucessfully created the issue in jira"
    else:

        return "Somethinng went wrong"


app.run(host="0.0.0.0",port=5000)


