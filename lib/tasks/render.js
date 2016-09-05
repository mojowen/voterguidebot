var system = require('system')
var page = require('webpage').create()

page.viewportSize = { width: system.args[3] || '400px',
                      height: system.args[4] || '400px' }

page.paperSize = { width: system.args[3] || '400px',
                   height: system.args[4] || '400px',
                   margin: system.args[5] || '0px',
                   border: '0px' }

if( system.args.length < 3 ) {
  console.error('Incorrect arguments '+system.args.join(' '))
  phantom.exit(1)
}

var extension = system.args[2].split('.').reverse()[0]

var settings = {
  encoding: "utf8",
  localToRemoteUrlAccessEnabled: true
}

page.open(system.args[1], settings, function start(status) {
  page.render(system.args[2], { format: extension, quality: '100' })
  console.log('Rendered '+system.args[2])
  phantom.exit()
});
