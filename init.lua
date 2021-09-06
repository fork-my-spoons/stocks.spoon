local obj = {}
obj.__index = obj

-- Metadata
obj.name = "Stocks"
obj.version = "1.0"
obj.author = "Pavel Makhov"
obj.homepage = "https://github.com/fork-my-spoons/stocks.spoon"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.indicator = nil
obj.iconPath = hs.spoons.resourcePath("icons")
obj.api_key = nil
obj.menu = {}
obj.selected = nil
obj.stocks = nil
obj.timer = nil

local trending_up_icon = hs.styledtext.new(' ', { font = {name = 'feather', size = 12 }, color = {hex = '#00873c'}})
local trending_down_icon = hs.styledtext.new(' ', { font = {name = 'feather', size = 12 }, color = {hex = '#eb0f29'}})


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
        

        self.selected = hs.settings.get('selected_stock') or response.quoteResponse.result[1].symbol

        for k, quote in pairs(response.quoteResponse.result) do
            
            if quote.regularMarketChangePercent > 0 then 
                color = '#00873c'
                icon = trending_up_icon
            else
                color = '#eb0f29'
                icon = trending_down_icon
            end

            if self.selected:lower() == quote.symbol:lower() then
                self.indicator:setTitle(
                    hs.styledtext.new(string.format("%.2f", quote.regularMarketPrice), 
                    {color = {hex = color}, font = {name = 'Baloo', size = 16}})
                    )
            end

            table.insert(self.menu, {
                title = hs.styledtext.new((quote.longName or quote.shortName) .. '\n')
                    .. icon .. hs.styledtext.new(string.format("%.2f", quote.regularMarketPrice) .. ' ' .. string.format("%.2f", quote.regularMarketChange) .. '(' .. string.format("%.2f", quote.regularMarketChangePercent).. '%)'),
                    checked = self.selected ~= nil and self.selected:lower() == quote.symbol:lower(),
                    fn = function() 
                        self.selected = quote.symbol
                        hs.settings.set('selected_stock', self.selected)
                        self:update()
                    end
            })
        end
        
        if self.indicator:title() == nil or self.indicator:title() == '' then
            self.indicator:setTitle(
                    hs.styledtext.new(response.quoteResponse.result[1].regularMarketPrice, 
                    {color = {hex = color}, font = {name = 'Baloo', size = 16}})
                    )
        end

        table.insert(self.menu, {title = '-'})
        table.insert(self.menu, {
            title = 'Updated at: ' .. os.date("%H:%M:%S"),
            disabled = true
        })
        table.insert(self.menu, {
            title = 'Update',
            fn = function() self:update() end
        })

        self.indicator:setMenu(self.menu)
    end)

end

function obj:init()
    self.indicator = hs.menubar.new()
    self.timer = hs.timer.new(900, function() self:update() end)
end

function obj:setup(args)
    self.api_key = args.api_key

    if args.stocks ~= nil then 
        self.stocks = args.stocks
    else
        self.stocks = 'aapl,doge-usd,msft'
    end
end

function obj:start()
    self.timer:fire()
    self.timer:start()
end


return obj
