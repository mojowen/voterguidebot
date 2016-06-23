var swalSpy

beforeEach(function() {
  swalSpy = spyOn(window, 'swal')

  swalSpy.confirmLast = function(confirm) {
    this.calls.mostRecent().args[1](true)
  }
})
