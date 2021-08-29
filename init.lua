local obj = {}
obj.__index = obj

-- Metadata
obj.name = "Stock"
obj.version = "1.0"
obj.author = "Pavel Makhov"
obj.homepage = "https://github.com/fork-my-spoons/github-pull-requests.spoon"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.indicator = nil
obj.iconPath = hs.spoons.resourcePath("icons")
obj.api_key = nil
obj.menu = {}
obj.selected = nil

local function show_warning(text)
    hs.notify.new(function() end, {
        autoWithdraw = false,
        title = obj.name,
        informativeText = string.format(text)
    }):send()
end

function obj:update()
    
    self.menu = {}
    local header = {}
    header['x-api-key'] = self.api_key
    hs.http.asyncGet('https://yfapi.net/v6/finance/quote?symbols=' .. self.stocks, 
    header, function(status, body)
        if status ~= 200 then
            show_warning(body)
            return
        end

        local response = hs.json.decode(body)
        local color
        if response.quoteResponse.result[1].regularMarketChangePercent > 0 then 
            color = '#00873c'
        else
            color = '#eb0f29'
        end

        self.selected = hs.settings.get('selected_stock') or response.quoteResponse.result[1].symbol

        for k, quote in pairs(response.quoteResponse.result) do
            if self.selected:lower() == quote.symbol:lower() then
                self.indicator:setTitle(
                    hs.styledtext.new(quote.regularMarketPrice, 
                    {color = {hex = color}, font = {name = 'Baloo', size = 16}})
                    )
            end

            table.insert(self.menu, {
                title = hs.styledtext.new(quote.longName .. '\n')
                    .. hs.styledtext.new(quote.regularMarketPrice .. ' ' .. quote.regularMarketChange .. '(' .. quote.regularMarketChangePercent.. '%)'),
                    checked = self.selected ~= nil and self.selected:lower() == quote.symbol:lower(),
                    fn = function() 
                        self.selected = quote.symbol
                        hs.settings.set('selected_stock', self.selected)
                        self:update()
                    end
            })
        end

        self.indicator:setMenu(self.menu)
    end)

end

function obj:init()
    self.indicator = hs.menubar.new()
end

function obj:setup(args)
    self.api_key = args.api_key
    self.stocks = args.stocks or 'aapl,msft,fb'
end

function obj:start()
    self:update()
end


return obj
