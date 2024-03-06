# Use an official Python runtime as a parent image
FROM python:3.8-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Run the sentiment analysis application
CMD ["python", "sentiment_analysis.py"]


aws lambda update-function-configuration \
    --function-name SentimentAnalysisFunction \
    --environment Variables="{AWS_REGION=us-east-1, COMPREHEND_ENDPOINT_URL=https://comprehend-custom-endpoint-url}"
