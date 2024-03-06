# import the JSON utility package
import json

# import the AWS SDK (for Python the package name is boto3)
import boto3

# import two packages to help us with dates and date formatting
from time import gmtime, strftime

# create a DynamoDB object using the AWS SDK
dynamodb = boto3.resource('dynamodb')

# use the DynamoDB object to select our table
table = dynamodb.Table('Team-Helm')

# store the current time in a human readable format in a variable
now = strftime("%a, %d %b %Y %H:%M:%S +0000", gmtime())

def lambda_handler(event, context):
    # Extract text input from the event
    text = event['text']
    
    # Initialize the Amazon Comprehend client
    comprehend = boto3.client('comprehend')
    
    # Detect sentiment of the input text
    response = comprehend.detect_sentiment(Text=text, LanguageCode='en')
    
    # Extract sentiment results from the response
    sentiment = response['Sentiment']

    # Write sentiment analysis results to DynamoDB
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('Team-Helm')
    table.put_item(
        Item={
            'text': text,
            'sentiment': sentiment
        }
    )

    # Construct the response to the user
    response_message = f"The sentiment of the text is {sentiment}."
    
    return {
        'statusCode': 200,
        'body': response_message
    }
