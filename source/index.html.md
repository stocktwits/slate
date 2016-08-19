---
title: StockTwits API

language_tabs:
  - shell
  - javascript

toc_footers:
  - <a href='http://stocktwits.com/developers/apps/new'>Register your App</a>
  - <a href='#'>Register for Firehose</a>

includes:
  - errors

search: true
---

# Introduction

The StockTwits RESTful API allows you to leverage the user base, social graph and content network that drive the
StockTwits community.

Your application and your users can access the StockTwits social graph, display curated data streams, integrate watch
lists, and easily share messages, links and charts directly from your application.

The StockTwits API is perfect for financial applications/websites/apps that want or need a social layer.

<aside class="notice">
All requests must be SSL
</aside>

# Rate Limiting

The StockTwits API only allows clients to make a limited number of calls in a given hour. This policy affects the APIs in different ways.

## Default API Rate Limiting

The default rate limit for calls to the API varies depending on the authorization method being used and whether the
method itself requires authentication.

**Unauthenticated** calls are permitted 200 requests per hour and measured against the public facing IP of the server or
device making the request.

**Authenticated** calls are permitted 400 requests per hour and measured against the access token used in the request.

All StockTwits API responses return a set of rate limit HTTP headers.
These headers provide the limit, remaining amount of requests for that limit, and a UNIX timestamp of when the rate
limit resets again.

`X-RateLimit-Limit: 200`

`X-RateLimit-Remaining: 146`

`X-RateLimit-Reset: 1345147112`

## Rate Limits and Errors

Error responses are rate limited against either the authenticated or unauthenticated rate limit depending on where the
error occurs. Unauthenticated responses will typically return a HTTP 400 or 401 status code.

Rate limits are applied to methods that request information with the HTTP GET or HEAD method.
Generally API methods that use HTTP POST to submit data to StockTwits are not rate limited.
Every method in the API documentation displays if it is rate limited or not.

Actions such as publishing messages, sending direct messages, following and unfollowing users are not directly rate
limited by the API but are subject to fair use limits.

> The following is a sample rate limited response:

```json
{
  "errors": [{
    "message": "Rate limit exceeded. Client may not make more than N requests an hour."
  }]
}
```

### If you are rate limited

If your application is being rate-limited it will receive HTTP 429 response code.
It is best practice for applications to monitor their current rate limit status and dynamically throttle requests.

###Blacklisting

We ask that you honor the rate limits. If you or your application abuses the rate limits we will be forced to suspend
and or blacklist it. If you are blacklisted you will be unable to get a response from the StockTwits API.

If you or your application has been blacklisted and you think there has been an error you can contact us via
<a href='mailto:api@stocktwits.com'>email for support.</a>

## Partner API

If your application requires extended data or a higher rate limit, you may want to consider becoming a partner. Please contact our team for more information.

# Authentication

StockTwits uses OAuth 2.0 for authentication and authorization.
OAuth 2.0 is a popular open standard used by many API providers.
OAuth 2.0 allows users to authorize your application without sharing their username and password.
<a href='http://oauth.net/'>Learn more about OAuth</a>

The StockTwits API allows you to get permission from a StockTwits user to access user data on their behalf.
By default, your application can only access the user's public data.
If your application needs to read more private data or change associated data, your application can request a larger
permission scope through the authorization flow.

##Obtaining an Access Token

> Enter the following URL into your browser or direct your users to it for authentication:

```shell
https://api.stocktwits.com/api/2/oauth/authorize?client_id=<client_id>&response_type=code&redirect_uri=http://www.example.com&scope=read,watch_lists,publish_messages,publish_watch_lists,direct_messages,follow_users
```

> StockTwits will prompt an authentication box asking the user whether it's okay to give access to your application.
If the user authorizes your application, StockTwits redirects the user back to the redirect URI you specified with a
verification code.

```shell
http://www.example.com?code=<verification_code>
```

> This code can then be exchanged for an access token.

```shell
curl https://api.stocktwits.com/api/2/oauth/token /
  -X POST \
  -H 'Content-Type: application/json' \
  -d '{"client_id": "<client id>", "client_secret": "<client secret>", "code": "<code>", "grant_type": "authorization_code", "redirect_uri": "http://www.example.com"}'
```

> The above request returns JSON structured like this:

```json
{
  "user_id": 1,
  "access_token": "<access_token>",
  "scope": "read",
  "username": "userabc"
}
```

<a href='http://stocktwits.com/developers/apps/new'>Register your application</a> to get an API key and secret.
Your API consumer key is your `client_id` and you API consumer secret is your `client_secret`.

Your application requests authorization by redirecting your user to

`https://api.stocktwits.com/api/2/oauth/authorize`

with your `client_id`, `response_type` set to `code` and the URL the user should be redirected back to after the
authorization process as `redirect_uri`.
Scopes can also be passed as `scope` in a comma-delimited list to request further permissions.
See the different scopes in the Authorization Scopes section below.

###Performing authenticated requests

Once you receive an access token, you may use it to make authenticated API requests to the StockTwits API.
The token should be passed as an HTTP Authorization header and not as a query parameter.
You may want to store this access token; this access token will not refresh, so you can use it indefinitely on behalf
of the authenticated user.

> Authenticated requests can be performed by attaching the access token as the authorization header

```shell
curl https://api.stocktwits.com/api/2/streams/friends.json /
  -H 'Authorization: Bearer <access_token>'
```

## Authorization Scopes

By default, when authorizing your application, a user only grants your app access to their basic public information.
If you want to read additional data or write data to StockTwits, you need to request additional permissions.

Scope | Default | Description
--------- | ------- | -----------
read | true | Allows to read user, symbol and authenticated streams, read social graph of people and stocks.
watch_lists | false | Read a users watch lists.
publish_watch_lists | false | Publish to a users watch lists
publish_messages | false | Publish messages for a user.
direct_messages | false | Read a users direct messages.
follow_users | false | Follow other users
notifications | false | Read a users notifications

<aside class="notice">
Remember — If you need to perform actions on behalf of a user and the corresponding scope is not granted, you will need
to re-authenticate the user to continue that action.
</aside>

# Kittens

## Get All Kittens

```ruby
require 'kittn'

api = Kittn::APIClient.authorize!('meowmeowmeow')
api.kittens.get
```

```python
import kittn

api = kittn.authorize('meowmeowmeow')
api.kittens.get()
```

```shell
curl "http://example.com/api/kittens"
  -H "Authorization: meowmeowmeow"
```

```javascript
const kittn = require('kittn');

let api = kittn.authorize('meowmeowmeow');
let kittens = api.kittens.get();
```

> The above command returns JSON structured like this:

```json
[
  {
    "id": 1,
    "name": "Fluffums",
    "breed": "calico",
    "fluffiness": 6,
    "cuteness": 7
  },
  {
    "id": 2,
    "name": "Max",
    "breed": "unknown",
    "fluffiness": 5,
    "cuteness": 10
  }
]
```

This endpoint retrieves all kittens.

### HTTP Request

`GET http://example.com/api/kittens`

### Query Parameters

Parameter | Default | Description
--------- | ------- | -----------
include_cats | false | If set to true, the result will also include cats.
available | true | If set to false, the result will include kittens that have already been adopted.

<aside class="success">
Remember — a happy kitten is an authenticated kitten!
</aside>

## Get a Specific Kitten

```ruby
require 'kittn'

api = Kittn::APIClient.authorize!('meowmeowmeow')
api.kittens.get(2)
```

```python
import kittn

api = kittn.authorize('meowmeowmeow')
api.kittens.get(2)
```

```shell
curl "http://example.com/api/kittens/2"
  -H "Authorization: meowmeowmeow"
```

```javascript
const kittn = require('kittn');

let api = kittn.authorize('meowmeowmeow');
let max = api.kittens.get(2);
```

> The above command returns JSON structured like this:

```json
{
  "id": 2,
  "name": "Max",
  "breed": "unknown",
  "fluffiness": 5,
  "cuteness": 10
}
```

This endpoint retrieves a specific kitten.

<aside class="warning">Inside HTML code blocks like this one, you can't use Markdown, so use <code>&lt;code&gt;</code> blocks to denote code.</aside>

### HTTP Request

`GET http://example.com/kittens/<ID>`

### URL Parameters

Parameter | Description
--------- | -----------
ID | The ID of the kitten to retrieve

