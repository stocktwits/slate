---
title: StockTwits API

language_tabs:
  - shell

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

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | No
Requires Authentication? | Yes
Requires Partner-Level Access? | No
Pagination? | 	No
HTTP Methods: | POST

### Parameters

Parameter | Description
--------- | -----------
client_id | The consumer key for the OAuth client.
response_type | The response type for the OAuth flow.
redirect_uri | The URI where StockTwits will redirect the user for authorization.
scope | 	A comma-delimited list of <a href='/#authorization-scopes'>scope permissions.</a>
prompt | Set to 1 to always prompt for authorization.

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

# Streams

<aside class="success">
The extended metadata in the API response below is only available through <a href='#'>Partner-Level Access.</a>
</aside>

## User Streams

```shell
curl https://api.stocktwits.com/api/2/streams/user/<username>.json
```

> Response

```json
{
  "user": {
    "id": 369117,
    "username": "ericalford",
    "name": "Eric Alford",
    "avatar_url": "http://avatars.stocktwits.com/production/369117/thumb-1447436971.png",
    "avatar_url_ssl": "https://s3.amazonaws.com/st-avatars/production/369117/thumb-1447436971.png",
    "join_date": "2014-06-27",
    "official": true
  },
  "cursor": {
    "more": true,
    "since": 60975379,
    "max": 54647845
  },
  "messages":[
    {
      "id": 60975379,
      "body": "@howardlindzon looking forward to it",
      "created_at": "2016-08-19T15:15:48Z",
      "user": {
        "id": 369117,
        "username": "ericalford",
        "name": "Eric Alford",
        "avatar_url": "http://avatars.stocktwits.com/production/369117/thumb-1447436971.png",
        "avatar_url_ssl": "https://s3.amazonaws.com/st-avatars/production/369117/thumb-1447436971.png",
        "join_date": "2014-06-27",
        "official": true
      },
      "conversation": {
        "parent_message_id": 60974422,
        "in_reply_to_message_id": 60975320,
        "parent": false,
        "replies": 5
      },
      "reshares": {
        "reshared_count": 0,
        "user_ids": []
      },
      "mentioned_users": [
        "@howardlindzon"
      ],
      "entities": {
        "sentiment": null
      }
    },
    {
      "id": 60899441,
      "body": "$TSLA good read about earnings: http://www.nasamoonhoax.com/tesla-post-earnings-analysis",
      "created_at": "2016-08-18T17:20:47Z",
      "user": {
        "id": 369117,
        "username": "ericalford",
        "name": "Eric Alford",
        "avatar_url": "http://avatars.stocktwits.com/production/369117/thumb-1447436971.png",
        "avatar_url_ssl": "https://s3.amazonaws.com/st-avatars/production/369117/thumb-1447436971.png",
        "join_date": "2014-06-27",
        "official": true
      },
      "symbols": [
        {
          "id": 8660,
          "symbol": "TSLA",
          "title": "Tesla Motors, Inc."
        }
      ],
      "reshares": {
        "reshared_count": 0,
        "user_ids": []
      },
      "mentioned_users": [],
      "entities": {
        "sentiment": null
      }
    },
    {
      "id": 60822179,
      "body": "Is this biotech rally just getting started?",
      "created_at": "2016-08-17T19:30:34Z",
      "user": {
        "id": 369117,
        "username": "ericalford",
        "name": "Eric Alford",
        "avatar_url": "http://avatars.stocktwits.com/production/369117/thumb-1447436971.png",
        "avatar_url_ssl": "https://s3.amazonaws.com/st-avatars/production/369117/thumb-1447436971.png",
        "join_date": "2014-06-27",
        "official": true
       },
      "conversation": {
        "parent_message_id": 60785036,
        "in_reply_to_message_id": 60785932,
        "parent": false,
        "replies": 2
      },
      "reshares": {
        "reshared_count": 0,
        "user_ids": []
      },
      "mentioned_users": [],
      "entities": {
        "sentiment": null
      }
    }
  ]
}
```

Returns the most recent 30 messages for the specified user. Includes the user object in response.

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | Yes
Requires Authentication? | No
Requires Partner-Level Access? | No
Pagination? | 	Yes
HTTP Methods: | GET

### Parameters

Parameter | Description
--------- | -----------
id | User ID or Username of the stream's user you want to show. (Required)
since | Returns results with an ID greater than (more recent than) the specified ID. (Mutually exclusive with max)
max | Returns results with an ID less than (older than) or equal to the specified ID. (Mutually exclusive with since)
limit | Default and max limit is 30. This limit must be a number under 30.
filter | Filter messages by links or charts. (Optional)

## Symbol Streams

```shell
curl https://api.stocktwits.com/api/2/streams/symbol/<symbol>.json
```

> Response

```json
{
  "symbol": {
    "id": 686,
    "symbol": "AAPL",
    "title": "Apple Inc."
  },
  "cursor": {
    "more": true,
    "since": 60975379,
    "max": 54647845
  },
  "messages":[
    {
      "id": 60975379,
      "body": "$AAPL going up from here",
      "created_at": "2016-08-19T15:15:48Z",
      "user": {
        "id": 369117,
        "username": "ericalford",
        "name": "Eric Alford",
        "avatar_url": "http://avatars.stocktwits.com/production/369117/thumb-1447436971.png",
        "avatar_url_ssl": "https://s3.amazonaws.com/st-avatars/production/369117/thumb-1447436971.png",
        "join_date": "2014-06-27",
        "official": true
      },
      "symbols": [
        {
          "id": 686,
          "symbol": "AAPL",
          "title": "Apple Inc."
        }
      ],
      "conversation": {
        "parent_message_id": 60974422,
        "in_reply_to_message_id": 60975320,
        "parent": false,
        "replies": 5
      },
      "reshares": {
        "reshared_count": 0,
        "user_ids": []
      },
      "mentioned_users": [],
      "entities": {
        "sentiment": null
      }
    },
    {
      "id": 60899441,
      "body": "$AAPL good read about earnings: http://www.media.com/aapl-post-earnings-analysis",
      "created_at": "2016-08-18T17:20:47Z",
      "user": {
        "id": 1036,
        "username": "zerobeta",
        "name": "Justin Paterno",
        "avatar_url": "http://avatars.stocktwits.com/production/369117/thumb-1447436971.png",
        "avatar_url_ssl": "https://s3.amazonaws.com/st-avatars/production/369117/thumb-1447436971.png",
        "join_date": "2011-03-17",
        "official": true
      },
      "symbols": [
        {
          "id": 686,
          "symbol": "AAPL",
          "title": "Apple Inc."
        }
      ],
      "reshares": {
        "reshared_count": 0,
        "user_ids": []
      },
      "mentioned_users": [],
      "entities": {
        "sentiment": null
      }
    },
    {
      "id": 60822179,
      "body": "Is this $AAPL rally just getting started?",
      "created_at": "2016-08-17T19:30:34Z",
      "user": {
        "id": 134,
        "username": "howardlindzon",
        "name": "Howard Lindzon",
        "avatar_url": "http://avatars.stocktwits.com/production/369117/thumb-1447436971.png",
        "avatar_url_ssl": "https://s3.amazonaws.com/st-avatars/production/369117/thumb-1447436971.png",
        "join_date": "2010-06-27",
        "official": true
       },
       "symbols": [
         {
           "id": 686,
           "symbol": "AAPL",
           "title": "Apple Inc."
         }
       ],
      "conversation": {
        "parent_message_id": 60785036,
        "in_reply_to_message_id": 60785932,
        "parent": false,
        "replies": 2
      },
      "reshares": {
        "reshared_count": 0,
        "user_ids": []
      },
      "mentioned_users": [],
      "entities": {
        "sentiment": null
      }
    }
  ]
}
```

Returns the most recent 30 messages for the specified symbol. Includes symbol object in response

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | Yes
Requires Authentication? | No
Requires Partner-Level Access? | No
Pagination? | 	Yes
HTTP Methods: | GET

### Parameters

Parameter | Description
--------- | -----------
id | 	Ticker symbol or Stock ID of the symbol (Required)
since | Returns results with an ID greater than (more recent than) the specified ID. (Mutually exclusive with max)
max | Returns results with an ID less than (older than) or equal to the specified ID. (Mutually exclusive with since)
limit | Default and max limit is 30. This limit must be a number under 30.
filter | Filter messages by links or charts. (Optional)

## Friends Stream

```shell
curl https://api.stocktwits.com/api/2/streams/friends.json /
  -H 'Authorization: Bearer <access_token>'
```

> Response

```json
{
  "cursor": {
    "more": true,
    "since": 60975379,
    "max": 54647845
  },
  "messages":[
    {
      "id": 60975379,
      "body": "$AAPL going up from here",
      "created_at": "2016-08-19T15:15:48Z",
      "user": {
        "id": 369117,
        "username": "ericalford",
        "name": "Eric Alford",
        "avatar_url": "http://avatars.stocktwits.com/production/369117/thumb-1447436971.png",
        "avatar_url_ssl": "https://s3.amazonaws.com/st-avatars/production/369117/thumb-1447436971.png",
        "join_date": "2014-06-27",
        "official": true
      },
      "symbols": [
        {
          "id": 686,
          "symbol": "AAPL",
          "title": "Apple Inc."
        }
      ],
      "conversation": {
        "parent_message_id": 60974422,
        "in_reply_to_message_id": 60975320,
        "parent": false,
        "replies": 5
      },
      "reshares": {
        "reshared_count": 0,
        "user_ids": []
      },
      "mentioned_users": [],
      "entities": {
        "sentiment": null
      }
    },
    {
      "id": 60899441,
      "body": "$AAPL good read about earnings: http://www.media.com/aapl-post-earnings-analysis",
      "created_at": "2016-08-18T17:20:47Z",
      "user": {
        "id": 1036,
        "username": "zerobeta",
        "name": "Justin Paterno",
        "avatar_url": "http://avatars.stocktwits.com/production/369117/thumb-1447436971.png",
        "avatar_url_ssl": "https://s3.amazonaws.com/st-avatars/production/369117/thumb-1447436971.png",
        "join_date": "2011-03-17",
        "official": true
      },
      "symbols": [
        {
          "id": 686,
          "symbol": "AAPL",
          "title": "Apple Inc."
        }
      ],
      "reshares": {
        "reshared_count": 0,
        "user_ids": []
      },
      "mentioned_users": [],
      "entities": {
        "sentiment": null
      }
    },
    {
      "id": 60822179,
      "body": "Is this $AAPL rally just getting started?",
      "created_at": "2016-08-17T19:30:34Z",
      "user": {
        "id": 134,
        "username": "howardlindzon",
        "name": "Howard Lindzon",
        "avatar_url": "http://avatars.stocktwits.com/production/369117/thumb-1447436971.png",
        "avatar_url_ssl": "https://s3.amazonaws.com/st-avatars/production/369117/thumb-1447436971.png",
        "join_date": "2010-06-27",
        "official": true
       },
       "symbols": [
         {
           "id": 686,
           "symbol": "AAPL",
           "title": "Apple Inc."
         }
       ],
      "conversation": {
        "parent_message_id": 60785036,
        "in_reply_to_message_id": 60785932,
        "parent": false,
        "replies": 2
      },
      "reshares": {
        "reshared_count": 0,
        "user_ids": []
      },
      "mentioned_users": [],
      "entities": {
        "sentiment": null
      }
    }
  ]
}
```

Returns the most recent 30 messages from the stream of the users they follow.

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | Yes
Requires Authentication? | Yes
Requires Partner-Level Access? | No
Pagination? | 	Yes
HTTP Methods: | GET

### Parameters

Parameter | Description
--------- | -----------
since | Returns results with an ID greater than (more recent than) the specified ID. (Mutually exclusive with max)
max | Returns results with an ID less than (older than) or equal to the specified ID. (Mutually exclusive with since)
limit | Default and max limit is 30. This limit must be a number under 30.
filter | Filter messages by links or charts. (Optional)

## Mentions Stream

```shell
curl https://api.stocktwits.com/api/2/streams/mentions.json /
  -H 'Authorization: Bearer <access_token>'
```

> Response

```json
{
  "cursor": {
    "more": true,
    "since": 60975379,
    "max": 54647845
  },
  "messages":[
    {
      "id": 60975379,
      "body": "@ericalford insiders also appear to be more bullish at the moment",
      "created_at": "2016-08-19T15:15:48Z",
      "user": {
        "id": 134,
        "username": "howardlindzon",
        "name": "Howard Lindzon",
        "avatar_url": "http://avatars.stocktwits.com/production/369117/thumb-1447436971.png",
        "avatar_url_ssl": "https://s3.amazonaws.com/st-avatars/production/369117/thumb-1447436971.png",
        "join_date": "2010-06-27",
        "official": true
       },
      "conversation": {
        "parent_message_id": 60974422,
        "in_reply_to_message_id": 60975320,
        "parent": false,
        "replies": 5
      },
      "reshares": {
        "reshared_count": 0,
        "user_ids": []
      },
      "mentioned_users": [
        "@ericalford"
      ],
      "entities": {
        "sentiment": null
      }
    },
    {
      "id": 60899441,
      "body": "@ericalford good read about earnings: http://www.media.com/aapl-post-earnings-analysis",
      "created_at": "2016-08-18T17:20:47Z",
      "user": {
        "id": 1036,
        "username": "zerobeta",
        "name": "Justin Paterno",
        "avatar_url": "http://avatars.stocktwits.com/production/369117/thumb-1447436971.png",
        "avatar_url_ssl": "https://s3.amazonaws.com/st-avatars/production/369117/thumb-1447436971.png",
        "join_date": "2011-03-17",
        "official": true
      },
      "symbols": [
        {
          "id": 686,
          "symbol": "AAPL",
          "title": "Apple Inc."
        }
      ],
      "reshares": {
        "reshared_count": 0,
        "user_ids": []
      },
      "mentioned_users": [
        "@ericalford"
      ],
      "entities": {
        "sentiment": null
      }
    },
    {
      "id": 60822179,
      "body": "@ericalford pay attention and follow the chart",
      "created_at": "2016-08-17T19:30:34Z",
      "user": {
        "id": 31736,
        "username": "tradermike",
        "name": "Michael Leinfort",
        "avatar_url": "http://avatars.stocktwits.com/production/369117/thumb-1447436971.png",
        "avatar_url_ssl": "https://s3.amazonaws.com/st-avatars/production/369117/thumb-1447436971.png",
        "join_date": "2010-06-27",
        "official": false
       },
      "conversation": {
        "parent_message_id": 60785036,
        "in_reply_to_message_id": 60785932,
        "parent": false,
        "replies": 2
      },
      "reshares": {
        "reshared_count": 0,
        "user_ids": []
      },
      "mentioned_users": [
        "@ericalford"
      ],
      "entities": {
        "sentiment": null
      }
    }
  ]
}
```

Returns the most recent 30 messages containing mentions of the authenticating user's handle. These are considered
public replies

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | Yes
Requires Authentication? | Yes
Requires Partner-Level Access? | No
Pagination? | 	Yes
HTTP Methods: | GET

### Parameters

Parameter | Description
--------- | -----------
since | Returns results with an ID greater than (more recent than) the specified ID. (Mutually exclusive with max)
max | Returns results with an ID less than (older than) or equal to the specified ID. (Mutually exclusive with since)
limit | Default and max limit is 30. This limit must be a number under 30.
filter | Filter messages by links or charts. (Optional)

## Watchlist Streams

```shell
curl https://api.stocktwits.com/api/2/streams/watchlist/:id.json /
  -H 'Authorization: Bearer <access_token>'
```

> Response

```json
{
  "watchlist": {
    "id": 12345,
    "name": "my picks",
    "updated_at": "2012-10-01 21:39:05 UTC",
    "created_at": "2012-09-24 21:39:05 UTC"
  },
  "cursor": {
    "more": true,
    "since": 60975379,
    "max": 54647845
  },
  "messages":[
    {
      "id": 60975379,
      "body": "$AAPL going up from here",
      "created_at": "2016-08-19T15:15:48Z",
      "user": {
        "id": 369117,
        "username": "ericalford",
        "name": "Eric Alford",
        "avatar_url": "http://avatars.stocktwits.com/production/369117/thumb-1447436971.png",
        "avatar_url_ssl": "https://s3.amazonaws.com/st-avatars/production/369117/thumb-1447436971.png",
        "join_date": "2014-06-27",
        "official": true
      },
      "symbols": [
        {
          "id": 686,
          "symbol": "AAPL",
          "title": "Apple Inc."
        }
      ],
      "conversation": {
        "parent_message_id": 60974422,
        "in_reply_to_message_id": 60975320,
        "parent": false,
        "replies": 5
      },
      "reshares": {
        "reshared_count": 0,
        "user_ids": []
      },
      "mentioned_users": [],
      "entities": {
        "sentiment": null
      }
    },
    {
      "id": 60899441,
      "body": "$TSLA good read about earnings: http://www.media.com/aapl-post-earnings-analysis",
      "created_at": "2016-08-18T17:20:47Z",
      "user": {
        "id": 1036,
        "username": "zerobeta",
        "name": "Justin Paterno",
        "avatar_url": "http://avatars.stocktwits.com/production/369117/thumb-1447436971.png",
        "avatar_url_ssl": "https://s3.amazonaws.com/st-avatars/production/369117/thumb-1447436971.png",
        "join_date": "2011-03-17",
        "official": true
      },
      "symbols": [
        {
          "id": 8660,
          "symbol": "TSLA",
          "title": "Tesla Motors, Inc."
        }
      ],
      "reshares": {
        "reshared_count": 0,
        "user_ids": []
      },
      "mentioned_users": [],
      "entities": {
        "sentiment": null
      }
    },
    {
      "id": 60822179,
      "body": "Is this $NFLX rally just getting started?",
      "created_at": "2016-08-17T19:30:34Z",
      "user": {
        "id": 134,
        "username": "howardlindzon",
        "name": "Howard Lindzon",
        "avatar_url": "http://avatars.stocktwits.com/production/369117/thumb-1447436971.png",
        "avatar_url_ssl": "https://s3.amazonaws.com/st-avatars/production/369117/thumb-1447436971.png",
        "join_date": "2010-06-27",
        "official": true
       },
       "symbols": [
         {
           "id": 947,
           "symbol": "NFLX",
           "title": "Netflix, Inc."
         }
       ],
      "conversation": {
        "parent_message_id": 60785036,
        "in_reply_to_message_id": 60785932,
        "parent": false,
        "replies": 2
      },
      "reshares": {
        "reshared_count": 0,
        "user_ids": []
      },
      "mentioned_users": [],
      "entities": {
        "sentiment": null
      }
    }
  ]
}
```

Returns the most recent 30 messages for the specified watch list for the authenticating user. The watch list is a
list of all the symbols a user is watching.

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | Yes
Requires Authentication? | Yes
Requires Partner-Level Access? | No
Pagination? | 	Yes
HTTP Methods: | GET

### Parameters

Parameter | Description
--------- | -----------
id | 	ID of the watch list you want to show from the authenticating user (Required)
since | Returns results with an ID greater than (more recent than) the specified ID. (Mutually exclusive with max)
max | Returns results with an ID less than (older than) or equal to the specified ID. (Mutually exclusive with since)
limit | Default and max limit is 30. This limit must be a number under 30.
filter | Filter messages by links or charts. (Optional)

## All Stream

```shell
curl https://api.stocktwits.com/api/2/streams/all.json /
  -H 'Authorization: Bearer <access_token>'
```

> Response

```json
{
  "cursor": {
    "more": true,
    "since": 60975379,
    "max": 54647845
  },
  "messages":[
    {
      "id": 60975379,
      "body": "$AAPL going up from here",
      "created_at": "2016-08-19T15:15:48Z",
      "user": {
        "id": 369117,
        "username": "ericalford",
        "name": "Eric Alford",
        "avatar_url": "http://avatars.stocktwits.com/production/369117/thumb-1447436971.png",
        "avatar_url_ssl": "https://s3.amazonaws.com/st-avatars/production/369117/thumb-1447436971.png",
        "join_date": "2014-06-27",
        "official": true,
        "followers": 166,
        "following": 119,
        "ideas": 397,
        "watchlist_stocks_count": 28,
        "like_count": 398,
        "subscribers_count": 3,
        "subscribed_to_count": 1,
        "location": "New York, NY",
        "bio": "Director of Engineering at StockTwits.",
        "website_url": "http://www.twitter.com/ericalford",
        "trading_strategy": {
          "assets_frequently_traded": [
            "Equities"
          ],
          "approach": "Momentum",
          "holding_period": "Swing Trader",
          "experience": "Intermediate"
        }
      },
      "symbols": [
        {
          "id": 686,
          "symbol": "AAPL",
          "title": "Apple Inc.",
          "exchange": "NASDAQ",
          "sector": null,
          "industry": null,
          "trending_score": -0.971114,
          "watchlist_count": 5576
        }
      ],
      "prices": [
        {
          "id": 12110,
          "symbol": "AAPL",
          "price": "99.34"
        }
      ],
      "conversation": {
        "parent_message_id": 60974422,
        "in_reply_to_message_id": 60975320,
        "parent": false,
        "replies": 5
      },
      "likes": {
        "total": 5,
        "user_ids": [
          234328,
          142981,
          376348,
          135156,
          93
        ]
      },
      "reshares": {
        "reshared_count": 0,
        "user_ids": []
      },
      "mentioned_users": [],
      "entities": {
        "sentiment": null
      }
    },
    {
      "id": 60899441,
      "body": "$TSLA good read about earnings: http://www.media.com/aapl-post-earnings-analysis",
      "created_at": "2016-08-18T17:20:47Z",
      "user": {
        "id": 1036,
        "username": "zerobeta",
        "name": "Justin Paterno",
        "avatar_url": "http://avatars.stocktwits.com/production/369117/thumb-1447436971.png",
        "avatar_url_ssl": "https://s3.amazonaws.com/st-avatars/production/369117/thumb-1447436971.png",
        "join_date": "2011-03-17",
        "official": true,
        "followers": 166,
        "following": 119,
        "ideas": 856,
        "watchlist_stocks_count": 32,
        "like_count": 398,
        "subscribers_count": 3,
        "subscribed_to_count": 1,
        "location": "New York, NY",
        "bio": "President at StockTwits. Tar Heel. Lover of markets.",
        "website_url": "http://justinpaterno.com",
        "trading_strategy": {
          "assets_frequently_traded": [
            "Equities"
          ],
          "approach": "Momentum",
          "holding_period": "Swing Trader",
          "experience": "Intermediate"
        }
      },
      "symbols": [
        {
          "id": 8660,
          "symbol": "TSLA",
          "title": "Tesla Motors, Inc.",
          "exchange": "NASDAQ",
          "sector": null,
          "industry": null,
          "trending_score": -0.971114,
          "watchlist_count": 5576
        }
      ],
      "prices": [
        {
          "id": 121135,
          "symbol": "TSLA",
          "price": "225.34"
        }
      ],
      "likes": {
        "total": 2,
        "user_ids": [
          234328,
          142981
        ]
      },
      "reshares": {
        "reshared_count": 0,
        "user_ids": []
      },
      "mentioned_users": [],
      "entities": {
        "sentiment": null
      }
    },
    {
      "id": 60822179,
      "body": "Is this $NFLX rally just getting started?",
      "created_at": "2016-08-17T19:30:34Z",
      "user": {
        "id": 134,
        "username": "howardlindzon",
        "name": "Howard Lindzon",
        "avatar_url": "http://avatars.stocktwits.com/production/369117/thumb-1447436971.png",
        "avatar_url_ssl": "https://s3.amazonaws.com/st-avatars/production/369117/thumb-1447436971.png",
        "join_date": "2010-06-27",
        "official": true,
        "followers": 168511,
        "following": 1635,
        "ideas": 112183,
        "watchlist_stocks_count": 135,
        "like_count": 3402,
        "subscribers_count": 334,
        "subscribed_to_count": 165,
        "location": "Coronado, CA",
        "bio": "Co-Founder and CEO of Stocktwits, Founder of Wallstrip (Acquired by CBS) &amp; Managing Member of Social Leverage (an early stage fund) ...I have lots of ideas. Toronto boy.",
        "website_url": "http://www.howardlindzon.com",
        "trading_strategy": {
          "assets_frequently_traded": [
            "Equities"
          ],
          "approach": "Momentum",
          "holding_period": "Swing Trader",
          "experience": "Intermediate"
        }
       },
       "symbols": [
         {
           "id": 947,
           "symbol": "NFLX",
           "title": "Netflix, Inc.",
           "exchange": "NASDAQ",
           "sector": "Services",
           "industry": "Music & Video Stores",
           "trending_score": -3.94541,
           "watchlist_count": 45951
         }
       ],
       "prices": [
         {
           "id": 121138,
           "symbol": "NFLX",
           "price": "95.82"
         }
       ],
      "conversation": {
        "parent_message_id": 60785036,
        "in_reply_to_message_id": 60785932,
        "parent": false,
        "replies": 2
      },
      "likes": {
        "total": 2,
        "user_ids": [
          234328,
          142981
        ]
      },
      "reshares": {
        "reshared_count": 0,
        "user_ids": []
      },
      "mentioned_users": [],
      "entities": {
        "sentiment": null
      }
    }
  ]
}
```

Returns the most recent 30 messages for all non-private symbols

<aside class="success">
This API end-point is only available through <a href='#'>Partner-Level Access.</a>
</aside>

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | Yes
Requires Authentication? | Yes
Requires Partner-Level Access? | Yes
Pagination? | 	Yes
HTTP Methods: | GET

### Parameters

Parameter | Description
--------- | -----------
since | Returns results with an ID greater than (more recent than) the specified ID. (Mutually exclusive with max)
max | Returns results with an ID less than (older than) or equal to the specified ID. (Mutually exclusive with since)
limit | Default and max limit is 30. This limit must be a number under 30.
filter | Filter messages by links or charts. (Optional)

## Chart Stream

```shell
curl https://api.stocktwits.com/api/2/streams/charts.json
```

> Response

```json
{
  "cursor": {
    "more": true,
    "since": 60975379,
    "max": 54647845
  },
  "messages":[
    {
      "id": 60975379,
      "body": "$AAPL going up from here",
      "created_at": "2016-08-19T15:15:48Z",
      "user": {
        "id": 369117,
        "username": "ericalford",
        "name": "Eric Alford",
        "avatar_url": "http://avatars.stocktwits.com/production/369117/thumb-1447436971.png",
        "avatar_url_ssl": "https://s3.amazonaws.com/st-avatars/production/369117/thumb-1447436971.png",
        "join_date": "2014-06-27",
        "official": true
      },
      "symbols": [
        {
          "id": 686,
          "symbol": "AAPL",
          "title": "Apple Inc."
        }
      ],
      "conversation": {
        "parent_message_id": 60974422,
        "in_reply_to_message_id": 60975320,
        "parent": false,
        "replies": 5
      },
      "reshares": {
        "reshared_count": 0,
        "user_ids": []
      },
      "mentioned_users": [],
      "entities": {
        "chart": {
          "thumb": "http://charts.stocktwits.com/production/small_61042991.png",
          "large": "http://charts.stocktwits.com/production/large_61042991.png",
          "original": "http://charts.stocktwits.com/production/original_61042991.",
          "url": "http://charts.stocktwits.com/production/original_61042991."
        },
        "sentiment": null
      }
    },
    {
      "id": 60899441,
      "body": "$TSLA good read about earnings: http://www.media.com/aapl-post-earnings-analysis",
      "created_at": "2016-08-18T17:20:47Z",
      "user": {
        "id": 1036,
        "username": "zerobeta",
        "name": "Justin Paterno",
        "avatar_url": "http://avatars.stocktwits.com/production/369117/thumb-1447436971.png",
        "avatar_url_ssl": "https://s3.amazonaws.com/st-avatars/production/369117/thumb-1447436971.png",
        "join_date": "2011-03-17",
        "official": true
      },
      "symbols": [
        {
          "id": 8660,
          "symbol": "TSLA",
          "title": "Tesla Motors, Inc."
        }
      ],
      "reshares": {
        "reshared_count": 0,
        "user_ids": []
      },
      "mentioned_users": [],
      "entities": {
        "chart": {
          "thumb": "http://charts.stocktwits.com/production/small_61042989.png",
          "large": "http://charts.stocktwits.com/production/large_61042989.png",
          "original": "http://charts.stocktwits.com/production/original_61042989.png",
          "url": "http://charts.stocktwits.com/production/original_61042989.png"
        },
        "sentiment": null
      }
    },
    {
      "id": 60822179,
      "body": "Is this $NFLX rally just getting started?",
      "created_at": "2016-08-17T19:30:34Z",
      "user": {
        "id": 134,
        "username": "howardlindzon",
        "name": "Howard Lindzon",
        "avatar_url": "http://avatars.stocktwits.com/production/369117/thumb-1447436971.png",
        "avatar_url_ssl": "https://s3.amazonaws.com/st-avatars/production/369117/thumb-1447436971.png",
        "join_date": "2010-06-27",
        "official": true
       },
       "symbols": [
         {
           "id": 947,
           "symbol": "NFLX",
           "title": "Netflix, Inc."
         }
       ],
      "conversation": {
        "parent_message_id": 60785036,
        "in_reply_to_message_id": 60785932,
        "parent": false,
        "replies": 2
      },
      "reshares": {
        "reshared_count": 0,
        "user_ids": []
      },
      "mentioned_users": [],
      "entities": {
        "chart": {
          "thumb": "http://charts.stocktwits.com/production/small_61042973.png",
          "large": "http://charts.stocktwits.com/production/large_61042973.png",
          "original": "http://charts.stocktwits.com/production/original_61042973.",
          "url": "http://charts.stocktwits.com/production/original_61042973."
        },
        "sentiment": null
      }
    }
  ]
}
```

Returns the most recent 30 messages that include charts/images.

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | Yes
Requires Authentication? | No
Requires Partner-Level Access? | No
Pagination? | 	Yes
HTTP Methods: | GET

### Parameters

Parameter | Description
--------- | -----------
since | Returns results with an ID greater than (more recent than) the specified ID. (Mutually exclusive with max)
max | Returns results with an ID less than (older than) or equal to the specified ID. (Mutually exclusive with since)
limit | Default and max limit is 30. This limit must be a number under 30.
filter | Filter messages by links or charts. (Optional)

## Equities Stream

```shell
curl https://api.stocktwits.com/api/2/streams/equities.json /
  -H 'Authorization: Bearer <access_token>'
```

> Response

```json
{
  "cursor": {
    "more": true,
    "since": 60975379,
    "max": 54647845
  },
  "messages":[
    {
      "id": 60975379,
      "body": "$AAPL going up from here",
      "created_at": "2016-08-19T15:15:48Z",
      "user": {
        "id": 369117,
        "username": "ericalford",
        "name": "Eric Alford",
        "avatar_url": "http://avatars.stocktwits.com/production/369117/thumb-1447436971.png",
        "avatar_url_ssl": "https://s3.amazonaws.com/st-avatars/production/369117/thumb-1447436971.png",
        "join_date": "2014-06-27",
        "official": true,
        "followers": 166,
        "following": 119,
        "ideas": 397,
        "watchlist_stocks_count": 28,
        "like_count": 398,
        "subscribers_count": 3,
        "subscribed_to_count": 1,
        "location": "New York, NY",
        "bio": "Director of Engineering at StockTwits.",
        "website_url": "http://www.twitter.com/ericalford",
        "trading_strategy": {
          "assets_frequently_traded": [
            "Equities"
          ],
          "approach": "Momentum",
          "holding_period": "Swing Trader",
          "experience": "Intermediate"
        }
      },
      "symbols": [
        {
          "id": 686,
          "symbol": "AAPL",
          "title": "Apple Inc.",
          "exchange": "NASDAQ",
          "sector": null,
          "industry": null,
          "trending_score": -0.971114,
          "watchlist_count": 5576
        }
      ],
      "prices": [
        {
          "id": 12110,
          "symbol": "AAPL",
          "price": "99.34"
        }
      ],
      "conversation": {
        "parent_message_id": 60974422,
        "in_reply_to_message_id": 60975320,
        "parent": false,
        "replies": 5
      },
      "likes": {
        "total": 5,
        "user_ids": [
          234328,
          142981,
          376348,
          135156,
          93
        ]
      },
      "reshares": {
        "reshared_count": 0,
        "user_ids": []
      },
      "mentioned_users": [],
      "entities": {
        "sentiment": null
      }
    },
    {
      "id": 60899441,
      "body": "$TSLA good read about earnings: http://www.media.com/aapl-post-earnings-analysis",
      "created_at": "2016-08-18T17:20:47Z",
      "user": {
        "id": 1036,
        "username": "zerobeta",
        "name": "Justin Paterno",
        "avatar_url": "http://avatars.stocktwits.com/production/369117/thumb-1447436971.png",
        "avatar_url_ssl": "https://s3.amazonaws.com/st-avatars/production/369117/thumb-1447436971.png",
        "join_date": "2011-03-17",
        "official": true,
        "followers": 166,
        "following": 119,
        "ideas": 856,
        "watchlist_stocks_count": 32,
        "like_count": 398,
        "subscribers_count": 3,
        "subscribed_to_count": 1,
        "location": "New York, NY",
        "bio": "President at StockTwits. Tar Heel. Lover of markets.",
        "website_url": "http://justinpaterno.com",
        "trading_strategy": {
          "assets_frequently_traded": [
            "Equities"
          ],
          "approach": "Momentum",
          "holding_period": "Swing Trader",
          "experience": "Intermediate"
        }
      },
      "symbols": [
        {
          "id": 8660,
          "symbol": "TSLA",
          "title": "Tesla Motors, Inc.",
          "exchange": "NASDAQ",
          "sector": null,
          "industry": null,
          "trending_score": -0.971114,
          "watchlist_count": 5576
        }
      ],
      "prices": [
        {
          "id": 121135,
          "symbol": "TSLA",
          "price": "225.34"
        }
      ],
      "likes": {
        "total": 2,
        "user_ids": [
          234328,
          142981
        ]
      },
      "reshares": {
        "reshared_count": 0,
        "user_ids": []
      },
      "mentioned_users": [],
      "entities": {
        "sentiment": null
      }
    },
    {
      "id": 60822179,
      "body": "Is this $NFLX rally just getting started?",
      "created_at": "2016-08-17T19:30:34Z",
      "user": {
        "id": 134,
        "username": "howardlindzon",
        "name": "Howard Lindzon",
        "avatar_url": "http://avatars.stocktwits.com/production/369117/thumb-1447436971.png",
        "avatar_url_ssl": "https://s3.amazonaws.com/st-avatars/production/369117/thumb-1447436971.png",
        "join_date": "2010-06-27",
        "official": true,
        "followers": 168511,
        "following": 1635,
        "ideas": 112183,
        "watchlist_stocks_count": 135,
        "like_count": 3402,
        "subscribers_count": 334,
        "subscribed_to_count": 165,
        "location": "Coronado, CA",
        "bio": "Co-Founder and CEO of Stocktwits, Founder of Wallstrip (Acquired by CBS) &amp; Managing Member of Social Leverage (an early stage fund) ...I have lots of ideas. Toronto boy.",
        "website_url": "http://www.howardlindzon.com",
        "trading_strategy": {
          "assets_frequently_traded": [
            "Equities"
          ],
          "approach": "Momentum",
          "holding_period": "Swing Trader",
          "experience": "Intermediate"
        }
       },
       "symbols": [
         {
           "id": 947,
           "symbol": "NFLX",
           "title": "Netflix, Inc.",
           "exchange": "NASDAQ",
           "sector": "Services",
           "industry": "Music & Video Stores",
           "trending_score": -3.94541,
           "watchlist_count": 45951
         }
       ],
       "prices": [
         {
           "id": 121138,
           "symbol": "NFLX",
           "price": "95.82"
         }
       ],
      "conversation": {
        "parent_message_id": 60785036,
        "in_reply_to_message_id": 60785932,
        "parent": false,
        "replies": 2
      },
      "likes": {
        "total": 2,
        "user_ids": [
          234328,
          142981
        ]
      },
      "reshares": {
        "reshared_count": 0,
        "user_ids": []
      },
      "mentioned_users": [],
      "entities": {
        "sentiment": null
      }
    }
  ]
}
```

Returns the most recent 30 messages containing equity symbols. This will not include futures or forex messages.

<aside class="success">
This API end-point is only available through <a href='#'>Partner-Level Access.</a>
</aside>

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | Yes
Requires Authentication? | Yes
Requires Partner-Level Access? | Yes
Pagination? | 	Yes
HTTP Methods: | GET

### Parameters

Parameter | Description
--------- | -----------
since | Returns results with an ID greater than (more recent than) the specified ID. (Mutually exclusive with max)
max | Returns results with an ID less than (older than) or equal to the specified ID. (Mutually exclusive with since)
limit | Default and max limit is 30. This limit must be a number under 30.
filter | Filter messages by links or charts. (Optional)

## Forex Stream

```shell
curl https://api.stocktwits.com/api/2/streams/forex.json /
  -H 'Authorization: Bearer <access_token>'
```

> Response

```json
{
  "cursor":{
    "more": true,
    "since": 61043580,
    "max":61043542
  },
  "messages":[
    {
      "id":61043580,
      "body":"USD may range trade > http://elliottwave-forecast.com/amember/go.php?r=567&amp;i=l26 $EURUSD $USDX #elliottwave #trading #forex",
      "created_at":"2016-08-20T22:56:53Z",
      "user":{
        "id":194101,
        "username":"AidanFX",
        "name":"Aidan Chan",
        "avatar_url":"http://avatars.stocktwits.com/production/194101/thumb-1352414928.png",
        "avatar_url_ssl":"https://s3.amazonaws.com/st-avatars/production/194101/thumb-1352414928.png",
        "join_date":"2012-11-08",
        "official":false,
        "followers":226,
        "following":1,
        "ideas":241,
        "watchlist_stocks_count":0,
        "like_count":0,
        "subscribers_count":8,
        "subscribed_to_count":0,
        "location":"Toronto, Canada",
        "bio":"Full-time Trader, Technical Analyst",
        "website_url":"http://elliottwave-forecast.com/amember/go.php?r=567&i=l1",
        "trading_strategy":{
          "assets_frequently_traded":[
            "Forex"
          ],
          "approach":"Technical",
          "holding_period":"Swing Trader",
          "experience":"Professional"
        }
      },
      "symbols":[
        {
          "id":667,
          "symbol":"EURUSD",
          "title":"Euro / US Dollar",
          "exchange":"FX",
          "sector":null,
          "industry":null,
          "trending_score":-2.76072,
          "watchlist_count":8979
        },
        {
          "id":7883,
          "symbol":"USDX",
          "title":"US Dollar Index",
          "exchange":"INDEX",
          "sector":null,
          "industry":null,
          "trending_score":-1.86232,
          "watchlist_count":1175
        }
      ],
      "prices":[
        {
          "id":667,
          "symbol":"EURUSD",
          "price":"1.1326"
        }
      ],
      "links":[
        {
          "title":"Forex Archives - Elliott Wave Forecast",
          "url":"http://elliottwave-forecast.com/amember/go.php?r=567&i=l26",
          "shortened_expanded_url":"elliottwave-forecast.com/fo...",
          "description":"Preferred Elliott wave count suggests that rally to 0.776 ended wave ((w)) and wave ((x)) pullback is proposed complete at 0.7673. Rally from there is unfolding as a double three where wave w ended at 0.7723 and while wave x pullback stays above 0.7606, expect pair to resume higher.",
          "image":"http://elliottwave-forecast.com/wp-content/uploads/2016/08/USDCAD-flat-blog2-150x150.jpg",
          "created_at":"2016-08-20T22:56:56Z",
          "source":{
            "name":"Elliott Wave Forecast",
            "website":"http://elliottwave-forecast.com"
          }
        }
      ],
      "reshares":{
        "reshared_count":0,
        "user_ids":[]
      },
      "mentioned_users":[],
      "entities":{
        "sentiment":null
      }
    },
    {
      "id":61043542,
      "body":"Elliott wave Theory: Is the Impulse count in $GBPUSD right? > http://elliottwave-forecast.com/amember/go.php?r=567&i=l25 #elliottwave #trading #forex",
      "created_at":"2016-08-20T22:55:01Z",
      "user":{
        "id":194101,
        "username":"AidanFX",
        "name":"Aidan Chan",
        "avatar_url":"http://avatars.stocktwits.com/production/194101/thumb-1352414928.png",
        "avatar_url_ssl":"https://s3.amazonaws.com/st-avatars/production/194101/thumb-1352414928.png",
        "join_date":"2012-11-08",
        "official":false,
        "followers":226,
        "following":1,
        "ideas":241,
        "watchlist_stocks_count":0,
        "like_count":0,
        "subscribers_count":8,
        "subscribed_to_count":0,
        "location":"Toronto, Canada",
        "bio":"Full-time Trader, Technical Analyst",
        "website_url":"http://elliottwave-forecast.com/amember/go.php?r=567&i=l1",
        "trading_strategy":{
          "assets_frequently_traded":[
            "Forex"
          ],
          "approach":"Technical",
          "holding_period":"Swing Trader",
          "experience":"Professional"
        }
      },
      "symbols":[
        {
          "id":670,
          "symbol":"GBPUSD",
          "title":"British Pound / US Dollar",
          "exchange":"FX",
          "sector":null,
          "industry":null,
          "trending_score":-3.71637,
          "watchlist_count":4975
        }
      ],
      "prices":[
        {
          "id":670,
          "symbol":"GBPUSD",
          "price":"1.3077"
        }
      ],
      "links":[
        {
          "title":"Elliottwave Archives - Elliott Wave Forecast",
          "url":"http://elliottwave-forecast.com/amember/go.php?r=567&i=l25",
          "shortened_expanded_url":"elliottwave-forecast.com/el...",
          "description":"The Elliott wave Theory was developed in 1930 and of course the most popular pattern is the 5 waves advance and 3 waves back to correct the advance or decline. Since the Theory was developed the Marketplace has changed some as well as the charting tools we have at our disposal now.",
          "image":"http://elliottwave-forecast.com/wp-content/uploads/2016/08/USDCAD-flat-blog2-150x150.jpg",
          "created_at":"2016-08-20T22:54:59Z",
          "source":{
            "name":"Elliott Wave Forecast",
            "website":"http://elliottwave-forecast.com"
          }
        }
      ],
      "likes":{
        "total":1,
        "user_ids":[
          787465
        ]
      },
      "reshares":{
        "reshared_count":0,
        "user_ids":[]
      },
      "mentioned_users":[],
      "entities":{
        "sentiment":null
      }
    }
  ]
}
```

Returns the most recent 30 messages for forex symbols. Example $EURUSD

<aside class="success">
This API end-point is only available through <a href='#'>Partner-Level Access.</a>
</aside>

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | Yes
Requires Authentication? | Yes
Requires Partner-Level Access? | Yes
Pagination? | 	Yes
HTTP Methods: | GET

### Parameters

Parameter | Description
--------- | -----------
since | Returns results with an ID greater than (more recent than) the specified ID. (Mutually exclusive with max)
max | Returns results with an ID less than (older than) or equal to the specified ID. (Mutually exclusive with since)
limit | Default and max limit is 30. This limit must be a number under 30.
filter | Filter messages by links or charts. (Optional)

## Futures Stream

```shell
curl https://api.stocktwits.com/api/2/streams/futures.json /
  -H 'Authorization: Bearer <access_token>'
```

> Response

```json
{
  "cursor":{
    "more":true,
    "since":61044927,
    "max":61044675
  },
  "messages":[
    {
      "id":61044927,
      "body":"$SPY $SPX $ES_F Perfect elipse support lines: setup for downside",
      "created_at":"2016-08-21T00:21:25Z",
      "user":{
        "id":544617,
        "username":"slv587",
        "name":"slv587",
        "avatar_url":"http://avatars.stocktwits.com/production/544617/thumb-1437956496.png",
        "avatar_url_ssl":"https://s3.amazonaws.com/st-avatars/production/544617/thumb-1437956496.png",
        "join_date":"2015-07-04",
        "official":false,
        "followers":24,
        "following":82,
        "ideas":934,
        "watchlist_stocks_count":25,
        "like_count":575,
        "subscribers_count":1,
        "subscribed_to_count":0,
        "location":"",
        "bio":null,
        "website_url":null,
        "trading_strategy":{
          "assets_frequently_traded":[],
          "approach":null,
          "holding_period":null,
          "experience":null
        }
      },
      "symbols":[
        {
          "id":647,
          "symbol":"ES_F",
          "title":"E-Mini S&P 500 Futures",
          "exchange":"CME",
          "sector":null,
          "industry":null,
          "trending_score":-7.7983,
          "watchlist_count":5974
        },
        {
          "id":679,
          "symbol":"SPX",
          "title":"S&P 500 Index",
          "exchange":"INDEX",
          "sector":null,
          "industry":null,
          "trending_score":-12.312,
          "watchlist_count":12551
        },
        {
          "id":7271,
          "symbol":"SPY",
          "title":"SPDR S&P 500",
          "exchange":"NYSEArca",
          "sector":"Financial",
          "industry":"Exchange Traded Fund",
          "trending_score":-11.3105,
          "watchlist_count":36029
        }
      ],
      "prices":[
        {
          "id":679,
          "symbol":"SPX",
          "price":"2183.87"
        },
        {
          "id":7271,
          "symbol":"SPY",
          "price":"218.69"
        }
      ],
      "conversation":{
        "parent_message_id":61044927,
        "in_reply_to_message_id":null,
        "parent":true,
        "replies":1
      },
      "reshares":{
        "reshared_count":0,
        "user_ids":[]
      },
      "mentioned_users":[],
      "entities":{
        "chart":{
          "thumb":"http://charts.stocktwits.com/production/small_61044927.png",
          "large":"http://charts.stocktwits.com/production/large_61044927.png",
          "original":"http://charts.stocktwits.com/production/original_61044927.",
          "url":"http://charts.stocktwits.com/production/original_61044927."
        },
        "sentiment":{
          "basic":"Bearish"
        }
      }
    },
    {
      "id":61044675,
      "body":"$SPY $VXX $SPX $ES_F Various Fibs at work - interesting Sept.ahead: http://eepurl.com/ccktCL",
      "created_at":"2016-08-21T00:05:27Z",
      "user":{
        "id":719714,
        "username":"CycleVolume",
        "name":"Donald Pendergast",
        "avatar_url":"http://avatars.stocktwits.com/production/719714/thumb-1459626201.png",
        "avatar_url_ssl":"https://s3.amazonaws.com/st-avatars/production/719714/thumb-1459626201.png",
        "join_date":"2016-04-02",
        "official":false,
        "followers":22,
        "following":152,
        "ideas":336,
        "watchlist_stocks_count":16,
        "like_count":235,
        "subscribers_count":1,
        "subscribed_to_count":0,
        "location":"",
        "bio":"Build your savings with compound interest and dollar-cost averaging into S&amp;P 500 index funds, allocating a much smaller portion for speculative trading in the financial markets.",
        "website_url":null,
        "trading_strategy":{
          "assets_frequently_traded":[

          ],
          "approach":null,
          "holding_period":null,
          "experience":null
        }
      },
      "symbols":[
        {
          "id":647,
          "symbol":"ES_F",
          "title":"E-Mini S&P 500 Futures",
          "exchange":"CME",
          "sector":null,
          "industry":null,
          "trending_score":-8.51434,
          "watchlist_count":5974
        },
        {
          "id":679,
          "symbol":"SPX",
          "title":"S&P 500 Index",
          "exchange":"INDEX",
          "sector":null,
          "industry":null,
          "trending_score":-11.5855,
          "watchlist_count":12551
        },
        {
          "id":7271,
          "symbol":"SPY",
          "title":"SPDR S&P 500",
          "exchange":"NYSEArca",
          "sector":"Financial",
          "industry":"Exchange Traded Fund",
          "trending_score":-11.5034,
          "watchlist_count":36028
        },
        {
          "id":7693,
          "symbol":"VXX",
          "title":"iPath S&P 500 VIX Short-Term Futures ETN",
          "exchange":"NYSEArca",
          "sector":"Financial",
          "industry":"Exchange Traded Fund",
          "trending_score":-6.93213,
          "watchlist_count":8697
        }
      ],
      "prices":[
        {
          "id":679,
          "symbol":"SPX",
          "price":"2183.87"
        },
        {
          "id":7271,
          "symbol":"SPY",
          "price":"218.69"
        },
        {
          "id":7693,
          "symbol":"VXX",
          "price":"36.16"
        }
      ],
      "links":[
        {
          "title":"VXX-Plus Trade Signals Service Update 8/20/16",
          "url":"http://eepurl.com/ccktCL",
          "shortened_expanded_url":"us10.campaign-archive1.com/...",
          "description":"XBPTrading.com to help you improve your trading performance; I've tried every kind of software and indicator there is since 1999, and these volume referred Jordi I XBPTrading.com!",
          "image":null,
          "created_at":"2016-08-21T00:05:28Z",
          "source":{
            "name":"Campaign-archive1",
            "website":"http://us10.campaign-archive1.com"
          }
        }
      ],
      "reshares":{
        "reshared_count":0,
        "user_ids":[]
      },
      "mentioned_users":[],
      "entities":{
        "chart":{
          "thumb":"http://charts.stocktwits.com/production/small_61044675.png",
          "large":"http://charts.stocktwits.com/production/large_61044675.png",
          "original":"http://charts.stocktwits.com/production/original_61044675.",
          "url":"http://charts.stocktwits.com/production/original_61044675."
        },
        "sentiment":null
      }
    }
  ]
}
```

Returns the most recent 30 messages for futures symbols. Example $ES_F

<aside class="success">
This API end-point is only available through <a href='#'>Partner-Level Access.</a>
</aside>

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | Yes
Requires Authentication? | Yes
Requires Partner-Level Access? | Yes
Pagination? | 	Yes
HTTP Methods: | GET

### Parameters

Parameter | Description
--------- | -----------
since | Returns results with an ID greater than (more recent than) the specified ID. (Mutually exclusive with max)
max | Returns results with an ID less than (older than) or equal to the specified ID. (Mutually exclusive with since)
limit | Default and max limit is 30. This limit must be a number under 30.
filter | Filter messages by links or charts. (Optional)

## Private Companies Stream

```shell
curl https://api.stocktwits.com/api/2/streams/private_companies.json /
  -H 'Authorization: Bearer <access_token>'
```

> Response

```json
{
  "cursor":{
    "more":true,
    "since":61037328,
    "max":61032162
  },
  "messages":[
    {
      "id":61037328,
      "body":"Detroit Hiring Talent in Silicon Valley for Race Against Google $F $GM $UBER $GOOGL via Bloomberg http://bloom.bg/2aV7ZNn",
      "created_at":"2016-08-20T17:09:26Z",
      "user":{
        "id":687940,
        "username":"SpeedyCalls",
        "name":"$peedy Calls",
        "avatar_url":"http://avatars.stocktwits.com/production/687940/thumb-1465664155.png",
        "avatar_url_ssl":"https://s3.amazonaws.com/st-avatars/production/687940/thumb-1465664155.png",
        "join_date":"2016-02-13",
        "official":false,
        "followers":3177,
        "following":26,
        "ideas":20065,
        "watchlist_stocks_count":1,
        "like_count":237,
        "subscribers_count":168,
        "subscribed_to_count":0,
        "location":"",
        "bio":"HFT OptionScanner Backtesting AlgoTrading. Follow @SpeedyCalls for the fastest EquityAlerts OptionAlerts & Market observations. Not advice or recommendations.",
        "website_url":null,
        "trading_strategy":{
          "assets_frequently_traded":[],
          "approach":null,
          "holding_period":null,
          "experience":null
        }
      },
      "symbols":[
        {
          "id":5281,
          "symbol":"F",
          "title":"Ford Motor Co.",
          "exchange":"NYSE",
          "sector":"Consumer Goods",
          "industry":"Auto Manufacturers - Major",
          "trending_score":-2.04847,
          "watchlist_count":16341
        },
        {
          "id":9358,
          "symbol":"GM",
          "title":"General Motors Company",
          "exchange":"NYSE",
          "sector":"Consumer Goods",
          "industry":"Auto Manufacturers - Major",
          "trending_score":-0.652748,
          "watchlist_count":6931
        },
        {
          "id":11554,
          "symbol":"UBER",
          "title":"Uber",
          "exchange":"PRIVATE",
          "sector":null,
          "industry":null,
          "trending_score":-0.545158,
          "watchlist_count":2083
        },
        {
          "id":11938,
          "symbol":"GOOGL",
          "title":"Alphabet Inc. Class A",
          "exchange":"NASDAQ",
          "sector":null,
          "industry":null,
          "trending_score":-3.46033,
          "watchlist_count":15002
        }
      ],
      "prices":[
        {
          "id":5281,
          "symbol":"F",
          "price":"12.40"
        },
        {
          "id":9358,
          "symbol":"GM",
          "price":"31.84"
        },
        {
          "id":11938,
          "symbol":"GOOGL",
          "price":"799.65"
        }
      ],
      "links":[
        {
          "title":"Detroit Hiring Talent in Silicon Valley for Race Against Google",
          "url":"http://bloom.bg/2aV7ZNn",
          "shortened_expanded_url":"bloomberg.com/news/articles...",
          "description":"For the first time in America's industrial history, the center for automotive technology is drifting away from Detroit. Ford Motor Co., aiming to put fully autonomous vehicles into the economy by 2021, announced that it's doubling the size of its office in Silicon Valley to 260 people and investing in four companies that are key to building self-driving cars.",
          "image":"http://assets.bwbx.io/images/users/iqjWHBFdfxIU/i1BEvotOAx2U/v5/-999x-999.jpg",
          "created_at":"2016-08-20T17:09:26Z",
          "source":{
            "name":"Bloomberg.com",
            "website":"http://www.bloomberg.com"
          }
        }
      ],
      "likes":{
        "total":1,
        "user_ids":[
          787465
        ]
      },
      "reshares":{
        "reshared_count":0,
        "user_ids":[]
      },
      "mentioned_users":[],
      "entities":{
        "sentiment":null
      }
    },
    {
      "id":61032162,
      "body":"There's real money in messaging, Snapchat and WeChat show $SNAP $FB via CNBC http://www.cnbc.com/id/103881313",
      "created_at":"2016-08-20T12:18:25Z",
      "user":{
        "id":687940,
        "username":"SpeedyCalls",
        "name":"$peedy Calls",
        "avatar_url":"http://avatars.stocktwits.com/production/687940/thumb-1465664155.png",
        "avatar_url_ssl":"https://s3.amazonaws.com/st-avatars/production/687940/thumb-1465664155.png",
        "join_date":"2016-02-13",
        "official":false,
        "followers":3171,
        "following":25,
        "ideas":20056,
        "watchlist_stocks_count":1,
        "like_count":231,
        "subscribers_count":168,
        "subscribed_to_count":0,
        "location":"",
        "bio":"HFT OptionScanner Backtesting AlgoTrading. Follow @SpeedyCalls for the fastest EquityAlerts OptionAlerts & Market observations. Not advice or recommendations.",
        "website_url":null,
        "trading_strategy":{
          "assets_frequently_traded":[],
          "approach":null,
          "holding_period":null,
          "experience":null
        }
      },
      "source":{
        "id":1149,
        "title":"StockTwits for iOS",
        "url":"http://www.stocktwits.com/mobile"
      },
      "symbols":[
        {
          "id":7871,
          "symbol":"FB",
          "title":"Facebook",
          "exchange":"NASDAQ",
          "sector":"Technology",
          "industry":"Internet Information Providers",
          "trending_score":-3.05995,
          "watchlist_count":59004
        },
        {
          "id":11746,
          "symbol":"SNAP",
          "title":"Snapchat",
          "exchange":"PRIVATE",
          "sector":null,
          "industry":null,
          "trending_score":0,
          "watchlist_count":967
        }
      ],
      "prices":[
        {
          "id":7871,
          "symbol":"FB",
          "price":"123.56"
        }
      ],
      "links":[
        {
          "title":"There's real money in messaging, Snapchat and WeChat show",
          "url":"http://www.cnbc.com/id/103881313",
          "shortened_expanded_url":"cnbc.com/2016/08/19/theres-...",
          "description":"The week's news showed how Snapchat and WeChat have cemented their place in the ranks of big tech, investors told CNBC. Snapchat was in the spotlight this week after it reportedly bought search and discovery app Vurb for over $100 million, according to technology news site The Information.",
          "image":"http://fm.cnbc.com/applications/cnbc.com/staticcontent/img/cnbc_logo.gif",
          "created_at":"2016-08-20T12:18:27Z",
          "source":{
            "name":"CNBC",
            "website":"http://www.cnbc.com"
          }
        }
      ],
      "likes":{
        "total":1,
        "user_ids":[
          787465
        ]
      },
      "reshares":{
        "reshared_count":0,
        "user_ids":[]
      },
      "mentioned_users":[],
      "entities":{
        "sentiment":null
      }
    }
  ]
}
```

Returns the most recent 30 messages containing private symbols. Example $UBER

<aside class="success">
This API end-point is only available through <a href='#'>Partner-Level Access.</a>
</aside>

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | Yes
Requires Authentication? | Yes
Requires Partner-Level Access? | Yes
Pagination? | 	Yes
HTTP Methods: | GET

### Parameters

Parameter | Description
--------- | -----------
since | Returns results with an ID greater than (more recent than) the specified ID. (Mutually exclusive with max)
max | Returns results with an ID less than (older than) or equal to the specified ID. (Mutually exclusive with since)
limit | Default and max limit is 30. This limit must be a number under 30.
filter | Filter messages by links or charts. (Optional)

## Suggested Stream

```shell
curl https://api.stocktwits.com/api/2/streams/suggested.json
```

> Response

```json
{
  "cursor": {
    "more": true,
    "since": 60975379,
    "max": 54647845
  },
  "messages":[
    {
      "id": 60975379,
      "body": "$AAPL going up from here",
      "created_at": "2016-08-19T15:15:48Z",
      "user": {
        "id": 369117,
        "username": "ericalford",
        "name": "Eric Alford",
        "avatar_url": "http://avatars.stocktwits.com/production/369117/thumb-1447436971.png",
        "avatar_url_ssl": "https://s3.amazonaws.com/st-avatars/production/369117/thumb-1447436971.png",
        "join_date": "2014-06-27",
        "official": true
      },
      "symbols": [
        {
          "id": 686,
          "symbol": "AAPL",
          "title": "Apple Inc."
        }
      ],
      "conversation": {
        "parent_message_id": 60974422,
        "in_reply_to_message_id": 60975320,
        "parent": false,
        "replies": 5
      },
      "reshares": {
        "reshared_count": 0,
        "user_ids": []
      },
      "mentioned_users": [],
      "entities": {
        "sentiment": null
      }
    },
    {
      "id": 60899441,
      "body": "$TSLA good read about earnings: http://www.media.com/aapl-post-earnings-analysis",
      "created_at": "2016-08-18T17:20:47Z",
      "user": {
        "id": 1036,
        "username": "zerobeta",
        "name": "Justin Paterno",
        "avatar_url": "http://avatars.stocktwits.com/production/369117/thumb-1447436971.png",
        "avatar_url_ssl": "https://s3.amazonaws.com/st-avatars/production/369117/thumb-1447436971.png",
        "join_date": "2011-03-17",
        "official": true
      },
      "symbols": [
        {
          "id": 8660,
          "symbol": "TSLA",
          "title": "Tesla Motors, Inc."
        }
      ],
      "reshares": {
        "reshared_count": 0,
        "user_ids": []
      },
      "mentioned_users": [],
      "entities": {
        "sentiment": null
      }
    },
    {
      "id": 60822179,
      "body": "Is this $NFLX rally just getting started?",
      "created_at": "2016-08-17T19:30:34Z",
      "user": {
        "id": 134,
        "username": "howardlindzon",
        "name": "Howard Lindzon",
        "avatar_url": "http://avatars.stocktwits.com/production/369117/thumb-1447436971.png",
        "avatar_url_ssl": "https://s3.amazonaws.com/st-avatars/production/369117/thumb-1447436971.png",
        "join_date": "2010-06-27",
        "official": true
       },
       "symbols": [
         {
           "id": 947,
           "symbol": "NFLX",
           "title": "Netflix, Inc."
         }
       ],
      "conversation": {
        "parent_message_id": 60785036,
        "in_reply_to_message_id": 60785932,
        "parent": false,
        "replies": 2
      },
      "reshares": {
        "reshared_count": 0,
        "user_ids": []
      },
      "mentioned_users": [],
      "entities": {
        "sentiment": null
      }
    }
  ]
}
```

Returns the most recent 30 messages from our suggested users, a curated list of quality StockTwits contributors.

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | Yes
Requires Authentication? | No
Requires Partner-Level Access? | No
Pagination? | 	Yes
HTTP Methods: | GET

### Parameters

Parameter | Description
--------- | -----------
since | Returns results with an ID greater than (more recent than) the specified ID. (Mutually exclusive with max)
max | Returns results with an ID less than (older than) or equal to the specified ID. (Mutually exclusive with since)
limit | Default and max limit is 30. This limit must be a number under 30.
filter | Filter messages by links or charts. (Optional)

## Symbols Stream

```shell
curl https://api.stocktwits.com/api/2/streams/symbols.json /
  -H 'Authorization: Bearer <access_token>' /
  -d 'symbols=AAPL,TSLA,NFLX'
```

> Response

```json
{
  "cursor": {
    "more": true,
    "since": 60975379,
    "max": 54647845
  },
  "messages":[
    {
      "id": 60975379,
      "body": "$AAPL going up from here",
      "created_at": "2016-08-19T15:15:48Z",
      "user": {
        "id": 369117,
        "username": "ericalford",
        "name": "Eric Alford",
        "avatar_url": "http://avatars.stocktwits.com/production/369117/thumb-1447436971.png",
        "avatar_url_ssl": "https://s3.amazonaws.com/st-avatars/production/369117/thumb-1447436971.png",
        "join_date": "2014-06-27",
        "official": true
      },
      "symbols": [
        {
          "id": 686,
          "symbol": "AAPL",
          "title": "Apple Inc."
        }
      ],
      "conversation": {
        "parent_message_id": 60974422,
        "in_reply_to_message_id": 60975320,
        "parent": false,
        "replies": 5
      },
      "reshares": {
        "reshared_count": 0,
        "user_ids": []
      },
      "mentioned_users": [],
      "entities": {
        "sentiment": null
      }
    },
    {
      "id": 60899441,
      "body": "$TSLA good read about earnings: http://www.media.com/aapl-post-earnings-analysis",
      "created_at": "2016-08-18T17:20:47Z",
      "user": {
        "id": 1036,
        "username": "zerobeta",
        "name": "Justin Paterno",
        "avatar_url": "http://avatars.stocktwits.com/production/369117/thumb-1447436971.png",
        "avatar_url_ssl": "https://s3.amazonaws.com/st-avatars/production/369117/thumb-1447436971.png",
        "join_date": "2011-03-17",
        "official": true
      },
      "symbols": [
        {
          "id": 8660,
          "symbol": "TSLA",
          "title": "Tesla Motors, Inc."
        }
      ],
      "reshares": {
        "reshared_count": 0,
        "user_ids": []
      },
      "mentioned_users": [],
      "entities": {
        "sentiment": null
      }
    },
    {
      "id": 60822179,
      "body": "Is this $NFLX rally just getting started?",
      "created_at": "2016-08-17T19:30:34Z",
      "user": {
        "id": 134,
        "username": "howardlindzon",
        "name": "Howard Lindzon",
        "avatar_url": "http://avatars.stocktwits.com/production/369117/thumb-1447436971.png",
        "avatar_url_ssl": "https://s3.amazonaws.com/st-avatars/production/369117/thumb-1447436971.png",
        "join_date": "2010-06-27",
        "official": true
       },
       "symbols": [
         {
           "id": 947,
           "symbol": "NFLX",
           "title": "Netflix, Inc."
         }
       ],
      "conversation": {
        "parent_message_id": 60785036,
        "in_reply_to_message_id": 60785932,
        "parent": false,
        "replies": 2
      },
      "reshares": {
        "reshared_count": 0,
        "user_ids": []
      },
      "mentioned_users": [],
      "entities": {
        "sentiment": null
      }
    }
  ]
}
```

Returns the most recent 30 messages for the specified list of symbols. Up to 10 symbols allowed.

<aside class="success">
This API end-point is only available through <a href='#'>Partner-Level Access.</a>
</aside>

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | Yes
Requires Authentication? | Yes
Requires Partner-Level Access? | Yes
Pagination? | 	Yes
HTTP Methods: | GET

### Parameters

Parameter | Description
--------- | -----------
symbols | List of multiple Ticker symbols or Stock IDs. Max 10 (Required)
since | Returns results with an ID greater than (more recent than) the specified ID. (Mutually exclusive with max)
max | Returns results with an ID less than (older than) or equal to the specified ID. (Mutually exclusive with since)
limit | Default and max limit is 30. This limit must be a number under 30.
filter | Filter messages by links or charts. (Optional)

## Trending Stream

```shell
curl https://api.stocktwits.com/api/2/streams/trending.json
```

> Response

```json
{
  "cursor": {
    "more": true,
    "since": 60975379,
    "max": 54647845
  },
  "messages":[
    {
      "id": 60975379,
      "body": "$AAPL going up from here",
      "created_at": "2016-08-19T15:15:48Z",
      "user": {
        "id": 369117,
        "username": "ericalford",
        "name": "Eric Alford",
        "avatar_url": "http://avatars.stocktwits.com/production/369117/thumb-1447436971.png",
        "avatar_url_ssl": "https://s3.amazonaws.com/st-avatars/production/369117/thumb-1447436971.png",
        "join_date": "2014-06-27",
        "official": true
      },
      "symbols": [
        {
          "id": 686,
          "symbol": "AAPL",
          "title": "Apple Inc."
        }
      ],
      "conversation": {
        "parent_message_id": 60974422,
        "in_reply_to_message_id": 60975320,
        "parent": false,
        "replies": 5
      },
      "reshares": {
        "reshared_count": 0,
        "user_ids": []
      },
      "mentioned_users": [],
      "entities": {
        "sentiment": null
      }
    },
    {
      "id": 60899441,
      "body": "$TSLA good read about earnings: http://www.media.com/aapl-post-earnings-analysis",
      "created_at": "2016-08-18T17:20:47Z",
      "user": {
        "id": 1036,
        "username": "zerobeta",
        "name": "Justin Paterno",
        "avatar_url": "http://avatars.stocktwits.com/production/369117/thumb-1447436971.png",
        "avatar_url_ssl": "https://s3.amazonaws.com/st-avatars/production/369117/thumb-1447436971.png",
        "join_date": "2011-03-17",
        "official": true
      },
      "symbols": [
        {
          "id": 8660,
          "symbol": "TSLA",
          "title": "Tesla Motors, Inc."
        }
      ],
      "reshares": {
        "reshared_count": 0,
        "user_ids": []
      },
      "mentioned_users": [],
      "entities": {
        "sentiment": null
      }
    },
    {
      "id": 60822179,
      "body": "Is this $NFLX rally just getting started?",
      "created_at": "2016-08-17T19:30:34Z",
      "user": {
        "id": 134,
        "username": "howardlindzon",
        "name": "Howard Lindzon",
        "avatar_url": "http://avatars.stocktwits.com/production/369117/thumb-1447436971.png",
        "avatar_url_ssl": "https://s3.amazonaws.com/st-avatars/production/369117/thumb-1447436971.png",
        "join_date": "2010-06-27",
        "official": true
       },
       "symbols": [
         {
           "id": 947,
           "symbol": "NFLX",
           "title": "Netflix, Inc."
         }
       ],
      "conversation": {
        "parent_message_id": 60785036,
        "in_reply_to_message_id": 60785932,
        "parent": false,
        "replies": 2
      },
      "reshares": {
        "reshared_count": 0,
        "user_ids": []
      },
      "mentioned_users": [],
      "entities": {
        "sentiment": null
      }
    }
  ]
}
```

Returns the most recent 30 messages with trending symbols in the last 5 minutes.

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | Yes
Requires Authentication? | No
Requires Partner-Level Access? | No
Pagination? | 	Yes
HTTP Methods: | GET

### Parameters

Parameter | Description
--------- | -----------
since | Returns results with an ID greater than (more recent than) the specified ID. (Mutually exclusive with max)
max | Returns results with an ID less than (older than) or equal to the specified ID. (Mutually exclusive with since)
limit | Default and max limit is 30. This limit must be a number under 30.
filter | Filter messages by links or charts. (Optional)