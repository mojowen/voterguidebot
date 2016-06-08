describe('ImageComponent', function() {
  var transparentGif = "data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw==",
      fakeFile = {name: "test name",size: 2 * 1024 * 1024,
          width: 200,
          height: 100}

  beforeEach(function() {
    this.setUpComponent(ImageComponent, {})
    this.dropzone = this.component.dropzone
  })

  it('it renders successfully', function() {
    expect(this.dom.querySelector('.dz-clickable')).not.toEqual(null)
  })

  it('handles thumbnail by processing data', function() {
    this.dropzone._callbacks.thumbnail[1].call(this.dropzone, fakeFile, transparentGif)
    expect(this.component.state.value).toEqual(transparentGif)
  })

  it('loads existing value if passed as param')

  describe('with a callback', function() {
    beforeEach(function() {
      this.callback = function() {}
      spyOn(this, 'callback')
      this.setUpComponent(ImageComponent, { onChange: this.callback })
      this.dropzone = this.component.dropzone
    })

    it('propagates values with an onChange', function() {
      this.dropzone._callbacks.thumbnail[1].call(this.dropzone, fakeFile, transparentGif)
      expect(this.callback).toHaveBeenCalled()
    })
  })
})