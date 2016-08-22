---
title: StockTwits API

language_tabs:
  - shell

toc_footers:
  - <a href='http://stocktwits.com/developers/apps/new'>Register your App</a>
  - <a href='mailto:firehose@stocktwits.com'>Register for Firehose</a>

includes:
  - errors
  - widgets
  - buttons
  - logos
  - terms_conditions

search: true
---

# Introduction

The StockTwits RESTful API allows you to leverage the user base, social graph and content network that drive the
StockTwits community.

Your application and your users can access the StockTwits social graph, display curated data streams, integrate watch
lists, and easily share messages, links and charts directly from your application.

The StockTwits API is perfect for financial applications/websites that want or need a social layer.

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

Rate limits are applied to endpoints that request information with the HTTP GET or HEAD method.
Generally API endpoints that use HTTP POST to submit data to StockTwits are not rate limited.
Every endpoint in the API documentation displays if it is rate limited or not.

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

If your application is being rate-limited, it will receive HTTP 429 response code.
It is best practice for applications to monitor their current rate limit status and dynamically throttle requests.

###Blacklisting

We ask that you honor the rate limits. If you or your application abuses the rate limits we will be forced to suspend
and or blacklist it. If you are blacklisted you will be unable to get a response from the StockTwits API.

If you or your application has been blacklisted and you think there has been an error you can contact us via
<a href='mailto:api@stocktwits.com'>email for support.</a>

## Partner API

If your application requires extended data or a higher rate limit, you may want to consider becoming a partner.
Please [contact our team](mailto:api@stocktwits.com) for more information.

#Parameters & Pagination

##Parameters

Some API endpoints take optional or required parameters. When making requests with parameters, values should be
converted to <a href='http://en.wikipedia.org/wiki/UTF-8'>UTF-8</a> and URL encoded.

##Pagintation

> Example of a paginated request

```shell
curl https://api.stocktwits.com/api/2/streams/friends.json \
  -H 'Authorization: Bearer <access_token>' \
  -d 'max=60975380'
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

Clients may access a theoretical maximum of 800 messages via the cursor parameters for the API endpoints.
Requests for more than the limit will result in a reply with a status code of 200 and an empty result in the format
requested. StockTwits still maintains a database of all the messages sent by a user.
However, to ensure performance of the site, this artificial limit is temporarily in place.

There are two main parameters when paginating through results.

**Since** will return results with an ID greater than (more recent than) the specified ID. Use this when getting new
results or messages to a stream.

**Max** will return results with an ID less than (older than) the specified ID. Use this to get older
results or messages that have previously been published.

#Counting Characters

StockTwits limits all message lengths to 140 characters. URLs and images affect the length of the message. Any message
over 140 characters will return an error response.

##Character Encoding
The StockTwits API supports UTF-8 encoding and any UTF-8 character counts as a single character. Please note that
angle brackets ("<" and ">") are entity-encoded to prevent Cross-Site Scripting attacks for web-embedded consumers of
JSON API output. The resulting encoded entities do count towards the 140 character limit. Symbols and characters
outside of the standard ASCII range may be translated to HTML entities.

**URL/Links** such as "http://stocktwits.com" will represent "23" characters in the message length. Links are defined as
having a protocol such as "http://" or "https://".

**Charts/Images** will represent "24" characters in the message length.

#Content Display Requirements

##Content

1. Do not modify, edit or otherwise change the message content as passed through the API, except as needed to reformat
for technical limitations of your specific service.
2. All $TICKER cashtags within each message must be hyperlinked and point to the StockTwits ticker page at
[http://www.stocktwits.com/symbol/](http://www.stocktwits.com/symbol/).
3. All @mentions within each message must be hyperlinked and point to the StockTwits user page for the mentioned user
at [http://www.stocktwits.com/](http://www.stocktwits.com/).
4. Messages should be presented with a timestamp, either in absolute (May 1, 2012 3:30pm) or relative (1 hour ago)
format. The timestamp should be linked to the message display page on StockTwits at
[http://www.stocktwits.com/message/](http://www.stocktwits.com/message/).
5. If you choose to display media objects passed within the API in your application; such as a chart image,
the object must be hyperlinked and point to the message display page on StockTwits at
[http://www.stocktwits.com/message/](http://www.stocktwits.com/message/).

##Author and Attribution

1. The StockTwits user’s name must be presented as the author of the content, using either the user’s StockTwits user
name or user name and full name. The name should be linked to the user’s StockTwits profile page at
[http://www.stocktwits.com/](http://www.stocktwits.com/).
2. The user’s name should be presented in a way to distinguish it from the message content.
3. Display of the user’s avatar is recommended, but not required. If displayed, the user’s avatar should also be linked
to the StockTwits user page for the user.

##Message Interactions

1. You may include Reply, Reshare, and Like action links using the StockTwits web intents, if so they should be used
consistently across all messages for authenticated StockTwits users.
2. You cannot include third party interactions with StockTwits messages.

##Branding

1. It must always be apparent to the user that they are looking at a StockTwits message.
2. Any StockTwits messages displayed individually or as part of a stream labeled with a StockTwits logo adjacent to the
message or stream. Logos and buttons are available via our [logo page](#stocktwits-logos). Whenever possible, StockTwits logos should link
to [http://stocktwits.com](http://stocktwits.com).

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
curl https://api.stocktwits.com/api/2/oauth/token \
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
Pagination? | No
HTTP Methods: | POST

### Parameters

Parameter | Description
--------- | -----------
client_id | The consumer key for the OAuth client.
response_type | The response type for the OAuth flow.
redirect_uri | The URI where StockTwits will redirect the user for authorization.
scope | 	A comma-delimited list of [scope permissions.](#authorization-scopes)
prompt | Set to 1 to always prompt for authorization.

###Performing authenticated requests

Once you receive an access token, you may use it to make authenticated API requests to the StockTwits API.
The token should be passed as an HTTP Authorization header and not as a query parameter.
You may want to store this access token; this access token will not refresh, so you can use it indefinitely on behalf
of the authenticated user.

> Authenticated requests can be performed by attaching the access token as the authorization header

```shell
curl https://api.stocktwits.com/api/2/streams/friends.json \
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
to re-authenticate the user with that scope to continue that action.
</aside>

# Streams

<aside class="success">
All endpoints that require [Partner-Level Access](mailto:api@stocktwits.com) includes extended metadata. To receive extended access,
please contact us about becoming a partner.
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
Pagination? | Yes
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
Pagination? | Yes
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
curl https://api.stocktwits.com/api/2/streams/friends.json \
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
Pagination? | Yes
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
curl https://api.stocktwits.com/api/2/streams/mentions.json \
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
Pagination? | Yes
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
curl https://api.stocktwits.com/api/2/streams/watchlist/:id.json \
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
Pagination? | Yes
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
curl https://api.stocktwits.com/api/2/streams/all.json \
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
This API end-point is only available through [Partner-Level Access.](mailto:api@stocktwits.com)
</aside>

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | Yes
Requires Authentication? | Yes
Requires Partner-Level Access? | Yes
Pagination? | Yes
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
Pagination? | Yes
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
curl https://api.stocktwits.com/api/2/streams/equities.json \
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
This API end-point is only available through [Partner-Level Access.](mailto:api@stocktwits.com)
</aside>

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | Yes
Requires Authentication? | Yes
Requires Partner-Level Access? | Yes
Pagination? | Yes
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
curl https://api.stocktwits.com/api/2/streams/forex.json \
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
This API end-point is only available through [Partner-Level Access.](mailto:api@stocktwits.com)
</aside>

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | Yes
Requires Authentication? | Yes
Requires Partner-Level Access? | Yes
Pagination? | Yes
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
curl https://api.stocktwits.com/api/2/streams/futures.json \
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
This API end-point is only available through [Partner-Level Access.](mailto:api@stocktwits.com)
</aside>

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | Yes
Requires Authentication? | Yes
Requires Partner-Level Access? | Yes
Pagination? | Yes
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
curl https://api.stocktwits.com/api/2/streams/private_companies.json \
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
This API end-point is only available through [Partner-Level Access.](mailto:api@stocktwits.com)
</aside>

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | Yes
Requires Authentication? | Yes
Requires Partner-Level Access? | Yes
Pagination? | Yes
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
Pagination? | Yes
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
curl https://api.stocktwits.com/api/2/streams/symbols.json \
  -H 'Authorization: Bearer <access_token>' \
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
This API end-point is only available through [Partner-Level Access.](mailto:api@stocktwits.com)
</aside>

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | Yes
Requires Authentication? | Yes
Requires Partner-Level Access? | Yes
Pagination? | Yes
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
Pagination? | Yes
HTTP Methods: | GET

### Parameters

Parameter | Description
--------- | -----------
since | Returns results with an ID greater than (more recent than) the specified ID. (Mutually exclusive with max)
max | Returns results with an ID less than (older than) or equal to the specified ID. (Mutually exclusive with since)
limit | Default and max limit is 30. This limit must be a number under 30.
filter | Filter messages by links or charts. (Optional)

# Search

## Search

```shell
curl https://api.stocktwits.com/api/2/search.json \
  -d 'q=stocktwits'
```

> Response

```json
{
  "results":[
    {
      "type":"symbol",
      "title":"StockTwits Education",
      "symbol":"STUDY",
      "exchange":"MISC",
      "id":8677
    },
    {
      "type":"symbol",
      "title":"StockTwits",
      "symbol":"STWIT",
      "exchange":"PRIVATE",
      "id":7989
    },
    {
      "type":"symbol",
      "title":"StockTwits Predictions",
      "symbol":"PREDICT",
      "exchange":"MISC",
      "id":9217
    },
    {
      "type":"symbol",
      "title":"StockTwits Social Web Index",
      "symbol":"SWEB",
      "exchange":"MISC",
      "id":9690
    },
    {
      "type":"symbol",
      "title":"StockTwits IR Demo Corporation",
      "symbol":"DEMO",
      "exchange":"MISC",
      "id":9696
    },
    {
      "type":"symbol",
      "title":"StockTwits NCAA Bracket Challenge",
      "symbol":"NCAA",
      "exchange":"MISC",
      "id":9579
    },
    {
      "type":"symbol",
      "title":"StockTwits Roast",
      "symbol":"ROAST",
      "exchange":"MISC",
      "id":9439
    },
    {
      "type":"user",
      "name":"StockTwits",
      "username":"StockTwits",
      "id":170,
      "avatar_url":"https://s3.amazonaws.com/st-avatars/production/170/thumb-1409235653.png?1409235653",
      "official":true
    },
    {
      "type":"user",
      "name":"StockTwits Data",
      "username":"StockTwitsData",
      "id":206492,
      "avatar_url":"https://s3.amazonaws.com/st-avatars/production/206492/thumb-1357904126.png?1357904126",
      "official":false
    },
    {
      "type":"user",
      "name":"StockTwits Charts",
      "username":"chartly",
      "id":8648,
      "avatar_url":"https://s3.amazonaws.com/st-avatars/production/8648/thumb-1344904673.png?1344904673",
      "official":false
    },
    {
      "type":"user",
      "name":"StockTwits Help Desk",
      "username":"StockTwitsHelp",
      "id":8462,
      "avatar_url":"https://s3.amazonaws.com/st-avatars/production/8462/thumb-1412619441.png?1412619441",
      "official":false
    },
    {
      "type":"user",
      "name":"StockTwits TV",
      "username":"StockTwitsTV",
      "id":5245,
      "avatar_url":"https://s3.amazonaws.com/st-avatars/production/5245/thumb-1270047545.png?1270047545",
      "official":false
    },
    {
      "type":"user",
      "name":"StockTwits University",
      "username":"StockTwitsU",
      "id":21051,
      "avatar_url":"https://s3.amazonaws.com/st-avatars/production/21051/thumb-1439311816.png?1439311816",
      "official":false
    },
    {
      "type":"user",
      "name":"John Melloy",
      "username":"stocktwitsjohn",
      "id":269009,
      "avatar_url":"https://s3.amazonaws.com/st-avatars/production/269009/thumb-1381334240.png?1381334240",
      "official":false
    },
    {
      "type":"user",
      "name":"StockTwits Network",
      "username":"STNet",
      "id":25677,
      "avatar_url":"https://s3.amazonaws.com/st-avatars/production/25677/thumb-1286811272.png?1286811272",
      "official":false
    }
  ]
}
```

This allows an API application to search for a symbol or user. 30 Results will be a combined list of symbols and users.

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | Yes
Requires Authentication? | No
Requires Partner-Level Access? | No
Pagination? | No
HTTP Methods: | GET

### Parameters

Parameter | Description
--------- | -----------
q | The symbol or user string that you want to search for (Required)

## Symbols

```shell
curl https://api.stocktwits.com/api/2/search/symbols.json \
  -d 'q=AAPL'
```

> Response

```json
{
  "results":[
    {
      "type":"symbol",
      "title":"Apple Inc.",
      "symbol":"AAPL",
      "exchange":"NASDAQ",
      "id":686
    }
  ]
}
```

This allows an API application to search for a symbol directly. 30 Results will return only ticker symbols.

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | Yes
Requires Authentication? | No
Requires Partner-Level Access? | No
Pagination? | No
HTTP Methods: | GET

### Parameters

Parameter | Description
--------- | -----------
q | The symbol that you want to search for (Required)

## Users

```shell
curl https://api.stocktwits.com/api/2/search/users.json \
  -d 'q=stocktwits'
```

> Response

```json
{
  "results":[
    {
      "type":"user",
      "name":"StockTwits",
      "username":"StockTwits",
      "id":170,
      "avatar_url":"https://s3.amazonaws.com/st-avatars/production/170/thumb-1409235653.png?1409235653",
      "official":true
    },
    {
      "type":"user",
      "name":"StockTwits Data",
      "username":"StockTwitsData",
      "id":206492,
      "avatar_url":"https://s3.amazonaws.com/st-avatars/production/206492/thumb-1357904126.png?1357904126",
      "official":false
    },
    {
      "type":"user",
      "name":"StockTwits Charts",
      "username":"chartly",
      "id":8648,
      "avatar_url":"https://s3.amazonaws.com/st-avatars/production/8648/thumb-1344904673.png?1344904673",
      "official":false
    },
    {
      "type":"user",
      "name":"StockTwits Help Desk",
      "username":"StockTwitsHelp",
      "id":8462,
      "avatar_url":"https://s3.amazonaws.com/st-avatars/production/8462/thumb-1412619441.png?1412619441",
      "official":false
    },
    {
      "type":"user",
      "name":"StockTwits TV",
      "username":"StockTwitsTV",
      "id":5245,
      "avatar_url":"https://s3.amazonaws.com/st-avatars/production/5245/thumb-1270047545.png?1270047545",
      "official":false
    },
    {
      "type":"user",
      "name":"StockTwits University",
      "username":"StockTwitsU",
      "id":21051,
      "avatar_url":"https://s3.amazonaws.com/st-avatars/production/21051/thumb-1439311816.png?1439311816",
      "official":false
    },
    {
      "type":"user",
      "name":"John Melloy",
      "username":"stocktwitsjohn",
      "id":269009,
      "avatar_url":"https://s3.amazonaws.com/st-avatars/production/269009/thumb-1381334240.png?1381334240",
      "official":false
    },
    {
      "type":"user",
      "name":"StockTwits Network",
      "username":"STNet",
      "id":25677,
      "avatar_url":"https://s3.amazonaws.com/st-avatars/production/25677/thumb-1286811272.png?1286811272",
      "official":false
    },
    {
      "type":"user",
      "name":"The StockTwits Squad Car",
      "username":"STsquadcar",
      "id":81704,
      "avatar_url":"https://s3.amazonaws.com/st-avatars/production/81704/thumb-1306871723.png?1306871723",
      "official":true
    },
    {
      "type":"user",
      "name":"StockTwits FX",
      "username":"StockTwitsFX",
      "id":19569,
      "avatar_url":"https://s3.amazonaws.com/st-avatars/production/19569/thumb-1280172302.png?1280172302",
      "official":false
    },
    {
      "type":"user",
      "name":"StocktwitsHater",
      "username":"StocktwitsHater",
      "id":495,
      "avatar_url":"https://s3.amazonaws.com/st-avatars/production/495/thumb-1319565281.png?1319565281",
      "official":false
    },
    {
      "type":"user",
      "name":"StockTwits Pump Patrol",
      "username":"ST_PumpPatrol",
      "id":479628,
      "avatar_url":"https://s3.amazonaws.com/st-avatars/production/479628/thumb-1425506727.png?1425506727",
      "official":true
    },
    {
      "type":"user",
      "name":"StockTwits Awesome!",
      "username":"STawesome",
      "id":37943,
      "avatar_url":"https://s3.amazonaws.com/st-avatars/production/37943/thumb-1303909414.png?1303909414",
      "official":false
    },
    {
      "type":"user",
      "name":"StockTwits IR",
      "username":"StockTwitsIR",
      "id":35843,
      "avatar_url":"https://s3.amazonaws.com/st-avatars/production/35843/thumb-1320352066.png?1320352066",
      "official":false
    },
    {
      "type":"user",
      "name":"StockTwits Links",
      "username":"StockTwitsLinks",
      "id":222797,
      "avatar_url":"https://s3.amazonaws.com/st-avatars/production/222797/thumb-1364493882.png?1364493882",
      "official":false
    }
  ]
}
```

This allows an API application to search for a user directly. 30 Results will only return users.

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | Yes
Requires Authentication? | No
Requires Partner-Level Access? | No
Pagination? | No
HTTP Methods: | GET

### Parameters

Parameter | Description
--------- | -----------
q | The user that you want to search for (Required)

# Messages

## Create

Create a StockTwits message. To upload a chart to accompany the message, pass a file using the `chart` parameter.
The API will check that the character count is under 140 and prevent duplicate message postings.
[Learn more about parameters and character counting.](#counting-characters)

The Message ID can be used to create your own link to the message as a landing page.
This comes in handy in the case of a Chart where you might not want to create your own webpage or integrate the chart
into your application.

> Note that the $ character in the message may need to be escaped (\$) to prevent the shell from interpolating an environment variable.

```shell
curl https://api.stocktwits.com/api/2/messages/create.json \
  -H 'Authorization: Bearer <access_token>' \
  -d 'body=Creating a new message'
```

> Uploading a chart (The chart parameter may also be a URL)

```shell
curl https://api.stocktwits.com/api/2/messages/create.json \
  -X POST \
  -H 'Authorization: Bearer <access_token>' \
  -F body="Creating a new message with a chart. \$ticker" \
  -F chart=@/path/to/a/local/image/file.jpg
```

> Response

```json
{
  "message": {
    "id": 60975379,
    "body": "Creating a new message with a chart. $ticker",
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
        "symbol": "TICKER",
        "title": "Ticker Inc."
      }
    ],
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
  }
}
```

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | No
Requires Authentication? | Yes
Requires Partner-Level Access? | No
Pagination? | No
HTTP Methods: | POST

### Parameters

Parameter | Description
--------- | -----------
body | The body of the message. This parameter should be URL-encoded or entire request sent as multipart/form-data for all characters to submit properly. [Character count must be under 140.](#counting-characters) (Required)
in_reply_to_message_id | The ID this message replies to, if any. (Optional)
chart | Path or URL to file to be uploaded. File Formats accepted: JPG, PNG, GIF under 2MB. Charts will count as 24 characters in the message body (Optional)
sentiment | A sentiment label for the message. Acceptable values: bullish, bearish, neutral. Defaults to neutral. (Optional)

## Show

This shows the specified message details. This is used in a stand alone display.

```shell
curl https://api.stocktwits.com/api/2/messages/show/<message_id>.json
```

> Response

```json
{
  "message": {
    "id": 60975379,
    "body": "Creating a new message with a chart. $ticker",
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
        "symbol": "TICKER",
        "title": "Ticker Inc."
      }
    ],
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
  }
}
```

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | Yes
Requires Authentication? | No
Requires Partner-Level Access? | No
Pagination? | No
HTTP Methods: | GET

### Parameters

Parameter | Description
--------- | -----------
id | ID of the message you want to show from the authenticating user (Required)
conversation | 	Set to true to retrieve all meesages of the associated conversation. (Optional)

## Like

Like a message on StockTwits as the authenticating user.

```shell
curl https://api.stocktwits.com/api/2/messages/like.json \
  -X POST \
  -H 'Authorization: Bearer <access_token>' \
  -d 'id=60975379'
```

> Response

```json
{
  "message": {
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
     "likes": {
       "total": 1,
       "user_ids": [
         234328
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
}
```

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | No
Requires Authentication? | Yes
Requires Partner-Level Access? | No
Pagination? | No
HTTP Methods: | POST

### Parameters

Parameter | Description
--------- | -----------
id | ID of the message you want to like for the authenticating user (Required)

## Unlike

Unlike a message on StockTwits as the authenticating user.

```shell
curl https://api.stocktwits.com/api/2/messages/unlike.json \
  -X POST \
  -H 'Authorization: Bearer <access_token>' \
  -d 'id=60975379'
```

> Response

```json
{
  "message": {
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
   }
}
```

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | No
Requires Authentication? | Yes
Requires Partner-Level Access? | No
Pagination? | No
HTTP Methods: | POST

### Parameters

Parameter | Description
--------- | -----------
id | ID of the message you want to unlike for the authenticating user (Required)

# Graph

## Blocking

Returns the list of users that were blocked by the authenticating user.

```shell
curl https://api.stocktwits.com/api/2/graph/blocking.json \
  -H 'Authorization: Bearer <access_token>'
```

> Response

```json
{
  "cursor":{
    "more":true,
    "since":1450610,
    "max":295259
  },
  "users":[
    {
      "id":304332,
      "username":"sorcefm",
      "name":"chaz",
      "avatar_url":"http://avatars.stocktwits.com/production/304332/thumb-1459284015.png",
      "avatar_url_ssl":"https://s3.amazonaws.com/st-avatars/production/304332/thumb-1459284015.png",
      "join_date":"2014-01-23",
      "official":false
    },
    {
      "id":802670,
      "username":"francine86",
      "name":"Francine Bohnen",
      "avatar_url":"http://avatars.stocktwits.com/production/802670/thumb-1469429576.png",
      "avatar_url_ssl":"https://s3.amazonaws.com/st-avatars/production/802670/thumb-1469429576.png",
      "join_date":"2016-07-25",
      "official":false
    },
    {
      "id":295259,
      "username":"Smurfologist",
      "name":"Melvin Woods",
      "avatar_url":"http://avatars.stocktwits.com/production/295259/thumb-1421935334.png",
      "avatar_url_ssl":"https://s3.amazonaws.com/st-avatars/production/295259/thumb-1421935334.png",
      "join_date":"2013-12-31",
      "official":false
    }
  ]
}
```

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | Yes
Requires Authentication? | Yes
Requires Partner-Level Access? | No
Pagination? | Yes
HTTP Methods: | GET

### Parameters

Parameter | Description
--------- | -----------
since | Returns results with an ID greater than (more recent than) the specified ID.
max | Returns results with an ID less than (older than) or equal to the specified ID.

## Muting

Returns the list of users that were muted by the authenticating user.

```shell
curl https://api.stocktwits.com/api/2/graph/muting.json \
  -H 'Authorization: Bearer <access_token>'
```

> Response

```json
{
  "cursor":{
    "more":true,
    "since":1450610,
    "max":295259
  },
  "users":[
    {
      "id":304332,
      "username":"sorcefm",
      "name":"chaz",
      "avatar_url":"http://avatars.stocktwits.com/production/304332/thumb-1459284015.png",
      "avatar_url_ssl":"https://s3.amazonaws.com/st-avatars/production/304332/thumb-1459284015.png",
      "join_date":"2014-01-23",
      "official":false
    },
    {
      "id":802670,
      "username":"francine86",
      "name":"Francine Bohnen",
      "avatar_url":"http://avatars.stocktwits.com/production/802670/thumb-1469429576.png",
      "avatar_url_ssl":"https://s3.amazonaws.com/st-avatars/production/802670/thumb-1469429576.png",
      "join_date":"2016-07-25",
      "official":false
    },
    {
      "id":295259,
      "username":"Smurfologist",
      "name":"Melvin Woods",
      "avatar_url":"http://avatars.stocktwits.com/production/295259/thumb-1421935334.png",
      "avatar_url_ssl":"https://s3.amazonaws.com/st-avatars/production/295259/thumb-1421935334.png",
      "join_date":"2013-12-31",
      "official":false
    }
  ]
}
```

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | Yes
Requires Authentication? | Yes
Requires Partner-Level Access? | No
Pagination? | Yes
HTTP Methods: | GET

### Parameters

Parameter | Description
--------- | -----------
since | Returns results with an ID greater than (more recent than) the specified ID.
max | Returns results with an ID less than (older than) or equal to the specified ID.

## Following

Returns the list of users the authenticated user is following.

```shell
curl https://api.stocktwits.com/api/2/graph/following.json \
  -H 'Authorization: Bearer <access_token>'
```

> Response

```json
{
  "cursor":{
    "more":true,
    "since":1450610,
    "max":295259
  },
  "users":[
    {
      "id":304332,
      "username":"sorcefm",
      "name":"chaz",
      "avatar_url":"http://avatars.stocktwits.com/production/304332/thumb-1459284015.png",
      "avatar_url_ssl":"https://s3.amazonaws.com/st-avatars/production/304332/thumb-1459284015.png",
      "join_date":"2014-01-23",
      "official":false
    },
    {
      "id":802670,
      "username":"francine86",
      "name":"Francine Bohnen",
      "avatar_url":"http://avatars.stocktwits.com/production/802670/thumb-1469429576.png",
      "avatar_url_ssl":"https://s3.amazonaws.com/st-avatars/production/802670/thumb-1469429576.png",
      "join_date":"2016-07-25",
      "official":false
    },
    {
      "id":295259,
      "username":"Smurfologist",
      "name":"Melvin Woods",
      "avatar_url":"http://avatars.stocktwits.com/production/295259/thumb-1421935334.png",
      "avatar_url_ssl":"https://s3.amazonaws.com/st-avatars/production/295259/thumb-1421935334.png",
      "join_date":"2013-12-31",
      "official":false
    }
  ]
}
```

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | Yes
Requires Authentication? | Yes
Requires Partner-Level Access? | No
Pagination? | Yes
HTTP Methods: | GET

### Parameters

Parameter | Description
--------- | -----------
since | Returns results with an ID greater than (more recent than) the specified ID.
max | Returns results with an ID less than (older than) or equal to the specified ID.

## Followers

Returns the list of users the authenticated user is following.

```shell
curl https://api.stocktwits.com/api/2/graph/following.json \
  -H 'Authorization: Bearer <access_token>'
```

> Response

```json
{
  "cursor":{
    "more":true,
    "since":1450610,
    "max":295259
  },
  "users":[
    {
      "id":304332,
      "username":"sorcefm",
      "name":"chaz",
      "avatar_url":"http://avatars.stocktwits.com/production/304332/thumb-1459284015.png",
      "avatar_url_ssl":"https://s3.amazonaws.com/st-avatars/production/304332/thumb-1459284015.png",
      "join_date":"2014-01-23",
      "official":false
    },
    {
      "id":802670,
      "username":"francine86",
      "name":"Francine Bohnen",
      "avatar_url":"http://avatars.stocktwits.com/production/802670/thumb-1469429576.png",
      "avatar_url_ssl":"https://s3.amazonaws.com/st-avatars/production/802670/thumb-1469429576.png",
      "join_date":"2016-07-25",
      "official":false
    },
    {
      "id":295259,
      "username":"Smurfologist",
      "name":"Melvin Woods",
      "avatar_url":"http://avatars.stocktwits.com/production/295259/thumb-1421935334.png",
      "avatar_url_ssl":"https://s3.amazonaws.com/st-avatars/production/295259/thumb-1421935334.png",
      "join_date":"2013-12-31",
      "official":false
    }
  ]
}
```

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | Yes
Requires Authentication? | Yes
Requires Partner-Level Access? | No
Pagination? | Yes
HTTP Methods: | GET

### Parameters

Parameter | Description
--------- | -----------
since | Returns results with an ID greater than (more recent than) the specified ID.
max | Returns results with an ID less than (older than) or equal to the specified ID.

# Friendships

## Create

This is to publicly follow a user, create a friendship and receive all messages from this user.

```shell
curl https://api.stocktwits.com/api/2/friendships/create/<user_id>.json \
  -X POST \
  -H 'Authorization: Bearer <access_token>'
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
  }
}
```

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | No
Requires Authentication? | Yes
Requires Partner-Level Access? | No
Pagination? | No
HTTP Methods: | POST

### Parameters

Parameter | Description
--------- | -----------
id | The User ID of the StockTwits user you want to follow (Required)

## Destroy

This it to unfollow a user and end the friendship and no longer receive the users messages.

```shell
curl https://api.stocktwits.com/api/2/friendships/destroy/<user_id>.json \
  -X POST \
  -H 'Authorization: Bearer <access_token>'
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
  }
}
```

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | No
Requires Authentication? | Yes
Requires Partner-Level Access? | No
Pagination? | No
HTTP Methods: | POST

### Parameters

Parameter | Description
--------- | -----------
id | The User ID of the StockTwits user you want to unfollow (Required)

# Watchlists

## Watchlists

Returns a list of private watch lists for the authenticating user.

```shell
curl https://api.stocktwits.com/api/2/watchlists.json \
  -H 'Authorization: Bearer <access_token>'
```

> Response

```json
{
  "watchlists": [
    {
      "id": 36477,
      "name": "Mobile Watchlist",
      "updated_at": "2012-08-13T21:59:30Z",
      "created_at": "2012-06-26T02:03:39Z"
    },
    {
      "id": 38398,
      "name": "my picks",
      "updated_at": "2012-08-13T21:59:46Z",
      "created_at": "2012-08-10T22:03:24Z"
    }
  ]
}
```

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | Yes
Requires Authentication? | Yes
Requires Partner-Level Access? | No
Pagination? | No
HTTP Methods: | GET

### Parameters

None

## Create

This creates a private watch list for the authenticating user. A watch list will consist of many ticker symbols.

```shell
curl https://api.stocktwits.com/api/2/watchlists/create.json \
  -X POST \
  -H 'Authorization: Bearer <access_token>' \
  -d 'name=new_watch_list'
```

> Response

```json
{
  "watchlist": {
    "id": 38509,
    "name": "new_watch_list",
    "updated_at": "2012-08-13T22:09:25Z",
    "created_at": "2012-08-13T22:09:25Z"
  }
}
```

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | No
Requires Authentication? | Yes
Requires Partner-Level Access? | No
Pagination? | No
HTTP Methods: | POST

### Parameters

Parameter | Description
--------- | -----------
name | The name of the new watch list. (Required)

## Update

This update the contents of the specified watch list. Required parameters are the `id` of the watch list that is to be
updated and the new `name` of the watch list.

```shell
curl https://api.stocktwits.com/api/2/watchlists/update/<watchlist_id>.json \
  -X POST \
  -H 'Authorization: Bearer <access_token>' \
  -d 'name=new_watchlist_name'
```

> Response

```json
{
  "watchlist": {
    "id": 38509,
    "name": "new_watchlist_name",
    "updated_at": "2012-08-13T22:09:25Z",
    "created_at": "2012-08-13T22:09:25Z"
  }
}
```

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | No
Requires Authentication? | Yes
Requires Partner-Level Access? | No
Pagination? | No
HTTP Methods: | POST

### Parameters

Parameter | Description
--------- | -----------
id | The ID of the watch list to be updated (Required)
name | The name of the new watch list. (Required)

## Destroy

This deletes the specified watch list. Required parameter is the ID of the watch list to be deleted, this is not the
name of the watch list.

```shell
curl https://api.stocktwits.com/api/2/watchlists/destroy/<watchlist_id>.json \
  -X POST \
  -H 'Authorization: Bearer <access_token>'
```

> Response will be a 204 No Content

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | No
Requires Authentication? | Yes
Requires Partner-Level Access? | No
Pagination? | No
HTTP Methods: | POST

### Parameters

Parameter | Description
--------- | -----------
id | The ID of the watch list to be destroyed (Required)

## Show

Returns the the list of ticker symbols in a specified watch list for the authenticating user. Required parameter is the
`id` of the watch list, not the `name` of the watch list.

```shell
curl https://api.stocktwits.com/api/2/watchlists/show/<watchlist_id>.json \
  -H 'Authorization: Bearer <access_token>'
```

> Response

```json
{
  "watchlist": {
    "id": 38398,
    "name": "my picks",
    "updated_at": "2012-08-13T22:26:20Z",
    "created_at": "2012-08-10T22:03:24Z",
    "symbols": [
      {
        "id": 7871,
        "symbol": "FB",
        "title": "Facebook"
      },
      {
        "id": 2044,
        "symbol": "GOOG",
        "title": "Google Inc."
      },
      {
        "id": 686,
        "symbol": "AAPL",
        "title": "Apple Inc."
      }
    ]
  }
}
```

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | Yes
Requires Authentication? | Yes
Requires Partner-Level Access? | No
Pagination? | No
HTTP Methods: | GET

### Parameters

Parameter | Description
--------- | -----------
id | The ID of the watch list to be shown (Required)

## Add Symbols

This adds a ticker symbol or symbols to a specified watch list. Required parameters are the `id` of the watch list and
the symbol or symbols to be added.

```shell
curl https://api.stocktwits.com/api/2/watchlists/<watchlist_id>/symbols/create.json \
  -X POST \
  -H 'Authorization: Bearer <access_token>' \
  -d 'symbols=AAPL'
```

> Response

```json
{
  "symbols": [
    {
      "id": 686,
      "symbol": "AAPL",
      "title": "Apple Inc."
    }
  ]
}
```

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | No
Requires Authentication? | Yes
Requires Partner-Level Access? | No
Pagination? | No
HTTP Methods: | POST

### Parameters

Parameter | Description
--------- | -----------
id | The ID of the watch list to add to. (Required)
symbols | The ticker symbol or comma separated symbols that are to be added to the specified watch list. (Required)

## Remove Symbols

Remove a symbol from the specified watch list. You must pass the `id` of the watch list to which you want to add the
symbol, not the name of the watch list.

```shell
curl https://api.stocktwits.com/api/2/watchlists/<watchlist_id>/symbols/destroy.json \
  -X POST \
  -H 'Authorization: Bearer <access_token>' \
  -d 'symbols=AAPL'
```

> Response will be an array of symbols that have been removed

```json
{
  "symbols": [
    {
      "id": 686,
      "symbol": "AAPL",
      "title": "Apple Inc."
    }
  ]
}
```

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | No
Requires Authentication? | Yes
Requires Partner-Level Access? | No
Pagination? | No
HTTP Methods: | POST

### Parameters

Parameter | Description
--------- | -----------
id | The ID of the watch list to remove symbols from. (Required)
symbols | The ticker of the symbol that you want to remove from the specified watch list. (Required)

# Blocks

## Create

This blocks a user so the authenticating user will not receive message from the specified user. Required parameter is
the `user_id` of the user to block, not the username.

```shell
curl https://api.stocktwits.com/api/2/blocks/create/<user_id>.json \
  -X POST \
  -H 'Authorization: Bearer <access_token>'
```

> Response

```json
{
  "user": {
    "id": 176389,
    "username": "jimmychanos",
    "name": "Jim Chanos",
    "avatar_url": "http://avatars.stocktwits.com/images/default_avatar_thumb.jpg",
    "avatar_url_ssl": "https://s3.amazonaws.com/st-avatars/images/default_avatar_thumb.jpg",
    "join_date":"2016-07-25",
    "official":false
  }
}
```

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | No
Requires Authentication? | Yes
Requires Partner-Level Access? | No
Pagination? | No
HTTP Methods: | POST

### Parameters

Parameter | Description
--------- | -----------
id | The ID of the user you want to block (Required)

## Destroy

This unblocks a user so the authenticating user can reveive messages from the specified user. required parameter is the
`user_id` of the user to unblock, not the username.

```shell
curl https://api.stocktwits.com/api/2/blocks/destroy/<user_id>.json \
  -X DELETE \
  -H 'Authorization: Bearer <access_token>'
```

> Response

```json
{
  "user": {
    "id": 176389,
    "username": "jimmychanos",
    "name": "Jim Chanos",
    "avatar_url": "http://avatars.stocktwits.com/images/default_avatar_thumb.jpg",
    "avatar_url_ssl": "https://s3.amazonaws.com/st-avatars/images/default_avatar_thumb.jpg",
    "join_date":"2016-07-25",
    "official":false
  }
}
```

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | No
Requires Authentication? | Yes
Requires Partner-Level Access? | No
Pagination? | No
HTTP Methods: | DELETE

### Parameters

Parameter | Description
--------- | -----------
id | The ID of the user you want to unblock (Required)

# Mutes

## Create

This mutes a user so the authenticating user will no longer see the muted user in streams. Authenticated user will
still be able to view the profile of the muted user. Required parameter is the `user_id` of the user to mute, not the
username.

```shell
curl https://api.stocktwits.com/api/2/mutes/create/<user_id>.json \
  -X POST \
  -H 'Authorization: Bearer <access_token>'
```

> Response

```json
{
  "user": {
    "id": 176389,
    "username": "jimmychanos",
    "name": "Jim Chanos",
    "avatar_url": "http://avatars.stocktwits.com/images/default_avatar_thumb.jpg",
    "avatar_url_ssl": "https://s3.amazonaws.com/st-avatars/images/default_avatar_thumb.jpg",
    "join_date":"2016-07-25",
    "official":false
  }
}
```

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | No
Requires Authentication? | Yes
Requires Partner-Level Access? | No
Pagination? | No
HTTP Methods: | POST

### Parameters

Parameter | Description
--------- | -----------
id | The ID of the user you want to mute (Required)

## Destroy

This unmutes a user so the authenticating user can view messages from the specific users in streams. required parameter
is the `user_id` of the user to unmute, not the username.

```shell
curl https://api.stocktwits.com/api/2/mutes/destroy/<user_id>.json \
  -X DELETE \
  -H 'Authorization: Bearer <access_token>'
```

> Response

```json
{
  "user": {
    "id": 176389,
    "username": "jimmychanos",
    "name": "Jim Chanos",
    "avatar_url": "http://avatars.stocktwits.com/images/default_avatar_thumb.jpg",
    "avatar_url_ssl": "https://s3.amazonaws.com/st-avatars/images/default_avatar_thumb.jpg",
    "join_date":"2016-07-25",
    "official":false
  }
}
```

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | No
Requires Authentication? | Yes
Requires Partner-Level Access? | No
Pagination? | No
HTTP Methods: | DELETE

### Parameters

Parameter | Description
--------- | -----------
id | The ID of the user you want to unmute (Required)

# Account

## Verify

This verifies the credentials of a user. Useful for checking if authentication method is correct.

```shell
curl https://api.stocktwits.com/api/2/account/verify.json \
  -H 'Authorization: Bearer <access_token>'
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
  }
}
```

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | Yes
Requires Authentication? | Yes
Requires Partner-Level Access? | No
Pagination? | No
HTTP Methods: | GET

### Parameters

None

## Update

This updates the properties of the authenticating user's account.

<aside class="success">
This API end-point is only available through [Partner-Level Access.](mailto:api@stocktwits.com)
</aside>

```shell
curl https://api.stocktwits.com/api/2/account/update.json \
  -X POST \
  -H 'Authorization: Bearer <access_token>' \
  -d 'name=New Name'
```

> Response

```json
{
  "user": {
    "id": 369117,
    "username": "ericalford",
    "name": "New Name",
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
  }
}
```

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | No
Requires Authentication? | Yes
Requires Partner-Level Access? | Yes
Pagination? | No
HTTP Methods: | POST

### Parameters

Parameter | Description
--------- | -----------
name | The full name of the account holder
email | The email address for the account holder
username | The username for the account holder

# Trending

## Symbols

Returns a list of all the trending symbols at the moment requested. Trending symbols include equities and non-equities
like futures and forex. These are updated in 5-minute intervals.

```shell
curl https://api.stocktwits.com/api/2/trending/symbols.json
```

> Response

```json
{
  "symbols": [
    {
      "id": 686,
      "symbol": "AAPL",
      "title": "Apple Inc."
    },
    {
      "id": 30,
      "symbol": "ES_F",
      "title": "E-Mini S&P 500 Futures"
    },
    {
      "id": 8660,
      "symbol": "TSLA",
      "title": "Tesla Motors, Inc."
    }
  ]
}
```

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | Yes
Requires Authentication? | No
Requires Partner-Level Access? | No
Pagination? | No
HTTP Methods: | GET

### Parameters

Parameter | Description
--------- | -----------
limit | Default and max limit is 30. This limit must be a number under 30.

## Equities

Returns a list of all the trending equity symbols at the moment requested. Trending equities have to have a price over
$5. These are updated in 5 minute intervals.

```shell
curl https://api.stocktwits.com/api/2/trending/symbols/equities.json
```

> Response

```json
{
  "symbols": [
    {
      "id": 686,
      "symbol": "AAPL",
      "title": "Apple Inc."
    },
    {
      "id": 30,
      "symbol": "ES_F",
      "title": "E-Mini S&P 500 Futures"
    },
    {
      "id": 8660,
      "symbol": "TSLA",
      "title": "Tesla Motors, Inc."
    }
  ]
}
```

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | Yes
Requires Authentication? | No
Requires Partner-Level Access? | No
Pagination? | No
HTTP Methods: | GET

### Parameters

Parameter | Description
--------- | -----------
limit | Default and max limit is 30. This limit must be a number under 30.

# Deletions

## Messages

Returns a list of messages deleted recently. This is to be used in conjunction with firehose access.

<aside class="success">
This API end-point is only available through [Partner-Level Access.](mailto:api@stocktwits.com)
</aside>

```shell
curl https://api.stocktwits.com/api/2/deletions/messages.json \
  -H 'Authorization: Bearer <access_token>'
```

> Response

```json
{
  "cursor": {
    "since": 111868,
    "max": 111769,
    "more": true
  },
  "messages": [
    {
      "id": 111868,
      "message_id": 9092561,
      "deleted_at": "2012-08-13T22:29:04Z"
    },
    {
      "id": 111867,
      "message_id": 9093785,
      "deleted_at": "2012-08-13T22:28:28Z"
    },
    {
      "id": 111866,
      "message_id": 9093714,
      "deleted_at": "2012-08-13T22:16:05Z"
    },
    {
      "id": 111865,
      "message_id": 9093260,
      "deleted_at": "2012-08-13T22:03:41Z"
    },
    {
      "id": 111864,
      "message_id": 9093113,
      "deleted_at": "2012-08-13T22:03:37Z"
    },
    {
      "id": 111863,
      "message_id": 9093142,
      "deleted_at": "2012-08-13T21:28:55Z"
    },
  ]
}
```

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | Yes
Requires Authentication? | Yes
Requires Partner-Level Access? | Yes
Pagination? | Yes
HTTP Methods: | GET

### Parameters

Parameter | Description
--------- | -----------
since | Returns results with an ID greater than (more recent than) the specified ID.
max | Returns results with an ID less than (older than) or equal to the specified ID.

## Users

Returns a list of user accounts deleted recently. This is to be used in conjunction with firehose access.

<aside class="success">
This API end-point is only available through [Partner-Level Access.](mailto:api@stocktwits.com)
</aside>

```shell
curl https://api.stocktwits.com/api/2/deletions/users.json \
  -H 'Authorization: Bearer <access_token>'
```

> Response

```json
{
  "cursor": {
    "since": 924,
    "max": 825,
    "more": true
  },
  "users": [
    {
      "id": 924,
      "user_id": 147524,
      "username": "SSX999",
      "deleted_at": "2012-08-13T18:22:53Z"
    },
    {
      "id": 923,
      "user_id": 176669,
      "username": "jhardiejr2",
      "deleted_at": "2012-08-13T14:24:59Z"
    },
    {
      "id": 922,
      "user_id": 130685,
      "username": "dp06x",
      "deleted_at": "2012-08-13T14:18:15Z"
    },
    {
      "id": 921,
      "user_id": 158870,
      "username": "daniaconcha",
      "deleted_at": "2012-08-13T14:08:41Z"
    },
    {
      "id": 920,
      "user_id": 102850,
      "username": "sshin1212",
      "deleted_at": "2012-08-13T14:07:21Z"
    },
    {
      "id": 919,
      "user_id": 59050,
      "username": "FXTrader",
      "deleted_at": "2012-08-13T13:49:00Z"
    }
  ]
}
```

### Endpoint Information

Description | Value
--------- | -----------
Rate Limited? | Yes
Requires Authentication? | Yes
Requires Partner-Level Access? | Yes
Pagination? | Yes
HTTP Methods: | GET

### Parameters

Parameter | Description
--------- | -----------
limit | Default and max limit is 30. This limit must be a number under 30.