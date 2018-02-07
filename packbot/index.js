import axios from 'axios';

export const logical = ({ queryStringParameters: query, body }) => axios({
  method: 'post',
  url: 'https://getpocket.com/v3/add',
  headers: {
    'Content-Type': 'application/json; charset=UTF8',
    'X-Accept': 'application/json',
  },
  data: {
    consumer_key: query.consumerKey,
    access_token: query.accessToken,
    tags: body.tags,
    url: body.url,
  }
});

export const handler = (event, context, callback) => {
  const response = {
    statusCode: 200,
    body: JSON.stringify({
      message: 'Go Serverless v1.0! Your function executed successfully!',
      input: event,
    }),
  };

  callback(null, response);
};
