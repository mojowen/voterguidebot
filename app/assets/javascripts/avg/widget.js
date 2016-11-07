function initWidget(selector) {
  var container = document.querySelector(selector),
      active = 0,
      tabs = container.querySelectorAll('.footer .nav a').length

  Array.prototype.forEach.call(
    container.querySelectorAll('.right'),
    function (el) {
      el.onclick = function() {
        goTo(active + 1)
        return false
      }
    }
  )

  Array.prototype.forEach.call(
    container.querySelectorAll('.left'),
    function (el) {
      el.onclick = function() {
        goTo(active - 1)
        return false
      }
    }
  )

  Array.prototype.forEach.call(
    container.querySelectorAll('.footer .nav a'),
    function(el, i) {
      el.onclick = function() {
        goTo(i)
        return false
      }
    }
  )

  function goTo(location) {
    active = location
    if( active < 0 ) active = tabs - 1
    if( active >= tabs ) active = 0

    container.className = container.className.replace(/widget__\d+/, 'widget__'+active)

    Array.prototype.forEach.call(
      container.querySelectorAll('.facts'),
      function(el) { deactivateNodeListExcept('.facts .fact', active, el) }
    )

    deactivateNodeListExcept('.footer .nav a', active)
    deactivateNodeListExcept('.titles .title', active)
    deactivateNodeListExcept('.tools .share-box', active)
  }

  function deactivateNodeListExcept(domQuery, except, elem) {
    var elem = elem || container
    var nodeList = elem.querySelectorAll(domQuery)

    Array.prototype.forEach.call(nodeList, function(el, i) {
      if( i === except ) el.className += ' active'
      else el.className = el.className.replace(/active/, '').trim()
    })
  }

  if( document.location.hash.match(RegExp(selector+'_\\d+')) ) {
    goTo(parseInt(document.location.hash.split('_').reverse()[0]))
  }

  container.querySelector('.js-open-code-box').onclick = function() {
    if( container.className.search('code-open') === -1 ) container.className += ' code-open'
    else container.className = container.className.replace('code-open', '').trim()
  }
  container.querySelector('.code-box textarea').onclick = function() { this.select() }

}
