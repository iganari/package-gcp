import os
from google.cloud.devtools import cloudbuild_v1


def run_build_trigger(event, context):
    # Create a client
    client = cloudbuild_v1.CloudBuildClient()

    # Initialize request argument(s)
    request = cloudbuild_v1.RunBuildTriggerRequest(
        project_id = os.getenv('project_id'),
        trigger_id = os.getenv('trigger_id'),
    )

    # Check Event structure
    print('event is {}'.format(event))
    print('context is {}'.format(context))

    # Make the request
    operation = client.run_build_trigger(request=request)

    print("Waiting for operation to complete...")

    response = operation.result()

    # Handle the response
    print(response)

# if __name__ == "__main__":
#     run_build_trigger("x", "y")
