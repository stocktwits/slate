#StockTwits Buttons

Add StockTwits Buttons to your site so users can share your content on StockTwits or so you can drive users to follow
you on StockTwits. Use of StockTwits buttons is subject to [StockTwits Display Guidelines](#content-display-requirements)
and [Terms and Conditions.](#terms-amp-conditions)

## Share Button

> Copy & Paste the code into your website:

```html
<a href="http://stocktwits.com/widgets/share" id="stocktwits-share-button">
  <img src="https://stocktwits.com/assets/widget/stocktwits_share.png" alt="Share on StockTwits"/>
</a>
<script src="http://stocktwits.com/addon/button/share.min.js"></script>
```

![Share Button](https://stocktwits.com/images/widget/stocktwits_share.png)

The share button allows your visitors to seamlessly share ideas and links across the StockTwits network whenever
they're on your website. Adding it will place a StockTwits button on your site, which will pop up a message box to
share StockTwits content whenever a user clicks on the button. The message box will include the current page title and
URL into the message by default.

###JavaScript Disabled

If a user doesn't have JavaScript turned on, the button will not be displayed but the text "Share on StockTwits" will
render with a link to the share functionality.

###Custom Message

Additional parameters may also be included in the message by default by setting the data-text value. For example, to
have a user's message include "Go to my site http://stocktwits.com" whenever the button is clicked on, simply set that
value in `data-text`

##Follow Button

Add a StockTwits Follow button to your site to drive your users and visitors to follow your account on StockTwits.

The StockTwits follow button comes in three different colors - silver, graphite, and blue. Below is the code to add to
your site. Be sure to replace 'StockTwits' in the URL with your StockTwits username (http://stocktwits.com/username) in
the code below:

> Silver

```html
<a href="http://stocktwits.com/StockTwits" id="stocktwits-follow-button">
  <img src="http://stocktwits.com/assets/badges/FOLLOW_US_SILVER.png" alt="Follow Us on StockTwits"/>
</a>
```

![Share Button](http://stocktwits.com/assets/badges/FOLLOW_US_SILVER.png)

> Graphite

```html
<a href="http://stocktwits.com/StockTwits" id="stocktwits-follow-button">
  <img src="http://stocktwits.com/assets/badges/FOLLOW_US_GRAPHITE.png" alt="Follow Us on StockTwits"/>
</a>
```

![Share Button](http://stocktwits.com/assets/badges/FOLLOW_US_GRAPHITE.png)

> Blue

```html
<a href="http://stocktwits.com/StockTwits" id="stocktwits-follow-button">
  <img src="http://stocktwits.com/assets/badges/FOLLOW_US_RED.png" alt="Follow Us on StockTwits"/>
</a>
```

![Share Button](http://stocktwits.com/assets/badges/FOLLOW_US_RED.png)