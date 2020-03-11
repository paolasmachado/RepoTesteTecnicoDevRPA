import requests


def get_clan(token):
    print("Token" % token)

    url = "https://api.clashroyale.com/v1/clans/?name=The%20resistance"

    headers = {
    'Accept': 'application/json',
    'Authorization': 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiIsImtpZCI6IjI4YTMxOGY3LTAwMDAtYTFlYi03ZmExLTJjNzQzM2M2Y2NhNSJ9.eyJpc3MiOiJzdXBlcmNlbGwiLCJhdWQiOiJzdXBlcmNlbGw6Z2FtZWFwaSIsImp0aSI6IjlkMjA3ZTE5LWVkN2UtNGFjOS1iNDFmLTcyN2RiOGZmZGM0MyIsImlhdCI6MTU4MzkzMzY0Miwic3ViIjoiZGV2ZWxvcGVyLzdjYWM0ZDQyLWVkZTgtNGFmYy05ZDI2LTQ4MTQ2N2I4YWU0NiIsInNjb3BlcyI6WyJyb3lhbGUiXSwibGltaXRzIjpbeyJ0aWVyIjoiZGV2ZWxvcGVyL3NpbHZlciIsInR5cGUiOiJ0aHJvdHRsaW5nIn0seyJjaWRycyI6WyI0NS4yMzUuNTIuMTM0Il0sInR5cGUiOiJjbGllbnQifV19.ligo56W3FBWTn3cIdm5leM-dOCWFV1C5U_csSV_uFu8kS-VQ4jDq1l-wGmigzGB4_A1NqLXpa4wlrE-e--x5Iw'
    }

    response = requests.request("GET", url, headers=headers)
    data = response.json()

    print(data)

    # print content of request
    #print(data.content)

    #print(response.text.encode('utf8'))
    #return data
