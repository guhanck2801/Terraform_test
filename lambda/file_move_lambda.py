import json
import urllib.parse
import boto3

print('Loading function')
s3 = boto3.client('s3')

def lambda_handler(event, context):
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'], encoding='utf-8')
    
    destination_folder = 'processed'  # Change this to your desired folder name
    filename = key.split('/')[-1]
    destination_key = f'{destination_folder}/{filename}'
    
    try:
        # Copy the object to the new location
        s3.copy_object(
            Bucket=bucket,
            CopySource={'Bucket': bucket, 'Key': key},
            Key=destination_key
        )
        print(f"Copied {key} to {destination_key}")
        
        # Delete the original object
        s3.delete_object(Bucket=bucket, Key=key)
        print(f"Deleted original object {key}")
        
        return destination_key
    
    except Exception as e:
        print(e)
        print('Error moving object {} in bucket {}.'.format(key, bucket))
        raise e

