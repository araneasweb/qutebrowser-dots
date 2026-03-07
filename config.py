import catppuccin
config.load_autoconfig(False)
catppuccin.setup(c, 'mocha', True)
config.set('content.cookies.accept', 'all', 'chrome-devtools://*')
config.set('content.cookies.accept', 'all', 'devtools://*')
config.set('content.headers.accept_language', '', 'https://matchmaker.krunker.io/*')
config.set('content.images', True, 'chrome-devtools://*')
config.set('content.images', True, 'devtools://*')
config.set('content.javascript.enabled', True, 'chrome-devtools://*')
config.set('content.javascript.enabled', True, 'devtools://*')
config.set('content.javascript.enabled', True, 'chrome://*/*')
config.set('content.javascript.enabled', True, 'qute://*/*')
config.set('content.local_content_can_access_remote_urls', True, 'file:///home/aranea/.local/share/qutebrowser/userscripts/*')
config.set('content.local_content_can_access_file_urls', False, 'file:///home/aranea/.local/share/qutebrowser/userscripts/*')
config.bind(",t", "config-cycle tabs.show never always")
c.editor.command = ['ghostty', '-e', 'nvim', '{file}']
c.scrolling.bar = 'overlay'
c.scrolling.smooth = True
c.spellcheck.languages = ["en-GB"]
c.statusbar.show = 'in-mode'
c.statusbar.position = 'bottom'
c.tabs.position = 'left'
c.tabs.show = 'never'
c.tabs.show_switching_delay = 500
c.tabs.title.elide = 'none'
c.tabs.undo_stack_size = -1
c.zoom.default = '80%'
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.algorithm = 'lightness-cielab'
c.tabs.last_close= "startpage"
c.aliases['q'] = 'tab-close'
c.aliases['q!'] = 'close'
c.aliases['qa'] = 'quit'
c.aliases['w'] = 'session-save'
c.aliases['wq'] = 'quit --save'
c.aliases['wqa'] = 'quit --save'

