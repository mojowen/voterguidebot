var system = require('system')
var page = require('webpage').create()

page.viewportSize = { width: system.args[3] || 480,
                      height: system.args[4] || 800 }


if( system.args.length < 3 ) {
  console.error('Incorrect arguments '+system.args.join(' '))
  phantom.exit(1)
}

var extension = system.args[2].split('.').reverse()[0]

page.open(system.args[1], function start(status) {
  page.render(system.args[2], { format: extension, quality: '100' })
  console.log('Rendered '+system.args[2])
  phantom.exit()
});
