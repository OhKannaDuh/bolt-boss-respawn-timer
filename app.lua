require('sloth.library')

local plugin = Plugin()
plugin.bolt.checkversion(1, 0)

plugin:load_config({
    window = {
        app = {
            showdevtools = false,
            y = 0,
            x = 0,
            height = 112,
            width = 178
        }
    }
})

local app = EmbeddedBrowser(plugin, {
    x = plugin.config.data.window.app.x,
    y = plugin.config.data.window.app.y,
    width = plugin.config.data.window.app.width,
    height = plugin.config.data.window.app.height,
    showdevtools = plugin.config.data.window.app.showdevtools,
    path = 'plugin://app/app.html'
})

plugin:save_config()

app:onmessage('close', function()
    plugin.bolt.close()
end)

plugin:start()
app:open()
