import json
import os
from datetime import datetime

USER_POOL_ID = os.environ.get('USER_POOL_ID', 'unknown')
ENVIRONMENT = os.environ.get('ENVIRONMENT', 'dev')

def handler(event, context):
    """
    API handler that processes authenticated requests
    Cognito user info available in event['requestContext']['authorizer']['claims']
    """
    try:
        # Extract claims from Cognito token
        authorizer = event.get('requestContext', {}).get('authorizer', {})
        claims = authorizer.get('claims', {})
        
        user_id = claims.get('sub', 'unknown')
        username = claims.get('cognito:username', 'unknown')
        email = claims.get('email', 'unknown')
        
        # Parse request body
        body = json.loads(event.get('body', '{}')) if event.get('body') else {}
        
        # Process request
        response_data = {
            'statusCode': 200,
            'message': f'Hello {username}!',
            'user_id': user_id,
            'email': email,
            'user_pool_id': USER_POOL_ID,
            'environment': ENVIRONMENT,
            'timestamp': datetime.utcnow().isoformat(),
            'received_data': body
        }
        
        return {
            'statusCode': 200,
            'body': json.dumps(response_data),
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            }
        }
        
    except Exception as e:
        print(f'Error: {str(e)}')
        return {
            'statusCode': 500,
            'body': json.dumps({
                'error': 'Internal server error',
                'message': str(e)
            }),
            'headers': {
                'Content-Type': 'application/json'
            }
        }