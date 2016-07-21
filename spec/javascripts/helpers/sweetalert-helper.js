var swalSpy

beforeEach(function() {
  swalSpy = spyOn(window, 'swal')

  swalSpy.confirmLast = function(confirm) {
    var most_recent = this.calls.mostRecent()
    if( typeof most_recent !== 'undefined' ) return most_recent.args[1](true)
    console.log('swalSpy.confirmLast failed - no most recent')
  }
})
