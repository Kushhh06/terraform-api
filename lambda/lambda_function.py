import json
import boto3
import uuid

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('ArraySortLogsTF')

def lambda_handler(event, context):
    try:
        body = json.loads(event['body'])
        arr = body['array']

        # Validate: only 2-digit repeated digits (11, 22, etc.)
        for num in arr:
            if num < 10 or num > 99 or (num % 11 != 0):
                return {
                    'statusCode': 400,
                    'body': json.dumps({'error': 'Invalid input'})
                }

        sorted_arr = sorted(arr)

        request_id = str(uuid.uuid4())

        table.put_item(
            Item={
                'requestId': request_id,
                'input': arr,
                'output': sorted_arr
            }
        )

        return {
            'statusCode': 200,
            'body': json.dumps({'sorted_array': sorted_arr})
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }