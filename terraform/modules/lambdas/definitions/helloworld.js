exports.handler = async (event) => {
    const response = {
      statusCode: 200,
      body: JSON.stringify('Hello, World from AWS Lambda in Node.js 16.x!'),
    };
    return response;
  };
  