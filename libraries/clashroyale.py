import requests


def get_clan(token):

    url = "https://api.clashroyale.com/v1/clans/?name=The%20resistance"

    headers = {'Authorization': 'Bearer ' + token}

    response = requests.get(url, headers=headers)

    return response

def get_list_of_clan_members(token, tag):

    url = "https://api.clashroyale.com/v1/clans/"+ tag + "/members"

    headers = {'Authorization': 'Bearer ' + token}

    response = requests.get(url, headers=headers)

    return response
