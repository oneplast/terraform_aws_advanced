module.exports.handler = async (event) => {
  console.log("Event: ", event);
  let responseMessage = "Hello, World!";
  const stage = process.env.STAGE || "unknown";

  return {
    statusCode: 200,
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      message: responseMessage,
      stage: stage,
    }),
  };
};

/** 대략 전달되는 형태
{
  "version": "2.0",
  "routeKey": "GET /",
  "rawPath": "/",
  "rawQueryString": "",
  "headers": {
    "host": "...",
    "user-agent": "..."
  },
  "requestContext": {
    "http": {
      "method": "GET",
      "path": "/"
    },
    "stage": "$default"
  }
}
*/
