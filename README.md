# Stocks

<p align="center">
  <a href="https://github.com/fork-my-spoons/stocks.spoon/actions">
    <img alt="Build" src="https://github.com/fork-my-spoons/stocks.spoon/workflows/build/badge.svg"/></a>
  <a href="https://github.com/fork-my-spoons/stocks.spoon/issues">
    <img alt="GitHub issues" src="https://img.shields.io/github/issues/fork-my-spoons/stocks.spoon"/></a>
  <a href="https://github.com/fork-my-spoons/stocks.spoon/releases">
    <img alt="GitHub all releases" src="https://img.shields.io/github/downloads/fork-my-spoons/stocks.spoon/total"/></a>
</p>

A menu bar app showing stock prices for selected stocks based of  [yahoofinanceapi.com](https://www.yahoofinanceapi.com):

![screenshot](./screenshots/screenshot1.png)

# Installation

 - install [Hammerspoon](http://www.hammerspoon.org/) - a powerfull automation tool for OS X
   - Manually:

      Download the [latest release](https://github.com/Hammerspoon/hammerspoon/releases/latest), and drag Hammerspoon.app from your Downloads folder to Applications.
   - Homebrew:

      ```brew install hammerspoon --cask```

 - get a "basic" api key from https://www.yahoofinanceapi.com/pricing

 - download [stocks.spoon](https://github.com/fork-my-spoons/stocks.spoon/releases/latest/download/stocks.spoon.zip), unzip and double click on a .spoon file. It will be installed under `~/.hammerspoon/Spoons` folder.
 
 - open ~/.hammerspoon/init.lua and add the following snippet, with your repositories:

```lua
-- Stocks
hs.loadSpoon('stocks')
spoon['stocks']:setup({
  api_key = 'your api key',
  stocks = 'aapl,msft' # comma-separated list of stocks you want to follow
})
spoon['stocks']:start()
```


This app uses icons, to properly display them, install a [feather-font](https://github.com/AT-UI/feather-font) by [downloading](https://github.com/AT-UI/feather-font/raw/master/src/fonts/feather.ttf) this .ttf font and installing it.
