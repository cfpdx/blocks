const AWS = require('aws-sdk');
const s3 = new AWS.S3();

exports.handler = async (event) => {
  try {
    const { Bucket, Key } = event;
    
    // Perform an S3 GET request
    const response = await s3.getObject({ Bucket, Key }).promise();
    
    // Return the S3 object data to the Lambda caller
    return {
      statusCode: 200,
      body: JSON.stringify(response),
    };
  } catch (error) {
    console.error('Error:', error);
    
    // Return an error response
    return {
      statusCode: 500,
      body: JSON.stringify({ message: 'Internal Server Error' }),
    };
  }
};
