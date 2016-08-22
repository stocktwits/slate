#Widget

> Copy & Paste the code into your website:

```html
<div id="stocktwits-widget-news"></div>
<a href='http://stocktwits.com' style='font-size: 0px;'>StockTwits</a>
<script type="text/javascript" src="http://stocktwits.com/addon/widget/2/widget-loader.min.js"></script>
<script type="text/javascript">
STWT.Widget({
  container: 'stocktwits-widget-news',
  symbol: 'AAPL',
  width: '300',
  height: '300',
  limit: '15',
  scrollbars: 'true',
  streaming: 'true',
  title: 'AAPL Ideas',
  style: {
    link_color: '4871a8',
    link_hover_color: '4871a8',
    header_text_color: '000000',
    border_color: 'cecece',
    divider_color: 'cecece',
    divider_color: 'cecece',
    divider_type: 'solid',
    box_color: 'f5f5f5',
    stream_color: 'ffffff',
    text_color: '000000',
    time_color: '999999'
  }
});
</script>
```

Our custom widget application allows you to enter specific parameters into the fields below and generate code to add a
custom widget to your website, showing a live feed of your company ticker page.

![Widget Sample](/images/widget_sample.png)

The container variable `stocktwits-widget-news` is the name of the surrounding div ID that must be included to embed
the widget. You may change the div ID to whatever you want so long as the container variable is set to the same ID.

You can customize the widget format with the following options by including the variable and its value in the
STWT widget array.

### Formatting Options
**user and symbol are mutually exclusive**

Field | Description
--------- | -----------
user | ID or login of user stream you wish to show (Required)
symbol | ID or symbol of symbol stream you wish to show (Required)
avatars (0 or 1) | Display avatars (Optional. Default = 1)
scrollbars (0 or 1) | Display scrollbars (Optional. Default = 1)
times (0 or 1) | Display date/time (Optional. Default = 1)
streaming (0 or 1) | Stream new results (Optional. Default = 1)
header (0 or 1) | Display header or title (Optional. Default = 1)
limit | Number of results, maximum is 30 (Optional. Default = 15)
width | Width of widget in pixels (Optional. Default = 300)
height | Height of widget in pixels (Optional. Default = 300)
title | Title of widget (Optional. Default depends on stream)

###Advanced Styling Options

Field | Description
--------- | -----------
border_color | Color of the border (default = cecece)
border_color_2 | Color of the second border (default = cecece)
box_color | Color of the box (default = f5f5f5)
header_text_color | Color of the header text (default = 000)
divider_color | Color of the divider (default = cecece)
stream_color | Color of the stream background (default = fff)
username_color | Color of the username link (default = 600d0b)
username_hover_color | Color of the username link when you hover (default = 600d0b)
username_font | Font family (default = Arial, Tahoma, sans-serif)
username_size | Size of font in pixels (default = 13)
divider_type | Style of the dividing line between messages (default = dotted)
link_color | Color of links (default = 4871a8)
link_hover_color | Color of links when you hover (default = 4871a8)
link_ticker_color | Color of ticker links (default = 4871a8)
link_ticker_hover_color | Color of ticker links when you hover (default = 4871a8)
time_color | Color of time (default = 999)
text_color | Text color (default = 000)
font | Font family (default = Arial, Tahoma, sans-serif)
font_size | Size of font in pixels (default = 13)
time_font_size | Font size of time (default = 11)