# FIXME: このファイルは、Google Cloud Platform のサンプルコードをそのまま利用しています。動くように修正してください。
# https://developers.google.com/tag-platform/tag-manager/api/v2/devguide?hl=ja
import argparse
import sys

import httplib2

from googleapiclient.discovery import build
from oauth2client import client
from oauth2client import file
from oauth2client import tools
from google.oauth2 import service_account


def GetService(api_name, api_version, scope, client_secrets_path):
    """Get a service that communicates to a Google API.

    Args:
      api_name: string The name of the api to connect to.
      api_version: string The api version to connect to.
      scope: A list of strings representing the auth scopes to authorize for the
        connection.
      client_secrets_path: string A path to a valid client secrets file.

    Returns:
      A service that is connected to the specified API.
    """
    # Parse command-line arguments.
    parser = argparse.ArgumentParser(
        formatter_class=argparse.RawDescriptionHelpFormatter,
        parents=[tools.argparser])
    flags = parser.parse_args([])

    # Set up a Flow object to be used if we need to authenticate.
    flow = client.flow_from_clientsecrets(
        client_secrets_path, scope=scope,
        message=tools.message_if_missing(client_secrets_path))

    # Prepare credentials, and authorize HTTP object with them.
    # If the credentials don't exist or are invalid run through the native client
    # flow. The Storage object will ensure that if successful the good
    # credentials will get written back to a file.
    storage = file.Storage(api_name + '.dat')
    credentials = storage.get()
    if credentials is None or credentials.invalid:
        credentials = tools.run_flow(flow, storage, flags)
    http = credentials.authorize(http=httplib2.Http())

    # Build the service object.
    service = build(api_name, api_version, http=http)

    return service


def FindGreetingsContainer(service, account_path):
    """Find the greetings container.

    Args:
      service: the Tag Manager service object.
      account_path: the path of the Tag Manager account from which to retrieve the
        Greetings container.

    Returns:
      The greetings container if it exists, or None if it does not.
    """
    # Query the Tag Manager API to list all containers for the given account.
    container_wrapper = service.accounts().containers().list(
        parent=account_path).execute()

    # Find and return the Greetings container if it exists.
    for container in container_wrapper['container']:
        if container['name'] == 'Greetings':
            return container
    return None


def main(argv):
    # Get tag manager account ID from command line.
    assert len(argv) == 2 and 'usage: gtm-api-hello-world.py <account_id>'
    account_id = str(argv[1])
    account_path = 'accounts/%s' % account_id

    # Define the auth scopes to request.
    scope = ['https://www.googleapis.com/auth/tagmanager.edit.containers']

    # Authenticate and construct service.
    service = GetService('tagmanager', 'v2', scope, 'client_secrets.json')
    # credentials: service_account.Credentials = service_account.Credentials.from_service_account_file(
    #     'service.json', scopes=scope)

    # Find the greetings container.
    container = FindGreetingsContainer(service, account_path)
    # http = credentials.authorize(http=httplib2.Http())
    # service = build('tagmanager', 'v2', http=httplib2.Http())
    # container = FindGreetingsContainer(service, account_path)

    print(container)


if __name__ == '__main__':
    main(sys.argv)
