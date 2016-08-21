# Response & Error Codes

The StockTwits API attempts to return appropriate HTTP status codes for every request. The following table describes
the codes which may appear when working with the API:

Code | Meaning
---------- | -------
200 | Success
204 | Success. No content returned
400 | Bad Request -- Your request sucks
401 | Unauthorized -- The access toke provided is invalid or it is missing
403 | Forbidden -- The access token provided lacks the corresponding permission scope
404 | Not Found
418 | I'm a teapot
429 | Too Many Requests -- You've been <a href='/?shell#rate-limiting'>rate limited</a>
500 | Internal Server Error -- We had a problem with our server. Try again later.
503 | Service Unavailable -- We're temporarily offline for maintenance. Please try again later.
504 | Gateway Timeout
