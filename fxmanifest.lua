fx_version 'adamant'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

dependency "logmanager"
dependency "uiprompt"

files {
	'ui/index.xhtml',
	'ui/style.css',
	'ui/script.js',
	'ui/chineserocks.ttf',
	'ui/keyboard.ttf'
}

ui_page 'ui/index.xhtml'

client_scripts {
	'@uiprompt/uiprompt.lua',
	'config.lua',
	'client.lua'
}
