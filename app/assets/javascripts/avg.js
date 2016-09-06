//= require_tree ./avg

window.onload = function() {
  open_menu_overlay.onclick = function() {
    document.body.className += ' menu-overlay'
  }
  close_menu_overlay.onclick = function() {
    document.body.className = document.body.className.replace('menu-overlay', '').trim()
  }
  Array.prototype.forEach.call(
    document.querySelectorAll('.menu'),
    function(menu) {
      var top_level = menu.querySelector('a.js-menu-open'),
          active_class = 'active'

      top_level.onfocus = function() {
        if( menu.className.search(active_class) !== -1 ) return
        menu.className += ' '+active_class
        return false
      }
      top_level.onclick = function() { return false }
    }
  )
}
